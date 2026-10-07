---
typ: wissen
thema: Datenbanken SQL
tags: [sql, select, join]
quelle: Word-Notizen
status: importiert
---
# SQL - Befehle und Abfragen

Thema: [[Datenbanken SQL]]

> [!note] Korrigiert 07.10.2026
> `SEC()`/`MINUTE()` gibt es in T-SQL nicht → `DATEPART(...)`; Datums-SELECT berichtigt.

## ALTER TABLE Befehle

## Neue Spalte hinzufügen

```sql
ALTER TABLE [Tabelle]
ADD <Neue_Spalte> <Datentyp>;
```
## Spalte ändern

```sql
ALTER TABLE [Tabelle]
ALTER COLUMN <Spalte> <Neuer_Datentyp>;
```
## Spalte löschen

```sql
ALTER TABLE [Tabelle]
DROP COLUMN <Spalte>;
```
## Constraint hinzufügen

```sql
ALTER TABLE [Tabelle]
ADD CONSTRAINT <Constraintname>
<Constrainttyp> (<Spalte>);
```
## Was ist eine Entitätsinstanz

Kategorie einer Entität, z.B. Kunden = Name, Adresse usw. darunter sind die werden in der

## Nenne 3 bestimmende Objekte beim ER - Diagramm.

1. Entitäten.

2. Attribute.

3. Beziehungen.

## ER - Entitäten Relationship

Feststellen, welche Beziehungen die einzelnen Entitäten haben.

## Schlüsselattribut

Macht einen Datensatz über dieses Attribut einzigartig. Z.B. Konkrete Kundennummer usw.

## Beziehungen

Sollte sitzen.

## Was ist XML (Extensible Markup Language)

Eine [[XML]]-Datei ist eine Textdatei, die Daten in einer strukturierten, hierarchischen Form speichert. Austauschformat für das Web, ähnlich wie .json.

## Redundanz Beschreibung

Redundanz sind vorhandene Daten, bei deren Löschung kein Datenverlust entsteht, da diese beim speichern von relevanten Daten als Nebenprodukt entstehen.

(Z.B. Ort, Datum Personen der gespeicherten Daten)

## Was ist der Unterschied von Delete und Truncate

Truncate ist schneller, da nur bei Löschen kompletter Tabellen genutzt werden und setzt, im Gegensatz zu Delete, ggfs. auch Zählschlüssel (INDENTITY) zurück.

## Was sind Aggregate bei Daten?

Z.B. die Daten in bestimmte Informationen zusammenzufassen.

Z.B. (AVG)Durchschnittsgehalt, (GROUP BY)Durchschnittsgehalt der Abteilung xyz.

## Was sind Schreibzugriffe in SQL-Tabellen

```sql
INSERT, DELETE, UPDATE
```
## Was macht Constraint FOREIGN KEY?

Sorgt für referentielle Integrität, da bei Einträgen geprüft wird, ob diese Einträge auch in der Referenztabelle existieren.

### Syntax bei Tabellenerstellung:

```sql
FOREIGN KEY (<Spalte>)
REFERENCES <Tabelle>(<Spalte>)
```
## Wie lautet die Syntax am Ende der Tabelle für einen Multi PRIMARY KEY?

```sql
PRIMARY KEY (<PK1_Spalte>, <PK2_Spalte>)
```
## Was macht DISTINCT?

DISTINCT teilt die Abfrage in Realtion zu der gesamten Abfrage.
SELECT COUNT(*) FROM [Tabelle]

= Ausgabe der Anzahl der Einträge in der Tabelle

```sql
SELECT COUNT(DISTINCT <Spalte>) FROM [Tabelle];
```
= Ausgabe der Anzahl der Einträge, mit Gruppierung in der Tabelle

## Wie lautet die Tabellen INSERT INTO Syntax?

```sql
INSERT INTO [Tabelle] VALUES
(<SpaltenInhalt1>, <SpaltenInhalt2>,<SpaltenInhalt3>, usw.)
```
## SELECT BEFEHLSAUSWAHL

## Was sind die Aufgaben von SELECT .. INTO?

können Daten in eine neue Tabelle kopiert werden

› Struktur wird anhand der Datentypen ermittelt

› Es werden keine CONSTRAINTS verwendet

## Textausgabe per SELECT

```sql
SELECT Textausgabe
SELECT <Spalte> + ` Text  ` + <Spalte>
SELECT CONCAT(<Spalte>, ` Text `, <Spalte>) AS [Spaltenüberschrift]
FROM [Tabelle];
```
## Für einen anderen Datentyp

