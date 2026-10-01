---
typ: wissen
thema: Programmierung
tags: [git, versionsverwaltung]
quelle: Word-Notizen
status: importiert
---
# Git Versionsverwaltung

Thema: [[Programmierung]]

# SQL-ADMIN

## Was ist ein GitHub-Repository?

Ein **GitHub-Repository** ist ein Projektordner auf der Plattform GitHub, der mit dem Versionsverwaltungssystem [[Git]] verwaltet wird.
Darin werden Dateien, Änderungen und verschiedene Bearbeitungsstände gespeichert. Repositories können **öffentlich** oder **privat** sein.

# Grundbegriffe der Versionsverwaltung

Repository                            Speicherort eines Projekts mit allen Versionen

_Clone_                                     git clone <Repository-URL>

_(z.B. git clone https://github.com/<Benutzer>/<Repository>.git)_

add                                         Neue oder geänderte Datei zur Versionsverwaltung vormerken

                                               git add <Datei.sql> oder . _für alle Dateien_

commit                                   Änderungen lokal speichern/bestätigen

```bash
git commit -m "<Commit-Nachricht>"
```
push                                      Lokale Commits in das entfernte (Remote-)Repository hochladen

```bash
git push <Remote> <Branch>
```
pull                                         Änderungen aus dem Remote-Repository herunterladen und übernehmen

init                                          Initiieren/erstellen eines neuen Git-Repositories

```bash
cd <Projektordner> git init
```
fetch                                      lädt aktuelle Version des Git-Repositories, danach kann entschieden werden, welche Teile der Aktualisierungen übernommen werden.

```bash
git fetch <Remote>
```
## Wann kann „gepullt“ werden?

Ein pull kann durchgeführt werden, wenn die eigenen Änderungen vorher behandelt wurden:

**- committed** wurden (lokal gespeichert)

oder

- **zurückgesetzt/verworfen** wurden

Der Grund:
Beim Pull werden die Änderungen aus dem Remote-Repository mit den lokalen Dateien zusammengeführt. Wenn dieselben Dateien unterschiedlich verändert wurden, können **Konflikte (Merge-Konflikte)** entstehen. Dann muss entschieden werden, welche Änderungen übernommen werden sollen.

Abbildung 1 GitHub-Bearbeitung Schaubild

## Was ist ein Branch? (Verästelung // Unterversion)

So kann man neue Funktionen testen, ohne die stabile Hauptversion zu gefährden.

main                           Hauptversion des Projekts

feature-login             neuer Branch für eine Login-Funktion

## Wichtige Branch-Befehle

git branch                              Branches anzeigen

git branch name                  neuen Branch erstellen

git checkout name               zu einem Branch wechseln

git switch name                    moderner Befehl zum Wechseln

git merge                               Branches zusammenführen

# Wichtige Mechaniken in SQL-Git

```bash
git revert
```
erstellt einen neuen Commit, der die aktuellen Änderungen auf den Stand eines früheren Commits rückgängig macht.
Im Gegensatz zu git reset wird die Git-Historie dabei nicht überschrieben — deshalb ist revert sicher für gemeinsame Branches.

```bash
git add
```
Fügt geänderte Dateien zur Staging Area hinzu, damit sie für den nächsten Commit vorgemerkt sind.

```bash
git add remote
```
Verknüpft das lokale Repository mit einem entfernten Repository (Remote), z. B. auf

GitHub oder GitLab.

```bash
git init
```
Mit git init wird in einem Ordner ein neues lokales Git-Repository angelegt.

```bash
git comm
```
Speichert die Änderungen lokal mit einer Beschreibung (Commit-Nachricht).

```bash
git push
```
Lädt lokale Commits in das entfernte Repository (z. B. origin/main) hoch.

```bash
git pull
```
Holt neue Änderungen vom Remote-Repository und integriert sie direkt in den

lokalen Branch.

Push abgelehnt (rotes X)
Der Push schlägt fehl, weil auf dem Remote-Repository inzwischen neue Änderungen vorhanden sind.
Lösung: Erst git fetch + git merge (oder git pull) ausführen und danach erneut git push.

```bash
git fetch
```
Lädt neue Änderungen vom Remote-Repository herunter, ohne sie automatisch zu übernehmen.

git merge
Führt die heruntergeladenen Änderungen mit dem aktuellen lokalen Branch zusammen.

```bash
git ignore
```
Dateien anzeigen, die nicht getracked werden sollen.
