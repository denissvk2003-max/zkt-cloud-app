# Zadanie 1 – Docker webová aplikácia

## Autor
Meno a priezvisko: [Denis Vajda]
Predmet: Základy klaudových technológií

## Opis aplikácie

Aplikácia je jednoduchá webová aplikácia na správu poznámok. Používateľ cez webové rozhranie zadáva textové poznámky, ktoré sa ukladajú do databázy PostgreSQL. Frontend je poskytovaný pomocou webového servera Nginx, backend je implementovaný vo Flasku a databáza beží v kontajneri PostgreSQL. Súčasťou riešenia je aj Adminer na správu databázy cez webové rozhranie.

## Podmienky na nasadenie a spustenie

Pre spustenie aplikácie je potrebný nasledovný softvér:

- Linux
- Docker
- Docker Compose plugin (`docker compose`)
- Bash shell

## Zoznam použitých kontajnerov a stručný opis

### frontend
- obraz: `nginx:alpine`
- poskytuje statický frontend a reverzný proxy na backend

### backend
- vlastný obraz vytvorený z `python:3.11-slim`
- poskytuje REST API

### db
- obraz: `postgres:16`
- relačná databáza pre trvalé uloženie dát

### adminer
- obraz: `adminer:latest`
- webové rozhranie pre databázu

## Opis virtuálnych sietí a pomenovaných zväzkov

### Virtuálna sieť
Aplikácia používa Docker sieť:
- `zkt_app_net`

Táto sieť umožňuje komunikáciu medzi kontajnermi.

### Pomenovaný zväzok
Aplikácia používa Docker volume:
- `zkt_db_data`

Tento zväzok uchováva dáta PostgreSQL aj po zastavení kontajnerov.

## Opis konfigurácie kontajnerov

### frontend
- host port `8080` je mapovaný na port `80` v kontajneri
- Nginx servíruje `index.html`
- požiadavky na `/api/` posiela backendu

### backend
- beží na porte `5000`
- používa premenné prostredia pre pripojenie na databázu

### db
- beží na porte `5432`
- používa pomenovaný zväzok na trvalé dáta

### adminer
- host port `8081` je mapovaný na port `8080` v kontajneri

## Návod na prípravu aplikácie

```bash
./prepare-app.sh