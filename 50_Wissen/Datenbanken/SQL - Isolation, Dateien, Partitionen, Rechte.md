---
typ: wissen
thema: Datenbanken SQL
tags: [sql, partition, rechte, bcp]
quelle: Word-Notizen
status: importiert
---
# SQL - Isolation, Dateien, Partitionen, Rechte

Thema: [[Datenbanken SQL]]

> [!warning] Korrekturen
> - „Right-Ahead Protokoll“ heißt **Write-Ahead Logging** (WAL)

# SQL-Isolationslevel (von schwach nach stark)

## 1. Read Uncommitted.

Niedrigstes Isolationslevel. Eine Transaktion darf Daten lesen, die von einer anderen Transaktion geändert, aber noch nicht bestätigt (COMMIT) wurden.

Mögliche Probleme:

✔ Dirty Reads möglich

✔ Non-Repeatable Reads möglich

✔ Phantom Reads möglich

**Einsatz**:
Wenn maximale Performance wichtiger ist als Datenkonsistenz.

**Syntax:**

```sql
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
```
GO

## 2. Read Committed.

Standard-Isolationslevel in vielen Datenbanksystemen (z. B. SQL Server). Es können nur bereits bestätigte Daten gelesen werden.

✘ Dirty Reads

✔ Non-Repeatable Reads möglich

✔ Phantom Reads möglich

**Einsatz**:
Guter Kompromiss zwischen Performance und Datenkonsistenz.

**Syntax:**

```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
```
GO

## 3. Repeatable Read

Alle gelesenen Datensätze bleiben während der gesamten Transaktion unverändert. Mehrfaches Lesen derselben Zeile liefert immer das gleiche Ergebnis.

✘ Dirty Reads

✘ Non-Repeatable Reads

✔ Phantom Reads möglich

**Einsatz:**
Wenn während einer Transaktion dieselben Datensätze mehrfach gelesen werden müssen.

**Syntax:**

```sql
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
```
GO

## 4. Serializable

Höchstes Isolationslevel. Transaktionen werden so behandelt, als würden sie nacheinander ausgeführt. Neue Datensätze können nicht in den von der Transaktion gelesenen Wertebereich eingefügt werden.

✘ Dirty Reads

✘ Non-Repeatable Reads

✘ Phantom Reads

**Einsatz:**
Maximale Datenkonsistenz, jedoch mit höherem Sperraufwand und geringerer Performance.

