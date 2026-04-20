# Zadanie 2 – Kubernetes webová aplikácia

## Autor
Meno a priezvisko: [DOPLŇ]

## Opis aplikácie

Aplikácia je jednoduchá webová aplikácia na správu poznámok. Používateľ zadáva poznámky cez webové rozhranie. Frontend posiela požiadavky na backend API a backend ukladá dáta do databázy PostgreSQL. Dáta zostávajú zachované vďaka PersistentVolume.

## Zoznam použitých kontajnerov

- `z2-frontend:latest` – Nginx server pre statický frontend
- `z2-backend:latest` – Flask backend API
- `postgres:16` – databáza PostgreSQL

## Zoznam Kubernetes objektov

- `Namespace` – menný priestor `zkt-notes`
- `Deployment` – frontend
- `Deployment` – backend
- `StatefulSet` – PostgreSQL databáza
- `Service` – frontend-service
- `Service` – backend-service
- `Service` – db-service
- `Service` – db-headless
- `PersistentVolume` – postgres-pv
- `PersistentVolumeClaim` – postgres-pvc

## Opis virtuálnych sietí a zväzkov

Kubernetes používa internú sieť clusteru. Jednotlivé pody komunikujú cez Service objekty pomocou DNS názvov:
- `frontend-service`
- `backend-service`
- `db-service`

Trvalé uloženie dát zabezpečuje:
- `PersistentVolume` – postgres-pv
- `PersistentVolumeClaim` – postgres-pvc

## Opis konfigurácie kontajnerov

Frontend beží na porte 80 a cez Nginx reverse proxy posiela požiadavky `/api/` na backend-service. Backend beží na porte 5000 a komunikuje s PostgreSQL databázou cez db-service na porte 5432. PostgreSQL beží v StatefulSet objekte.

## Návod na prípravu aplikácie

```bash
./prepare-app.sh

## Návod na spustenie aplikácie

./start-app.sh

## Návod na zastavenie aplikácie

./stop-app.sh

## Návod ako si pozrieť aplikáciu v prehliadači

http://localhost:30080


