# Skúška 1 – nasadenie webovej aplikácie do verejného cloudu

## Autor

Denis Vajda

## Opis aplikácie

Aplikácia Cloud Notes App je jednoduchá webová aplikácia na správu poznámok. Používateľ cez webové rozhranie pridáva poznámky. Frontend posiela požiadavky backendu a backend ich ukladá do PostgreSQL databázy.

Aplikácia je verejne dostupná cez HTTPS URL v Azure Container Apps.

## Použitý verejný cloud

Použitý bol Microsoft Azure.

Použité cloudové služby:

- Azure Container Apps – spustenie frontend a backend kontajnerov
- Azure Container Registry – uloženie Docker image
- Azure Database for PostgreSQL Flexible Server – cloudová databáza
- Azure Resource Group – logické zoskupenie zdrojov

## Komponenty aplikácie

### Frontend

Frontend beží v kontajneri s Nginx serverom. Zobrazuje HTML stránku a posiela požiadavky na backend cez cestu `/api`.

### Backend

Backend je Flask API server. Poskytuje endpointy:

- `GET /api/notes`
- `POST /api/notes`
- `GET /api/health`

Backend komunikuje s PostgreSQL databázou.

### Databáza

Databáza je Azure Database for PostgreSQL Flexible Server. Dáta sú uložené trvalo v cloudovej databáze.

## Komunikácia komponentov

Používateľ otvorí verejnú HTTPS URL frontendu.

Frontend komunikuje s backendom cez Nginx reverse proxy.

Backend komunikuje s databázou PostgreSQL cez premenné prostredia:

- DB_HOST
- DB_NAME
- DB_USER
- DB_PASSWORD
- DB_PORT
- DB_SSLMODE

## Konfigurácia a secrets

Konfigurácia aplikácie je cez súbor `.env`.

Súbor `.env` sa neposiela do Gitu. Do Gitu sa posiela iba `.env.example`.

Prístupové údaje, hlavne DB_PASSWORD, sú uložené iba lokálne v `.env`.

## Súbory projektu

- `backend/app.py` – Flask backend API
- `backend/Dockerfile` – Dockerfile pre backend
- `backend/requirements.txt` – Python závislosti
- `frontend/index.html` – webové rozhranie
- `frontend/default.conf.template` – Nginx konfigurácia
- `frontend/Dockerfile` – Dockerfile pre frontend
- `render.yaml` – Render Blueprint konfigurácia, ktorá automaticky vytvorí frontend service, backend service a PostgreSQL databázu v cloud prostredí Render
- `prepare-app.sh` – skript na kontrolu súborov a test Docker buildov pred nasadením aplikácie
- `remove-app.sh` – návod na odstránenie Render služieb a databázy
- `.gitignore` – súbory, ktoré sa neposielajú do Gitu

## Podmienky spustenia skriptov

Na počítači musí byť nainštalované:

- Git Bash alebo Bash
- Docker
- Azure CLI
- aktívne prihlásenie do Azure cez `az login`
- oprávnenie vytvárať Azure zdroje

Pred spustením treba vytvoriť `.env`:

```bash
cp .env.example .env