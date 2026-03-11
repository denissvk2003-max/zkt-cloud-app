from flask import Flask, request, jsonify
from flask_cors import CORS
import os
import psycopg2
import time

app = Flask(__name__)
CORS(app)

DB_HOST = os.getenv("DB_HOST", "db")
DB_NAME = os.getenv("DB_NAME", "notesdb")
DB_USER = os.getenv("DB_USER", "notesuser")
DB_PASSWORD = os.getenv("DB_PASSWORD", "notessecret")
DB_PORT = os.getenv("DB_PORT", "5432")

def get_connection():
    return psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        port=DB_PORT
    )

def init_db():
    for _ in range(20):
        try:
            conn = get_connection()
            cur = conn.cursor()
            cur.execute("""
                CREATE TABLE IF NOT EXISTS notes (
                    id SERIAL PRIMARY KEY,
                    content TEXT NOT NULL
                );
            """)
            conn.commit()
            cur.close()
            conn.close()
            print("Database initialized.")
            return
        except Exception as e:
            print("Waiting for database...", e)
            time.sleep(2)

@app.route("/api/notes", methods=["GET"])
def get_notes():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT id, content FROM notes ORDER BY id ASC;")
    rows = cur.fetchall()
    cur.close()
    conn.close()

    notes = [{"id": r[0], "content": r[1]} for r in rows]
    return jsonify(notes)

@app.route("/api/notes", methods=["POST"])
def add_note():
    data = request.get_json()
    content = data.get("content")

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

    return jsonify({"id": note_id, "content": content})

if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=5000)