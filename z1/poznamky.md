Docker je platforma na vytváranie a spúšťanie aplikácií v kontajneroch. Kontajner obsahuje aplikáciu spolu so všetkými potrebnými knižnicami a konfiguráciou.

Výhoda:
-aplikácia funguje rovnako na každom počítači
-jednoduché nasadenie
-izolované prostredie
-Image vs Container
-Image
#Image je šablóna aplikácie.

Príklady:
-python:3.11-slim
-nginx:alpine
-postgres:16
-Container
#Container je spustená verzia image.

Príklady:
-zkt_frontend
-zkt_backend
-zkt_db
-Dockerfile
#Dockerfile opisuje, ako sa vytvorí image.

Používa sa:
-základný image
-kopírovanie súborov
-inštalácia knižníc
-nastavenie štartu aplikácie

Príklad:
-backend používa Python + Flask
-frontend používa Nginx
-Docker Compose
#Docker Compose slúži na spustenie viacerých kontajnerov naraz pomocou jedného YAML súboru.#

V projekte:
-frontend
-backend
-PostgreSQL
-Adminer
-Docker Network
#Docker network umožňuje komunikáciu medzi kontajnermi.
#Backend komunikuje s databázou pomocou názvu služby:
db

#Frontend komunikuje s backendom.

Docker Volume
#Volume slúži na trvalé uloženie dát.

Použitý volume:
zkt_db_data

#Dáta zostanú zachované aj po zastavení kontajnera.
Frontend
#Frontend je používateľské rozhranie aplikácie.

Použitý:
-HTML
-Nginx
#Frontend zobrazuje stránku a posiela požiadavky backendu.

Backend
#Backend je API server.

Použitý:
-Flask
-Python

Backend:
-prijíma požiadavky
-komunikuje s databázou
-vracia odpovede frontend aplikácii
-PostgreSQL
#PostgreSQL je relačná databáza.

Databáza ukladá:
-id poznámky
-text poznámky
-Adminer
#Adminer je webové rozhranie na správu databázy.

Umožňuje:
-zobraziť tabuľky
-zobraziť dáta
-pracovať s databázou cez web
-Fungovanie aplikácie

#Používateľ zadá poznámku.
#Frontend pošle požiadavku backendu.
#Backend uloží poznámku do PostgreSQL.
#Databáza uloží dáta.
#Frontend zobrazí uloženú poznámku.

Bash skripty:
-prepare-app.sh
#Pripraví prostredie aplikácie.

-start-app.sh
#Spustí všetky kontajnery.

-stop-app.sh
#Zastaví kontajnery.

-remove-app.sh
#Odstráni kontajnery, siete a volume.

2. Kubernetes
Kubernetes je orchestrátor kontajnerov.

Slúži na:
-správu kontajnerov
-automatické obnovovanie
-komunikáciu služieb
-škálovanie aplikácií
-Pod
#Pod je základná jednotka v Kubernetes.
#V pode beží jeden alebo viac kontajnerov.

Príklady:
-frontend pod
-backend pod
-postgres pod
-Deployment
#Deployment spravuje pody aplikácie.

Použitý:
-frontend
-backend

Deployment zabezpečuje:
-vytvorenie podov
-automatický restart
-správu aplikácie
-StatefulSet
#StatefulSet sa používa pre stavové aplikácie.

Použitý:
-PostgreSQL databáza

Databáza potrebuje:
-stabilné meno
-zachovanie dát
-persistent storage
-Service
#Service zabezpečuje komunikáciu medzi podmi.

Použité služby:
-frontend-service
-backend-service
-db-service
#Backend komunikuje s databázou cez db-service.

Namespace:
#Namespace slúži na logické oddelenie Kubernetes objektov.

Použitý namespace:
-zkt-notes
-PersistentVolume (PV)

#PersistentVolume predstavuje trvalé úložisko v Kubernetes.
#Používa sa na uchovanie databázových dát.
#PersistentVolumeClaim (PVC)
#PersistentVolumeClaim slúži na pripojenie storage k podu.
#Databáza používa PVC na pripojenie PersistentVolume.

Port-forward:
#Port-forward umožňuje prístup ku Kubernetes službe z localhostu.

Použitý príkaz:
-kubectl port-forward service/frontend-service 8088:80 -n zkt-notes

Aplikácia je dostupná na:
-http://localhost:8088
-Persistence dát

Pri zmazaní databázového podu:
-kubectl delete pod postgres-0 -n zkt-notes
-sa pod obnoví, ale dáta zostanú zachované.

Dôvod:
-PersistentVolume
-PersistentVolumeClaim

Rozdiel Docker a Kubernetes:

Docker:
-spúšťa kontajnery

Kubernetes:
-spravuje kontajnery automaticky
-obnovuje pody
-prepája služby
-pracuje so storage


Docker:
Docker je platforma na spúšťanie aplikácií v kontajneroch.

Kubernetes:
Kubernetes je orchestrátor alebo organizátor kontajnerov.

Deployment:
Deployment spravuje frontend a backend pody.

StatefulSet:
StatefulSet sa používa pre databázu a zachovanie stavu.

Service:
Service zabezpečuje komunikáciu medzi podmi.

PersistentVolume:
PersistentVolume uchováva dáta databázy.

Prečo používa databáza StatefulSet?:
Pretože databáza potrebuje zachovanie dát a stabilnú identitu.

Ako frontend komunikuje s backendom?:
Frontend posiela HTTP požiadavky backendu.

Ako backend komunikuje s databázou?:
Backend sa pripája cez db-service.

PORT_FORWARD:
Sprístupní Kubernetes službu na localhoste.