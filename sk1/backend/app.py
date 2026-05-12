from flask import Flask, request, jsonify
from flask_cors import CORS
import os
import psycopg2
import time

app = Flask(__name__)
CORS(app)

DATABASE_URL = os.getenv("DATABASE_URL")


def get_connection():
    return psycopg2.connect(DATABASE_URL, sslmode="require")


def init_db():
    for _ in range(30):
        try:
            conn = get_connection()
            cur = conn.cursor()
            cur.execute("""
                CREATE TABLE IF NOT EXISTS notes (
                    id SERIAL PRIMARY KEY,
                    content TEXT NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
            """)
            conn.commit()
            cur.close()
            conn.close()
            print("Database initialized.")
            return
        except Exception as e:
            print("Waiting for database...", e)
            time.sleep(3)


@app.route("/api/health", methods=["GET"])
def health():
    return jsonify({"status": "ok"}), 200


@app.route("/api/notes", methods=["GET"])
def get_notes():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT id, content FROM notes ORDER BY id ASC;")
    rows = cur.fetchall()
    cur.close()
    conn.close()

    notes = [{"id": row[0], "content": row[1]} for row in rows]
    return jsonify(notes), 200


@app.route("/api/notes", methods=["POST"])
def add_note():
    data = request.get_json()
    content = data.get("content", "").strip()

    if not content:
        return jsonify({"error": "Content is required"}), 400

    conn = get_connection()
    cur = conn.cursor()
    cur.execute(
        "INSERT INTO notes (content) VALUES (%s) RETURNING id;",
        (content,)
    )
    note_id = cur.fetchone()[0]
    conn.commit()
    cur.close()
    conn.close()

    return jsonify({"id": note_id, "content": content}), 201


init_db()