```sql
SELECT CONCAT(‚Eingabe Text `, <Spalte>) AS [Spaltenüberschrift] FROM [Tabelle];
```
## Abfragen mit SELECT

```sql
erste Range Version
SELECT <Spalten> FROM [Tabelle]
WHERE <Fragespalte> </>/= Bedingung OR/AND  </>/=;
```
## zweite Range Version

```sql
SELECT <Spalten> FROM [Tabelle]
WHERE <Fragespalte> BETWEEN [Bedingung] AND  [Bedingung];
```
## Ausgabeabfragen von ausgewählten Bedingungen

```sql
SELECT <Spalten> FROM [Tabelle]
WHERE <Spalten> IN ([Bedingung, Bedingung, Bedingung…]);
```
## LIKE-Abfragen

```sql
SELECT * FROM [Tabelle]
WHERE <Spalte> LIKE `[Suchbuchstaben]%`;
```
## DATUMSABFRAGEN

```sql
SELECT * FROM [Tabelle]
WHERE [YEAR, MONTH, DAY](<Datumsspalte>) </>/= [Bedingung];
```
## ORDER BY (DESC und ASC) Befehl

```sql
SELECT * FROM [Tabelle]
WHERE <Spalte> = [Bedingung]
ORDER BY <Spalte> DESC/ASC (mit , kann auch weitere Bedingungen hinzugefügt werden)
```
## Ausgabe nach Ranking

```sql
SELECT TOP ([ANZAHL]) WITH TIES (Wenn es Ausgaben mit gleichem Wert gibt)
Beispiele
- SELECT TOP (15) PERCENT WITH TIES FROM [Tabelle]
ORDER BY <Spalte> DESC/ASC;
```
## OFFSET FETCH

```sql
SELECT <Spalte> FROM [TABELLE]
ORDER BY <Spalte> DESC/ASC
OFFSET (Suchstart (z.B. 0)) ROWS FETCH NEXT (Suchende (z.B. 5)) ROWS ONLY;
```
## SELECT mit CAST

```sql
SELECT CAST(<Spalte> AS <Datentyp>) AS < Spaltenüberschrift >)
FROM [Tabelle];
```
## SELECT mit CONVERT

```sql
SELECT <Spalte/n> CONVERT(Wertetyp, <Welche Spalte>, FORMATCODE) AS (Spaltenüberschrift) FROM [Tabelle];
```
## SELECT mit TRY_CONVERT

```sql
SELECT <Spalte/n> FROM [Tabelle]
TRY_CONVERT(Wertetyp, <Spalte>) AS < Spaltenüberschrift > FROM [Tabelle];
```
# Textbasierte Funktionen

## SELECT mit Kleinbuchstaben

```sql
SELECT <Spalte>, LOWER(<Spalte>) AS <Spaltenüberschrift>  FROM [Tabelle];
```
## SELECT mit Inhaltsauswahl/-änderung

```sql
SELECT <Spalte>,
```
a) LEFT(<Spalte>, <Anzahl der Ausgabevariablen von links>) AS <Spaltenüberschrift>

b) RIGHT(<Spalte>, <Anzahl der Ausgabevariablen von rechts>)) AS <Spaltenüberschrift>

```sql
c) SUBSTRING(<Spalte>, Start Trennanzeige, Anzahl der angezeigten Buchstaben)
 FROM [Tabelle];
```

SELECT REPLACE

```sql
SELECT <Spalte>, REPLACE(<Spalte>, ,ZuÄndernderEintragVon‘‚ ZuÄnderndernIn‘) FROM [Tabelle]
WHERE <Spalte> =  <Bedingung>;
```
## Welche Datumsfunktionen sind wichtig?

(Nur wenn auch gespeichert / Time, Datetime oder Datetime2)

## Select Anzeigedatum/- zeit

```sql
SELECT <Datumsspalte>,
  YEAR(<Datumsspalte>)  AS Jahr,
  MONTH(<Datumsspalte>) AS Monat,
  DAY(<Datumsspalte>)   AS Tag,
  DATEPART(minute, <Datumsspalte>) AS Minute,
  DATEPART(second, <Datumsspalte>) AS Sekunde
