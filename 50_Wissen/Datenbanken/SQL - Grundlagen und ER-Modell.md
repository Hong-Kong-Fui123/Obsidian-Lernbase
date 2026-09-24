---
typ: wissen
thema: Datenbanken SQL
tags: [sql, datenbank]
quelle: Word-Notizen
status: importiert
---
# SQL - Grundlagen und ER-Modell

Thema: [[Datenbanken SQL]]

## Was bedeute SQL?

Sequented Query Language.

## Was ist eine skalare Abfrage?

### Skalare Abfrage (z.B. SUM, AVG usw.

Eine skalare Unterabfrage liefert genau einen Wert zurück
(eine Zeile und eine Spalte).

- Unterabfrage mit **genau 1 Wert**
- Rückgabe: **1 Zeile + 1 Spalte**
- Oft bei WHERE, SELECT, HAVING

## Was ist eine korrelierte Abfrage?

### Korrelierte Abfrage

a)Unterabfrage greift auf äußere Abfrage zu

b)Wird **für jede Zeile neu ausgeführt**

Beispiel:

```sql
SELECT * FROM [Tabelle] m1
```
WHERE gehalt > (
   SELECT AVG(m2.gehalt)
   FROM mitarbeiter m2
   WHERE m2.abteilung = m1.abteilung

# Was sind Metadaten?

(Beschreibende Daten die neben der Nutzung von „Medien“ anfällt.)

Sind beschreibende Daten über andere Daten und fallen unbeabsichtigt an.

# Nennen Sie drei Anwendungsbeispiele aus der Praxis von Datenbanken.

Z.B. Öffentliche Datenbanken (Behörden usw.), Versicherungsdatenbanken (Schäden usw.) Banken (Kundennummern, Kontostände usw.)

# Was sind die Aufgaben eines DBMS? (Datenbank-Management-Systems).

Mehrfachnutzerbetriebe - Sichergehen das die Daten konsistent sind.

Anomalien vermeiden (durch gleichzeitige Nutzung von Nutzern, nicht ausreichend normalisierte Datenbanken (Daten werden nicht korrekt gelöscht, eingetragen wie es vorgesehen wurde).

Verwaltung von Metadaten.

Zugriffskontrollen.

Verfügbarkeit und Skalierbarkeit.

## Was ist ein Rollback und Backup beim DBMS.

Backup ist bekannt.

Rollback ist das zurücksetzen von Datenbanken auf einem anderen Zeitpunkt.

(z.B. nach inkonsistenten(Fehlerhaften) einfügen von Daten).

## Was ist das ANSI (American National Standard Institute) 3-Schichten-Modell?

Vorteile des Systems: physische und logische Datenunabhängigkeit.

Externe Schicht:

z.B. Benutzer/Anwender. Stellt die Daten zur Nutzung des Systems zur Verfügung.

Datenmodell:

Welche Datenbank. Die Datenstruktur. Z.B. Tree. Sorgt für die möglichst redundanzfreie Darstellung aller zu speichernden Informationen!

Realisierung:

z.B. Festplatten, Server.

Was bedeuten die Begriffe Varianz und Standardabweichung?

Varianz gibt eine andere

## Was ist eine relationale Datenbank (Tabellendatenbank)? (nicht für Prüfung nötig)

Das relationale Model beschreibt, wie Daten gespeichert, abgefragt und manipuliert.

Tabellengeführte Datenbanken.

## Was ist Normalisierung bei Datenbanken?

Konzeptioneller Entwurf wird zum logischen Entwurf

## 1. Normalform

Atomare Zerlegung der Daten. Es ist normal das Redundanzen entstehen. Primärschlüssel festlegen.

## 2. Normalform

Nichtschlüssel-Attribute müssen von einem Primärschlüssel abhängig sein.

(Vollfunktional Abhängig - PK SchülerID, PK KursID - Zeit = Geben an, wie lange Schüler in welchem Kurs waren)

## 3. Normalform

Dürfen keine Abhängigkeiten zu einem  „Nicht-Schlüssel-Attribut“ bestehen.

## Aus welchen Teilen besteht offiziell SQL?

## 1) DDL (Data Definition Language)

Festlegen der Daten und Attribute

a) SELECT = Daten abfragen

b) INSERT = Daten einfügen

c) UPDATE = Daten ändern

d) DELETE = Daten löschen

## 2) DCL (Data Control Language)

Kontrolle und Rechte in SQL

a) GRANT = Rechte geben

b) REVOKE = Rechte wieder entziehen

c) DENY = Zugriff verweigern.

## 3) DML (Data Manipulation Language)

Aktualisieren, einpflegen und ändern von Daten

