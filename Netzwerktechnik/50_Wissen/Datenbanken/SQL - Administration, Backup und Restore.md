---
typ: wissen
thema: Datenbanken SQL
tags: [sql, backup, ssms]
quelle: Word-Notizen
status: importiert
---
# SQL - Administration, Backup und Restore

Thema: [[Datenbanken SQL]]

# Primary Filegroup / Dateigruppen

Was ist die PRIMARY FILEGROUP?
Standard-Dateigruppe der Datenbank. Enthält standardmäßig neu angelegte Tabellen und Indizes.

### Wie kann ich Dateigruppen prüfen?

sys.tables
Liefert die vorhandenen Tabellen der Datenbank.

sys.indexes
Enthält Informationen zum Speicherort der Tabellen/Indizes.

sys.filegroups
Enthält die vorhandenen Dateigruppen (z. B. PRIMARY, RO_Data).

## ZUORDNUNG TABELLE → DATEIGRUPPE
Über Join von sys.tables, sys.indexes und sys.filegroups ermitteln, in welcher Dateigruppe eine Tabelle liegt.

## Was macht der Snapshot bei der Datenbank

COPY-on-Write-Verfahren.

Der Snapshot legt bei Veränderung (UPDATE, DELETE, INSERT) die nicht veränderten Daten ab. Dadurch kann mit den Quell-Daten verglichen werden und der Zustand zum Zeitpunkt des Snapshots nachempfunden werden.

## Wie kann man eine DB auf einen Punkt zurücksetzen?

Datenbank master auswählen

```sql
USE master;
```
### Alle User rauswerfen:

```sql
ALTER DATABASE [Datenbank]
SET SINGLE_USER;
Dann der Restore:
RESTORE DATABASE [Datenbank]
FROM DATABASE_SNAPSHOT [Snapshot.Datenbank];
```
Was ist eine UUID?

(Universal Unique Identitfier)

Eine 16 stellige, weltweit einzigartige ID.

Syntax

ID UNIQUEIDENTIFIERT

## Wie erstellt man einen Snapshot?

```sql
CREATE DATABASE [Snapshot.Datenbank_Snapshot]
ON
(
            NAME = [Quell.Datenbank],
            FILENAME  =  `[\\Ort](file://Ort).der .Speicherung(z.B.Festplatte)‘
)
AS SNAPSHOT OF [Quell.Datenbank];
```
Partition Function erstellen
CREATE PARTITION FUNCTION <Name.PartitionFunction> (<Datentyp>)
AS RANGE LEFT | RANGE RIGHT
FOR VALUES (<Grenzwert1>, <Grenzwert2>, ...);

-- Partition Scheme erstellen
CREATE PARTITION SCHEME <Name.PartitionScheme>
AS PARTITION <Name.PartitionFunction>
TO
(
<Filegroup1>,
<Filegroup2>,
...
);

Tabelle partitionieren
CREATE TABLE <Tabellenname>
(
<Spalten>
)
ON <Name.PartitionScheme>(<Partitionsspalte>);

Neue Partition hinzufügenALTER PARTITION SCHEME <Name.PartitionScheme>
NEXT USED <Filegroup>;

Partition trennenALTER PARTITION FUNCTION <Name.PartitionFunction>()
SPLIT RANGE (<Grenzwert>);Partitionen zusammenführenALTER PARTITION FUNCTION <Name.PartitionFunction>()
MERGE RANGE (<Grenzwert>);Partitionsnummer eines Datensatzes anzeigenSELECT
*,
$PARTITION.<Name.PartitionFunction>(<Partitionsspalte>)
AS Partitionsnummer
FROM <Tabelle>;
Vorhandene Grenzwerte anzeigenSELECT *
FROM sys.partition_range_values;
Vorhandene Partition Functions anzeigenSELECT *
FROM sys.partition_functions;

Vorhandene Partition Schemes anzeigen
SELECT *
FROM sys.partition_schemes;

Filegroup für neue Partition festlegen
ALTER PARTITION SCHEME <Name.PartitionScheme>
NEXT USED <Filegroup>;

Zusätzliche Filegroup anlegenALTER DATABASE <Datenbankname>
ADD FILEGROUP <Filegroup>;Datei zu einer Filegroup hinzufügenALTER DATABASE <Datenbankname>
ADD FILE
(
NAME = <Dateiname>,
FILENAME = '<Pfad>'
)
TO FILEGROUP <Filegroup>;

## Was macht Defragmentieren bei SQL-Datenträgern?

Beim Arbeiten mit Datenbanken entstehen durch INSERT, UPDATE und DELETE viele verstreute Datenblöcke (Fragmentierung).
Die Daten liegen dadurch nicht mehr „sauber hintereinander“, sondern verteilt auf der Festplatte.
Defragmentierung ordnet diese Daten wieder zusammenhängend an, sodass sie schneller gelesen werden können.

## Wer darf Backups durchführen?

1. sysadmin

2. db_owner

3. db_backupoperator

## Was macht ein Backup in SSMS ?

Ein Backup ist eine **Sicherung einer Datenbank**, um Daten bei Fehlern, Defekten oder Verlust wiederherstellen zu können.

# Arten von Backups

## RECOVERYSTATUS von einfach auf FULL setzen.

```sql
ALTER DATABASE [Datenbank]
SET RECOVERY FULL;
```
Vollbackup (Full Backup)
→ Sichert die komplette Datenbank (alle Daten + Struktur).
→ Grundlage für alle weiteren Backup-Arten.

**Erstes DB-Backup:**

```sql
BACKUP DATABASE [Datenbankname]
TO DISK = '<Festplatte>:\Speicherpfad\[Datenbankname].bak';
```
**Neuen Sicherungssatz beginnen(alte wird überschrieben):**

```sql
BACKUP DATABASE [Datenbankname]
TO DISK = '<Festplatte>:\Speicherpfad\[Datenbankname].bak'
WITH INIT, FORMAT;
```
**DB-Backup mit Beschreibung und Kompression:**

```sql
BACKUP DATABASE [Datenbankname]
TO DISK = '<Festplatte>:\Speicherpfad\[Datenbankname].bak'
WITH INIT, FORMAT, COMPRESSION,
    NAME = 'Name Backup',
    DESCRIPTION = 'Beschreibung Backup, z.B. Tägliches Backup';