**Syntax**:

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```
GO

## Was sind die drei Haupttypen von Daten in SQL?

(MDF = Hauptdaten, NDF = Zusatzdaten, LDF = Protokoll der Änderungen)

## .MDF (Master Data File)
→ Hauptdatenbankdatei in Microsoft SQL Server. Enthält die eigentlichen Daten sowie wichtige Informationen zur Datenbankstruktur.

## .NDF (Secondary Data File // alt: Next Data File)
→ Zusätzliche Datendatei einer SQL-Server-Datenbank. Wird genutzt, um Daten auf mehrere Dateien oder Datenträger zu verteilen.

## .LDF (Log Data File)
→ Transaktionsprotokolldatei. Speichert alle Änderungen an der Datenbank und ermöglicht Wiederherstellung sowie Fehlerkorrekturen.

## Nenne 3 Gründe für das Nutzen für verschiedene Datenträger bei SQL

## Trennung von Daten- und Log-Dateien
→ Transaktionsprotokolle (LDF) werden auf separaten Datenträgern gespeichert, um die Wiederherstellung zu verbessern und Schreibkonflikte zu vermeiden.

## Bessere Performance
→ Wenn Daten (MDF/NDF) und Log-Dateien auf unterschiedlichen Festplatten liegen, können Lese- und Schreiboperationen parallel schneller ausgeführt werden.

## Höhere Ausfallsicherheit
Fällt ein Datenträger aus, sind nicht automatisch alle Daten betroffen (z. B. Log-Datei getrennt von Datenbankdateien).Was ist eine File-Group

Eine physische Trennung von Tabellen. Damit können nicht nur die Organisation der Tabellen vorgenommen werden. Sondern auch Teile der Datenbanken, die oft gebraucht werden, physikalisch getrennt werden.

(Abfragen sind durch parallele laufende Speichermedien schneller)

## Was ist ein Transaktionsprotokoll ?

Protokolliert die Zeit der Änderungen an der Datenbank. Mithilfe kann die Datenbank Mithilfe

Was ist der Unterschied zwischen Bulk- und Full-Backup?

Bulk-Backup speichert nur einen zusammengefassten Timestamp.

Full-Backup speichern die  einzelnen Timestamps, so ist eine Recovery-Zeit möglich.

## Was ist das Right-Ahead Protokoll?

Das Protokoll für die Änderungen werden erst geschrieben, dann erst wird die Manipulation durchgeführt. Falls Systemfehler bei der Manipulation den Vorgang unterbricht, wird dadurch klar was und ob etwas verändert wurde.

## Was ist eine Partition in SQL?

Eine Partition ist die Aufteilung einer großen Tabelle oder eines Index in kleinere, logisch und physikalisch getrennte Teile.
→ Ziel: bessere Performance, einfachere Verwaltung und schnellere Abfragen.
→ Beispiel: Daten werden nach Datum oder Region aufgeteilt.

## Was ist ein Snapshot?

Ist eine Momentaufnahme. Speichert die originalen Daten, sobald diese Verändert werden. Kein Insert erlaubt - Weil es die Datenhistorie verändert.

## Was ist ein Partitionsschema?

Welche Partition wird in welche Dateigruppe eingebettet.

## Wie legt ein Schema die Partitionsgrenzen fest?

→ Die **Partitionsgrenzen werden durch eine Partitionsfunktion (Partition Function)** definiert.
→ Sie legt fest, **nach welchen Werten (z. B. Datum, ID, Bereich)** eine Tabelle in mehrere Partitionen aufgeteilt wird.

## Was legt bei Partitionsfunktion Left or Right fest?

Es bestimmt, **wie Grenzwerte (Boundary Values)** in Partitionen eingeordnet werden.

## LEFT**: Der Grenzwert gehört zur **linken (kleineren) Partition

## RIGHT**: Der Grenzwert gehört zur **rechten (größeren) Partition

## Welche 3 Vorgänge für partitionierte Daten gibt es?

SWITCH:     Austausch einer gefüllten Tabelle/Partition mit einer leeren

MERGE:      Zusammenfassen zweier benachbarter Partitionen.

SPLIT:         Neue Grenze zum Aufteilen einer Partition.

Powershell in SQL aktivieren.

```sql
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;
```
Neuen Ordner in SQL für Windows erstellen.

```sql
EXEC xp_cmdshell 'mkdir <Festplatte>:\<< Verzeichnisweg>>\<Zielordner>
C:\SQL_Test\Festplatte_e\MovieDB\Movie_Main';
```
## Wie kann man die Auslastung der Log-Datei in SQL einsehen?

```sql
DBCC SQLPERF(LOGSPACE)
```
## Wie kann man Infos über die Log-Datei in SQL einsehen?

```sql
DBCC LOGINFO
```
## Wie SINGLE- und MULTI-User einstellen?

**Einzelner Benutzer:**

```sql
ALTER DATABASE [Datenbank]
SET SINGLE_USER (falls blockiert, WITH ROLLBACK IMMEDIATE);
```
## Für Multi-User

```sql
ALTER DATABASE [Datenbank]
SET Multi_USER (falls blockiert, WITH ROLLBACK IMMEDIATE)
```
## Häufige OBJECT_ID-Typen

|Code|Bedeutung|
|---|---|
|#### 'U'|#### User Table|
|#### 'V'|#### View|
|#### 'P'|#### Stored Procedure|
|#### 'IF'|#### Inline Table-Valued Function|
|#### 'TF'|#### Table-Valued Function|
|#### 'FN'|#### Scalar Function|

Objekthierachie-SQL

**3 Ebenen:**

Serverebene

Datenbankebene

Schemaebene

## Arten von Prinzipalen

Prinzipale werden meist in zwei Hauptebenen unterteilt:

Serverebene**:**

- **Anmeldenamen (Logins):** Konten, mit denen sich Benutzer am gesamten Datenbankserver anmelden (z. B. Windows-Konto oder ein systeminternes SQL-Konto wie sa).
- **Serverrollen:** Vordefinierte Gruppen (wie sysadmin), die Berechtigungen für den gesamten Server bündeln.

## Datenbankebene:

- **Datenbankbenutzer:** Logins, die Zugriff auf eine spezifische Datenbank erhalten haben.
- **Datenbankrollen:** Zusammenfassungen von Benutzern, um Berechtigungen zentral zu verwalten (z. B. die Rolle db_datareader).
- **Anwendungsrollen (Application Roles):** Prinzipale, die ausschließlich für den Zugriff durch eine bestimmte Anwendung genutzt werden. Prinzipale können auch Dienstprinzipale (Service Principals) umfassen, die es externen Anwendungen oder Cloud-Diensten (wie Microsoft Entra ID) ermöglichen, sich automatisiert in der Datenbank zu authentifizieren.

## Was ist der Unterschied zwischen Datenbank- und Serverrollen?

Datenbank gilt nur innerhalb von Datenbanken.

Bei Serverrollen gilt dies innerhalb des Servers.

## Wie findet man die physischen Dateien der Datenbank

```sql
SELECT
```
    DB_NAME(database_id) AS DatabaseName,
    name AS LogicalFileName,
    physical_name AS PhysicalFilePath
FROM sys.master_files
WHERE DB_NAME(database_id) = 'EmployeeDB';

## Was sind Partitionsfunktionen?

Partitionsfunktionen definieren Partitionsgrenzen

Begrenzungswerte können LEFT oder RIGHT zugewiesen werden

```sql
CREATE PARTITION FUNCTION pf_<Partitionsname> (DATEIFORMAT)
AS RANGE RIGHT
FOR VALUES (‚range1‘,  ‚range2‘ , …)
```
## Was ist der Hauptzweck einer Rolle

Einfache Verwaltung von Benutzerrechten.

## Was ist ein Datenbank-Objekt?

Ein **Datenbank-Objekt** ist jede strukturierte Einheit innerhalb einer Datenbank, z. B.:

- **Tabellen (Tables)** – speichern Daten

- **Views** – virtuelle Tabellen basierend auf Abfragen

- **Schemas** – organisatorische Container für Objekte

- **Prozeduren / Stored Procedures**

- **Funktionen**

- **Indizes**

- **Trigger**

## Was ist der Unterschied zwischen einem Login und User

## Login (Server-Ebene)
→ Wird auf dem **SQL-Server** erstellt
→ Ermöglicht den Zugriff auf den Server selbst
→ Beispiel: CREATE LOGIN

## User (Datenbank-Ebene)
→ Existiert **innerhalb einer bestimmten Datenbank**
→ Wird einem Login zugeordnet
→ Bestimmt Rechte in dieser Datenbank

## Welche Rechte kann man mit GRANT übergeben?

```sql
- CRUD - Rechte
- EXECUTE (für Prozeduren)
- ALTER
- CONTROL
- REFERENCES
```
## Welche Datenbankrolle wird vom System bereits vorgegeben?

- db_owner

- db_Admin

usw.

## Was passiert, wenn man Rechte mit WITH GRANT vergibt?

## SYNTAX

```sql
GRANT <Recht> ON [Tabelle] TO <USER>  WITH GRANT OPTION;
Was macht bcp? Boy Copy Programm
```
## Welche bcp - Modi gibt es ?

bcp führt Massen-Insert/Export-Operationen durch (Bulk Operations), nicht einzelne INSERTs wie im SQL-Query-Modus.

## IN

## bcp [Datenbank.dbo.Tabelle] IN „Speicherort\Datei.csv“-c -t  -S [Servername] -T
→ Daten **in die Datenbank importieren**

## OUT
→ Daten **aus der Datenbank exportieren**

## QUERYOUT
→ Export basierend auf einer **SQL-Abfrage**

## Was ist der Unterschied zwischen Bulk und bcp IN?

bcp ist ein Werkzeug, welches außerhalb und Bulk  eine Anweisung, die innerhalb des Servers durchgeführt wird.
