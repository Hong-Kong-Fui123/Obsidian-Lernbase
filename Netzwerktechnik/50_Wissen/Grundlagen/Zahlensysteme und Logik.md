---
typ: wissen
thema: Hardware
tags: [zahlensysteme, binär, hexadezimal, logik]
quelle: Word-Notizen
status: importiert
---
# Zahlensysteme und Logik

Thema: [[Hardware]] · [[Netzwerk]]

## Zahlensysteme

Beispiele:

Dezimalsystem -> 10

Dualsystem -> 2

Hexadezimalsystems -> 16

Oktalsystem -> 8

## Methoden umwandeln von Dezimalzahlen in Binärzahlen

A)   Tabellenvergleich der Zahlen.

B)   Teilen der Zahl durch 2 mit Restberechnung, wie beim Hexadezimal-Umwandlung.

Beispiel:

Dezimalzahl 2056                                        Dezimalzahl 455

2056   :           2 = 1028        Rest    0          455     :           2 = 227          Rest    1

1028   :           2 =   514        Rest    0          227     :           2 = 113          Rest    1

514     :           2 =   257        Rest    0          113     :           2 =   56          Rest    1

257     :           2 =   128        Rest    1          56       :           2 =   28          Rest    0

128     :           2 =      64       Rest    0          28       :           2 =   14          Rest    0

64       :           2 =     32        Rest    0          14       :           2 =     7          Rest   0

32       :           2 =     16        Rest    0          7          :           2 =     3          Rest    1

16       :           2 =     8          Rest    0          3          :           2 =     1          Rest    1

8          :           2 =     4          Rest    0

4          :           2 =     2          Rest    0

2          :           2 =     1          Rest    0

## Methode umwandeln von Hexadezimalzahlen in Binärzahlen

Beispiel:

Hexadezimal                 F16             =          1510                      =          1111

Hexadezimal               B3E16             = 1110.310.1410              =              1011.0011.1110

Hexadezimal                 25              =         2510                      =              11001

## Methode umwandeln von Binärzahlen in Hexadezimalzahlen

Binär  1001 1101                             =          9, 13              =          9D

Binär  1101 0111                             =          13,  7              =          D7

## Logische Verknüpfungen

|   |   |   |
|---|---|---|
|**Und(And)**|**W**|**F**|
|**W**|**W**|**F**|
|**F**|**F**|**F**|

|   |   |   |
|---|---|---|
|**Or**|**W**|**F**|
|**W**|**W**|**W**|
|**F**|**W**|**F**|

|   |   |   |
|---|---|---|
|**XOR**|**W**|**F**|
|**W**|**F**|**W**|
|**F**|**W**|**F**|

****

## Einer- und Zweier-Komplementierung

57 – 33 = 24

57 binär = 0011.1001

33 binär = 0010.0001 -> 1101.1110 (als Minus)  + 1 = 1101.1111

   1101.1111

+ 0011.1001

= 0001.1000

---

## Dualzahlen

Sind Binärzahlen, nur ein anderer Begriff.