```
Differenzielles Backup
→ Sichert nur die Änderungen seit dem letzten Vollbackup.
→ Schneller und kleiner als ein Vollbackup.

```sql
BACKUP DATABASE [Datenbankname]
TO DISK = '<Festplatte>:\Speicherpfad\[Datenbankname].bak'
WITH DIFFERENTIAL;
```
## TRANSAKTIONSLOG-BACKUP (LDF- / LOG-BACKUP)

→ Sichert alle Änderungen seit dem letzten Log-Backup

→ Wichtig für eine Wiederherstellung bis zu einem bestimmten Zeitpunkt

Syntax einfach:

```sql
BACKUP LOG [Datenbankname]
TO DISK = '<Festplatte>:\Speicherpfad\[Datenbankname]_Log.trn';
```
Syntax mit Beschreibung:

```sql
BACKUP (DATABASE) LOG [Datenbankname]
TO DISK = '<Festplatte>:\Speicherpfad\[Datenbankname]_Log.trn'
WITH NAME = 'Log Backup - z.B. Zeitpunkt 10:00 Uhr';
```
Syntax für mehrere Logs in einer Datei.

```sql
BACKUP LOG [Datenbankname]
TO DISK = 'E:\Backups\TeachSQL_Log.trn'
WITH NOINIT;
```
Erklärung:

WITH NOINIT:

→ Log-Backups werden an dieselbe Datei ANGEHÄNGT

→ Mehrere Backup-Sätze in einer Datei

→ später Restore mit FILE = x möglich

WITH INIT:

→ überschreibt vorhandene Backups in der Datei

→ alte Log-Backups gehen verloren

## Tail-Log-Backup

Sichert bei Crash die letzten noch nicht gesicherten Transaktionen im Transaktionsprotokoll.

```sql
`BACKUP LOG [Datenbankname]`
```
TO `DISK` = '<Festplatte>:\Speicherpfad\TailLog.trn'
WITH NOREC`OVERY;`

# Backup-Wiederherstellung

## Von Vollbackups (Full Backups)

Nur Vollbackup wiederherstellen:

```sql
RESTORE DATABASE [Datenbank] FROM DISK =  <FullBackup>
WITH RECOVERY;
```
## Von Differenziellen Backups

```sql
Zuerst Vollbackup, danach Differenzielles Backup:
RESTORE DATABASE [Datenbank]
```
FROM DISK =  <FullBackup>
WITH NORECOVERY;

```sql
RESTORE DATABASE [Datenbank]
```
FROM DISK =  <DifferentialBackup>
WITH RECOVERY;

Wichtig:

Ein differenzielles Backup wird mit RESTORE DATABASE wiederhergestellt, nicht mit RESTORE LOG.

## Von Transaktionslog-Backups (Log-Backup)

Zuerst Vollbackup, anschließend alle Log-Backups in der richtigen Reihenfolge:

```sql
RESTORE DATABASE [Datenbank]
FROM DISK =  <FullBackup>
WITH NORECOVERY;
RESTORE LOG [Datenbank]
FROM DISK =  <LogBackup1>
WITH NORECOVERY;
RESTORE LOG [Datenbank]
FROM DISK =  <LogBackup2>
WITH NORECOVERY;
RESTORE LOG [Datenbank]
FROM DISK = <LetztesLogBackup>
WITH RECOVERY;
```
Hinweis:

- Jedes Log-Backup enthält die Änderungen seit dem vorherigen Log-Backup.

- Alle Log-Backups müssen in der richtigen Reihenfolge eingespielt werden.

TRANSAKTIONSLOG-BACKUP (MIT FILE = x)
RESTORE DATABASE [Datenbank]
FROM DISK = <FullBackup>
WITH NORECOVERY;
Dann Log-Backups aus einer Datei (Reihenfolge beachten):

RESTORE LOG [Datenbank]
FROM DISK = <LogBackupDatei>
WITH FILE = 1,
NORECOVERY;

RESTORE LOG [Datenbank]
FROM DISK = <LogBackupDatei>
WITH FILE = 2,
RECOVERY;

Hinweis:
- WITH FILE = x wählt einen bestimmten Backup-Satz innerhalb einer Datei
- Reihenfolge der FILEs muss korrekt sein

## Tail-Log-Backup

Falls vorhanden, wird es als letztes wiederhergestellt:

```sql
RESTORE LOG [Datenbank]
FROM <TailLogBackup>
WITH RECOVERY;
```
Hinweis:

- Enthält die letzten noch nicht gesicherten Transaktionen.

- Verhindert Datenverlust unmittelbar vor der Wiederherstellung.

## Wie macht man ein GUI-Backup in SSMS?

→ Rechtsklick auf Datenbank → **Tasks → Backup**
→ Backup-Typ auswählen (Full / Differential / Log)
→ Speicherort festlegen → Starten

## Partition hinzufügen:

```sql
ALTER PARTITION SCHEME <Schementabelle>
```
NEXT USED <ausgewählte.Filegroup>;
GO
ALTER PARTITION FUNCTION <Schementabelle>()
SPLIT RANGE (<Trennpunkt>);
GO
