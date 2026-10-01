---
typ: wissen
thema: Datenbanken SQL
tags: [sql, transaktion, acid]
quelle: Word-Notizen
status: importiert
---
# SQL - Transaktionen und Locks

Thema: [[Datenbanken SQL]]

# ACID-Prinzip (Datenbanken / Transaktionen)

**A**tomicity (Atomarität)

·         „Ganz oder gar nicht“-Prinzip

·         Eine Transaktion wird entweder vollständig ausgeführt oder komplett zurückgesetzt

·         Verhindert Teiländerungen

Syntax-Beispiel:

```sql
BEGIN TRANSACTION;
UPDATE [Tabelle]
SET <Spalte> = <Spalte> <Operator> <Veränderung>
WHERE <Suchbedingung>;
UPDATE [Tabelle]
SET <Spalte> = <Spalte> <Operator> <Veränderung>
WHERE <Suchbedingung>;
COMMIT;
```
**C**onsistency (Konsistenz)

·         Daten bleiben immer in einem gültigen Zustand

·         Regeln und Constraints werden eingehalten

·         Keine widersprüchlichen Daten

```sql
BEGIN TRANSACTION;
UPDATE [Tabelle]
SET <Spalte> = <Spalte> <Operator> <Veränderung>
WHERE <Suchbedingung>;
```
### **(Fehler tritt auf, daher Rollback)**

### ROLLBACK;

**I**solation (Isolation)

·         Gleichzeitige Transaktionen beeinflussen sich nicht gegenseitig

·         Jede Transaktion läuft unabhängig ab

·         Verhindert Konflikte bei parallelem Zugriff

```sql
BEGIN TRANSACTION;
UPDATE [Tabelle]
SET <Spalte> = <Spalte> <Operator> <Veränderung>
WHERE <Suchbedingung>;
```
### **(noch kein COMMIT, daher änderbar)**

**D**urability (Dauerhaftigkeit)

·         Nach erfolgreichem Abschluss bleiben Daten dauerhaft gespeichert

·         Daten gehen auch bei Systemabsturz nicht verloren

·         Speicherung erfolgt zuverlässig im System

```sql
BEGIN TRANSACTION;
UPDATE [Tabelle]
SET <Spalte> = <Spalte> <Operator> <Veränderung>
WHERE <Suchbedingung>;
COMMIT;
```
## Was sind Transaktionen und wofür sind diese gut?

Transaktionen sind eine Reihe von abhängigen Befehlen, die nur zusammen durchgeführt werden können, damit diese mit der Realität übereinstimmen.

Z.B. Wareneingang - Ausgang oder Geldtransfer auf Konten.

## COMMIT bei SQL-Express

[[SQL]]-Express hat ein Auto-Commit, daher werden trotz BEGIN TRANSACTION die Änderungen übernommen.

# Verschiedene SQL-Syntax mit TRANSACTION

## TRANSACTION mit TRY/CATCH

```sql
BEGIN TRY
            BEGIN TRANSACTION
            << Vorgenommene Transaktion >>
            COMMIT;
END TRY
            (Wenn Fehler dann:)
            ROLLBACK;
            SELECT ERROR_MESSAGE() AS <Fehler>;
END CATCH;
```
## TRANSACTION mit SAVEPOINT

```sql
BEGIN TRANSACTION
            << Vorgenommene Transaktion >>
SAVE TRANSACTION <SaveName>
            COMMIT << Falls korrekt
            oder ROLLBACK <SaveName>
```
## Wie kann man die Logdateien Größe sehen?

DBCC SQLPERF(LOGSPACE);

## Was sagt SEMAPHORE aus?

Ein Austausch, z.B. Probleme beim Austausch mit anderen Dateien, da geblockt.

## Was ist ein PRIMARY KEY CLUSTERED?

Verwandelt den PK in einen Index, zu lasten von Einfüge- und Updateperformance. Dafür ist SELECT schnell.

(Genutzt, um schnellere Abfrage bei häufigen Abfragen zu gewährleisten)

## Wie sieht man die offenen und gelaufenen Sessions?

```sql
SELECT
    session_id,
    login_name,
    host_name,
    program_name,
    status,
    login_time
FROM sys.dm_exec_sessions
ORDER BY session_id;
GO
DBCC OPENTRAN;
GO
```
## Besondere Befehle

```sql
@@TRANCOUNT AS TranCount
```
Zählt die offenen Transaktionen.

```sql
XACT_STATE() AS XactState,
```
**Sinn und Zweck:**
Prüft den Zustand der aktuellen Transaktion.

**Verwendung:**
Um festzustellen, ob eine Transaktion noch gültig ist oder nur noch zurückgerollt werden kann.

```sql
ERROR_MESSAGE() AS Fehlermeldung;
```
**Sinn und Zweck:**
Liefert die genaue Fehlermeldung des zuletzt aufgetretenen Fehlers.

**Verwendung:**
Zur Fehleranalyse und Protokollierung im CATCH-Block.

```sql
Benutzer Identifizieren
```
login_name                          Benutzername

host_name                           Computername

program_name                    Programm

## Was ist ein Shared und ein Exclusive Lock?

Shared Lock

ist, wenn bei mehrere Benutzer gleichzeitiges lesen erlaubt ist.

Mehrere SL sind gleichzeitig erlaubt, verändern der Daten nicht.

Exclusiv Lock

verhindert, dass mehrere Benutzer gleichzeitig lesen und manipulieren können.

## Was ist eine Page und ein Block?

Block besteht aus 8 zusammenhängenden 8 KB-Seiten (Pages).

Dienen zur Datenspeicherung in Datenbanken.

Dateinamen .mdf oder .ndf.

Datenbankoptionen

AUTO_CLOSE         Wenn der letzte Benutzer seine DB beendet, wird die Datenbank geschlossen.

AUTO_SHRINK       Wenn Option aktiviert, skaliert die Datenbank periodisch auf die benötigte Größe runter.

READ_ONLY           READ_ONLY berechtigt Benutzer nur noch zum lesen. Z.B. bei

                                    Archivierung wichtig.

REVOVERY FULL  Mit Sicherung, Datenbank- und Transaktionsprotokollen können

                                    DB bei Medienfehler vollständig wiederhergestellt werden.