a) CREATE = Erstellen von Tabellen, Datenbanken und anderen Objekten

b) ALTER = Ändern der Struktur bestehender Objekte

c) DROP = Löschen von Objekten

## Die drei Schichten ANSI-Modell:

## 1. Externe Ebene (Benutzersicht)

Diese Ebene beschreibt, wie einzelne Benutzer oder Anwendungen die Daten sehen.

- Unterschiedliche Benutzer erhalten unterschiedliche Sichten auf die Datenbank.
- Nicht jeder Benutzer darf alle Daten sehen.
- Die Darstellung kann vereinfacht oder gefiltert sein.

**Beispiel:**

Ein Lehrer sieht Noten und Klassen,
die Verwaltung zusätzlich Adressen und Zahlungsdaten.

---

## 2. Konzeptionelle Ebene (logische Ebene)

Hier wird die gesamte Struktur der Datenbank beschrieben.

- Tabellen
- Beziehungen
- Attribute
- Datentypen
- Regeln und Constraints

Diese Ebene beschreibt also:

Wie die Daten logisch organisiert sind.

**Beispiel:**

Eine Tabelle Schüler besitzt:

- SchülerID
- Vorname
- Nachname
- Klasse

und steht in Beziehung zur Tabelle Kurse.

## 3. Interne Ebene (physische Ebene)

Diese Ebene beschreibt, wie die Daten tatsächlich gespeichert werden.

- Speicherorte
- Festplatten
- Indexe
- Server
- Zugriffsverfahren

Hier geht es um die technische Speicherung und Performance.

**Beispiel:**

Die Daten liegen auf SSD-Festplatten eines Datenbankservers.

## Was ist das ER-Modell/Modellierung?

Blaupause für das Erstellen der Datenbank.

## Was ist eine korrelierte Unterabfrage?

Eine logische Verbindung einer Abfrage mit der Unterabfrage.

Äußere und innere Abfrage hängen voneinander ab.

## Was ist Entity (Entitäten = Tupel) bei Datenbanken

Ein Objekt, das in der Realität existiert und in der Datenbank gespeichert werden soll.

Entitätstypen sind wie Klassen, Entitäten haben Attribute und Beziehungen.

## Wichtige DATENTYPEN/BEFEHLE SQL

- INT: Zahlen ca. 2 Milliarden (Führende Null ein Problem) (4 Byte)

- BIGINIT: „sehr große Zahlen“ => long (8 Byte)

- SMALLINT: Kleine Zahlen (-32768 bis 32768) => short  (2Byte)

- TINYINT: 0 bis 255 (ein Byte Groß) (1 BYTE)

- VARCHAR(50): Texte variable Länge

- CHAR(50): Fixe Länge von Texten (schneller Zugriff, weniger Verwaltung)

- NCHAR(5): Unicode (ASCII Sonderzeichen z.B. Segel usw.)

- NVARCHAR(5): Unicode variabler Länge (Unicodes sind länger)

- DECIMAL(10,2) => in diesem Beispiel Zehn Stellen vor und zwei nach dem Komma. Ein sehr genaue Zahlspeicherung.

- FLOAT und REAL => lange Zahl mit Komma - kurze Zahl mit Komma.

- BIT : 0 oder 1 darstellen, also Bool

- DATE: Datumswert (Muss mit Anführungszeichen geschrieben werden)

- TIME: Zeit (mit Sekunden)

- DATETIME: Tag und Zeit

- SMALLDATETIME:  Verkürztes Tag und Zeit.

- GETDATE() : Aktuelles Datum (auch Uhrzeit möglich) wird eingeführt.

- SYSDATETIME() : Aktuelle Uhrzeit und Datum, genauer

- GETUTCDATE(); Datum Coordinated Universal Time

Welcher Datentyp ist für Postleitzahlen sehr gut geeignet (und warum nicht INT)?

INT löscht die führenden Nullen, daher gibt dies bei einer PLZ von z.B. 0203 nur 203 zurück.

CHAR(5) am besten, da PLZ immer 5 sind und die Nullen bleiben.

## Nenne drei Beziehungen zu Entitäten (restliche Beispiele in der Folie)

1 zu 1

Eine Instanz einer Entität die zu einer Instanz einer Entität eine Beziehung hat.

Schüler - Schülerausweis

1 zu N

Eine Instanz einer Entität hat eine Beziehung zu einer oder vielen Entitäten.

Mutter - Kind(er)

N : M

Eine oder viele Instanzen einer Entität hat eine Beziehung einer oder viele Entitäten.

Der oder die Schauspieler / Filme(n)

Client  - Server