FROM [Tabelle];
-- allgemein: DATEPART(<Teil>, <Datumsspalte>), Teil = year, month, day, hour, minute, second
```
## SELECT COUNT zum zählen der Reihen mit den Argumenten.

## (DISTINCT um die genauen Reihen zu unterteilen)

```sql
SELECT COUNT(<Spalte>) FROM [Tabelle];
SELECT COUNT(DISTINCT<Spalte>) FROM [Tabelle];
```
## Select Datum berechnen

```sql
SELECT < Spalte/n>
DATEADD(<ZuAddierendeArt> , <AddierteZeit>, <Datumsspalte oder z.B. GETDATE()) AS <ErgebnisAnzeige>;
FROM [Tabelle];
SELECT < Spalte/n>
DATEDIFF(<DATUMSFORMAT> , <AddierteZeit>, <Datumsspalte oder z.B. GETDATE()) AS <ErgebnisAnzeige>;
FROM [Tabelle];
```
>, >=, <= und < sind auch für Datumswerte definiert.

# JOIN - ABFRAGEN

## INNER JOIN

Der Fremdschlüssel wird ersetzt und es werden nur Daten ausgegeben, die mit dem Key übereinstimmen. Der Rest fällt weg.

RIGHT OUTER JOIN

Wie INNER JOIN, aber die Tabelle der zweiten(rechten) Vergleichstabelle wird mit zusammengesagt

## LEFT OUTER JOIN

Wie INNER JOIN, aber die Tabelle der ersten(links) Vergleichstabelle wird mit zusammengesagt

## FULL JOIN

Beide Tabellen werden ausgegeben und mit NULL aufgefüllt.

Die Felder müssen NULLABLE sein.

Die oberen vier JOIN-Typen liefern gleiche Ergebnisse zurück, wenn gefiltert wird oder alle Spalten ausgefüllt sind.

## CROSS JOIN (Kreuzprodukt)

Alles mit allem Verbunden.

SELF JOIN

Verweist eine Tabelle mit sich selbst.

## EQUI JOIN

Verknüpft zwei Tabellen über gleiche Werte in einer gemeinsamen Spalte. Wird meist mit Primär- und Fremdschlüsseln verwendet.

```sql
SELECT <Spalte/n>
FROM [Tabelle1]
INNER JOIN [Tabelle2]
ON [Tabelle1].[Spalte] = [Tabelle2].[Spalte];
```
## NON-EQUI JOIN

Verknüpft zwei Tabellen über ungleiche Werte oder Wertebereiche (z. B. <, >, BETWEEN). Wird häufig bei Preis- oder Gehaltsklassen genutzt.

```sql
SELECT <Spalte/n>
FROM [Tabelle1]
JOIN [Tabelle2]
ON [Tabelle1].[Spalte] </>/<=/>=/BETWEEN [Tabelle2].[Spalte];
```
## Variable mit DECLARE in Datenbanken nutzen

DECLARE <@declare.Name>  <Datentyp> <Operator> <Wert>

# CREATE VIEW … SELECT

## CREATE VIEW as [view_Tabelle] … SELECT <…. ABFRAGE…>

fügt die Abfrage als virtuelle Tabelle in den Speicher ein.

- ORDER BY kann nicht in diese Abfrage eingefügt werden

- WHERE mit CHECK geht

## CREATE VIEW as [view_Tabelle] WITH SCHEMABINDING
… SELECT <…. ABFRAGE…>

WITH SCHMEMABINDING - sorgt dafür das die Originialtabelle nicht dort gelöscht werden kann, wenn diese mit der [View-Tabelle] verbunden sind.

## Welche CREATE VIEW Einschränkungen gibt es?

```sql
- IDENTITY
- DEFAULT
- NULLABLE
```
## Was macht der Befehl SCHEMABINDING?

SCHEMABINDING ist ein CONSTRAINTED welches verhindert, dass die Quelltabelle an den verbundenen Spalten manipuliert wird.

## Was macht die CHECK Abfrage?

Die Filtert die Ergebnisse auf alles, was im WHERE steht.

## Wie rufe ich eine PROCEDURE auf?

EXEC  <procedure.name>;

EXECUTE <procedure.name>;

EXEC  <procedure.name> @<funktion> = <Wert>;

(z.B. Minsal @minsal = 2500;)

Was ist eine CTE (COMMON TABLE EXPRESSION)?
Eine CTE (Common Table Expression) ist eine temporäre Ergebnismenge, die innerhalb einer [[SQL]]-Abfrage definiert wird.

Sie dient dazu, komplexe Abfragen übersichtlicher und leichter lesbar zu machen.
Eine CTE wird mit WITH erstellt und kann, wie eine normale Tabelle verwendet werden.

```sql
WITH [CTE.NAME] AS (SELECT <Spalte/n>  FROM [Tabelle]
```
  WHERE <Bedingung>)

# Andere Anweisungen und Schleifen

## Wie wird DECLARE angewendet?

Mit @ wird DECLARE benannt.

DECLARE <@Declare.Name> <Dateityp>;

Wie läuft eine CASE-Schleife?

```sql
SELECT <Ausgabe.Spalte>,
<CASE>
WHEN <Bedingungen> <OPERATOR> <Vergleichsspalte> THEN <Ausgabe>
WHEN <Bedingungen> <OPERATOR> <Vergleichsspalte> THEN <Ausgabe>
ELSE <Ausgabe>
<END>
FROM [Tabelle];
```
## Wie geht die WHILE-Schleife?

Die While-Schleife kann gut für UPDATE genutzt werden.

```sql
DECLARE <@COUNTER.Siehe.Declare>
WHILE <Bedingung> <OPERATOR> <Zu_erfüllende_Bedingung>
BEGIN
            <<AKTION die pro Lauf erledigt wird>>
            SET <COUNTER>  = @@<COUNTER>COUNT;
            PRINT <Information für die Console>
END;
```
## Wie funktioniert die IF/ELSE Verzweigung?

IF/ELSE Prüft Bedingungen nacheinander und führt je nach Ergebnis unterschiedliche Anweisungen aus.

```sql
SELECT @<anzahl.Spalte> = COUNT(*)
FROM EMP
WHERE <Vergleichsspalte> = <@Vergleichsspalte>;
IF <@anzahl.Spalte> > 0
            PRINT << Ausgabe Fall 1 >>
ELSE
            PRINT << Ausgabe Fall 2 >>
```
# Was können Stored Procedures?

**Stored Procedures können u. a.:**

- Daten abfragen (SELECT)

- Daten verändern (INSERT, UPDATE, DELETE)

- Logik ausführen (Bedingungen, Schleifen, Variablen)

- Transaktionen steuern (COMMIT, ROLLBACK)

- Berechtigungen zentralisieren

- Parameter entgegennehmen und Ergebnisse zurückgeben

## Vorteile

- Wiederverwendung von Code
Einmal schreiben, beliebig oft aufrufen.

- Wartbarkeit
Änderungen müssen nur an einer Stelle erfolgen.

- Performance
Oft schneller, da sie direkt auf dem DB-Server ausgeführt und vorkompiliert sein können.

- Sicherheit
Zugriff auf Tabellen kann eingeschränkt werden, ohne direkten Tabellenzugriff zu geben.

- Reduzierter Netzwerkverkehr
Statt vieler SQL-Statements wird nur ein Prozeduraufruf gesendet.

## Anwendungsbereiche

Stored Procedures werden häufig verwendet für:

Geschäftslogik in der Datenbank
z. B.:

- Bestellprozess (Rechnung erstellen, Lagerbestand reduzieren)

- Kontobewegungen (Überweisung, Salden prüfen)

- Datenvalidierung

SYNTAX

```sql
CREATE PROCEDURE <sp_Name>
AS
BEGIN
                        SELECT <Spalte>, <Spalte>, ...
                        FROM [Tabelle];
END
```
wird mit EXEC <sp_Name>;

ausgeführt

## CREATE FUNKTION

Mit dieser Funktion kann ein Befehl erschaffen werden. Dieser Befehl ist für die jeweilige Datenbank gültig (nicht für das komplette SQL).

Beispiel Syntax:

```sql
CREATE FUNCTION <Funktionsname> (@<Variable> <Eingabedatentyp>)
RETURNS <Eingabedatentyp>
AS
BEGIN
            RETURN  <Funktionsaufgabe>;
END;
```
## INLINE Tabellen Syntax

```sql
CREATE FUNCTION <Funktionsname> (@<Variable> <Eingabedatentyp> )
RETURNS [TABLE]
AS
RETURN (SELECT <Spalte>,<Spalte>, usw. FROM [Tabelle]
WHERE <Bedingungsspalte> <Operator> <Bedingung>
);
```
## Wie funktioniert die TRIGGER Funktion?

Nur wenn die Auslösebedingung erfüllt wird, läuft diese Funktion automatisch im Hintergrund.

```sql
CREATE TRIGGER <name.trigger>
ON <überwachte.tabelle>
AFTER (DELETE/INSERT/UPDATE)
AS
```
BEGIN

```sql
            <Trigger logik>
```
            z.B.

```sql
            INSERT INTO <kopier.tabelle>
            SELECT <Spalte/n> (Welche den Trigger auslösen sollen z.B. empno, Mitarbeiter) FROM INSERTED;
```
END;

GO:

## UNION

Verbindet die Ergebnisse von zwei oder mehreren SELECT-Abfragen zu einer gemeinsamen Ergebnismenge.
Doppelte Datensätze werden automatisch entfernt.

Voraussetzungen:

- Gleiche Anzahl an Spalten
- Passende Datentypen
- Reihenfolge der Spalten muss übereinstimmen

## Welche Funktionen gibt es für SQL?

GETDATE(), COUNT(), CONVERT(), CAST(), ROUND(), LEN(), TRIM(), FLOOR und CEILING (FLOOR abrunden, CEILING aufrunden). DATEADD(), DATEDIFF(),

## Unterschied INLINE vs Mehrstatement-Funktion

|**INLINE Funktion**|**Mehrstatement-Funktion**|
|---|---|
|Nur 1 SELECT|Mehrere SQL-Anweisungen|
|Schneller|Langsamer|
|Kein BEGIN/END|BEGIN/END nötig|
|Einfach aufgebaut|Komplexere Logik möglich|
|Keine Zwischenschritte|Variablen und Schleifen möglich|
