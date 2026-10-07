---
tags: [sql, datenbank, mssql, windows-server, fisi]
aliases: [SQL Log Speicherung, MDF LDF, Transaktionsprotokoll]
---

# SQL Server – Datei- und Log-Speicherung

## Kurzinfo
- Jede Datenbank besteht aus **mind. 2 Dateien**: Datendatei (`.mdf`) + Transaktionsprotokoll (`.ldf`).
- Jede Änderung wird **zuerst ins Log** geschrieben, dann in die Datendatei (Write-Ahead Logging).
- Das Log ermöglicht **Rollback**, **Wiederherstellung nach Absturz** und **Point-in-Time-Restore**.

## Dateitypen

| Datei | Endung | Inhalt | Pflicht |
|---|---|---|---|
| Primäre Datendatei | `.mdf` | Tabellen, Indizes, Systeminfos, Verweise auf weitere Dateien | ja, genau 1 |
| Sekundäre Datendatei | `.ndf` | zusätzliche Daten (Verteilung auf weitere Laufwerke) | nein, 0–n |
| Transaktionsprotokoll | `.ldf` | alle Transaktionen/Änderungen in Reihenfolge | ja, mind. 1 |
| Fehlerprotokoll | `ERRORLOG` | Start/Stopp, Fehler, Anmeldefehler des SQL-Dienstes | automatisch |

## Standardpfade (SQL Server 2022 = MSSQL16)

| Was | Pfad |
|---|---|
| Daten + Transaktionslog | `C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\` |
| ERRORLOG | `C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Log\` |
| Backups | `C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\` |

> Versionen: 2016 = MSSQL13, 2017 = MSSQL14, 2019 = MSSQL15, 2022 = MSSQL16

## Wiederherstellungsmodelle

| Modell | Log-Verhalten | Point-in-Time | Einsatz |
|---|---|---|---|
| Einfach (SIMPLE) | Log wird beim Checkpoint automatisch geleert | nein | Test, Entwicklung |
| Vollständig (FULL) | Log bleibt bis zum Log-Backup erhalten | ja | Produktion |
| Massenprotokolliert (BULK_LOGGED) | wie FULL, Massenimporte minimal protokolliert | eingeschränkt | große Importe |

## Sicherungsarten

| Art | Sichert | Hinweis |
|---|---|---|
| Vollsicherung | gesamte DB | Basis für alle anderen |
| Differenzielle Sicherung | Änderungen seit letzter Vollsicherung | wird mit der Zeit größer |
| Protokollsicherung | Transaktionslog seit letzter Log-Sicherung | nur bei FULL/BULK_LOGGED, leert das Log |

## Best Practice
- `.mdf` und `.ldf` auf **getrennte Laufwerke** legen (Leistung + Ausfallsicherheit).
- Backups auf **anderes Laufwerk/anderen Server** als die DB.
- Bei FULL **regelmäßig Log-Sicherungen**, sonst wächst `.ldf` unbegrenzt → Platte voll.
- Autogrowth in festen MB-Schritten statt Prozent.

## Befehle (auf dem SQL-Server, in SSMS oder `sqlcmd`)

```sql
-- Speicherort aller DB-Dateien anzeigen
SELECT DB_NAME(database_id) AS DB, name, type_desc, physical_name
FROM sys.master_files;

-- Wiederherstellungsmodell anzeigen
SELECT name, recovery_model_desc FROM sys.databases;

-- Wiederherstellungsmodell ändern
ALTER DATABASE Testdb SET RECOVERY FULL;

-- Log-Auslastung anzeigen
DBCC SQLPERF(LOGSPACE);

-- Vollsicherung
BACKUP DATABASE Testdb TO DISK = 'D:\Backup\Testdb_full.bak';

-- Protokollsicherung
BACKUP LOG Testdb TO DISK = 'D:\Backup\Testdb_log.trn';

-- DB mit eigenen Dateipfaden anlegen
CREATE DATABASE Testdb
ON PRIMARY (NAME = Testdb_data, FILENAME = 'D:\SQLData\Testdb.mdf')
LOG ON     (NAME = Testdb_log,  FILENAME = 'E:\SQLLog\Testdb_log.ldf');
```

## Glossar

| Begriff | Erklärung |
|---|---|
| **MDF** | Master/Primary Data File – Hauptdatendatei der Datenbank |
| **NDF** | Secondary Data File – optionale weitere Datendatei |
| **LDF** | Log Data File – Transaktionsprotokoll |
| **Transaktion** | Zusammengehörige Änderungen, die ganz oder gar nicht ausgeführt werden |
| **ACID** | Atomarität, Konsistenz, Isolation, Dauerhaftigkeit – Grundregeln für Transaktionen |
| **Commit** | Transaktion wird endgültig bestätigt |
| **Rollback** | Transaktion wird rückgängig gemacht (mithilfe des Logs) |
| **Write-Ahead Logging (WAL)** | Änderung wird zuerst ins Log, dann in die Datendatei geschrieben |
| **Checkpoint** | Schreibt geänderte Seiten aus dem RAM in die Datendatei |
| **VLF** | Virtual Log File – interne Abschnitte der `.ldf` |
| **Log Truncation** | Freigeben von Log-Platz (nach Log-Backup bzw. Checkpoint bei SIMPLE) – Datei wird dadurch nicht kleiner |
| **Shrink** | Physisches Verkleinern einer Datei (`DBCC SHRINKFILE`) – nur im Ausnahmefall |
| **Autogrowth** | Automatisches Vergrößern einer Datei, wenn sie voll ist |
| **Dateigruppe (Filegroup)** | Logische Gruppierung von Datendateien (PRIMARY + eigene) |
| **Recovery Model** | Wiederherstellungsmodell: SIMPLE, FULL, BULK_LOGGED |
| **Point-in-Time-Restore** | Wiederherstellung auf einen exakten Zeitpunkt (nur mit Log-Backups) |
| **Tail-Log-Backup** | Letzte Log-Sicherung vor einer Wiederherstellung, damit nichts verloren geht |
| **ERRORLOG** | Textprotokoll des SQL-Server-Dienstes für Fehler und Ereignisse |
| **SSMS** | SQL Server Management Studio – grafisches Verwaltungstool |
| **sqlcmd** | Kommandozeilentool für SQL Server |

## Verknüpfungen
- [[Datensicherung]]
- [[Windows Server]]
- [[RAID]]
