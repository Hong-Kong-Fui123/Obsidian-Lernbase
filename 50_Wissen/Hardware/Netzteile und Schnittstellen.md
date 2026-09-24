---
typ: wissen
thema: Hardware
tags: [hardware, netzteil, usb]
quelle: Word-Notizen
status: importiert
---
# Netzteile und Schnittstellen (USB, FireWire)

Thema: [[Hardware]]

## Netzteile (Power Supply Unit)

Stromversorgung des Computers bzw. der Einzelkomponenten.

Aufbau

-       Aktiver Lüfter

-       Externe Stromzufuhr

-       Mainboard-Stromanschluss

-       Prozessor-Stromanschluss

-       PCIe- Stromanschluss

-       SATA- Stromanschluss

-       4-Pin-Molex Stromversorgung Peripherie

Nennleistung: garantierte, maximale Stromabgabe des Netzteils

PFC: (Power Filter Correction) Leistungsfaktorkorrekturfilter (ab einer Nennleistung von 75 Watt). Sorgt für Phasengleichheit.

Wirkungsgrad: Quotient/Verhältnis zwischen abgegebener und zugeführter Leistung

Stecksystem: bei einigen Netzteilen können nicht benötigte Kabelstränge abgenommen werden.

Aktiv/passiv: ein Netzteil mit Lüfter ist aktiv, ohne Lüfter ist es passiv

Redundanz: doppelt vorhandenes Netzteil (eher im Serverbereich anzutreffen/Ausfallschutz)

## Computer-Netzstecker

Kaltgerätestecker oder Stecker nach IE10 (international)

## USV (Unterbrechungsfrei Stromversorgung = uninterruptible power supply)****

## VFD (Voltage and Frequency Dependent)

-       Offline-USV

-       Günstigste USV mit der längsten Umschaltzeit (10 ms)

Sichert nur Stromversorgung, kein zusätzlicher Schutz.

Sobald Strom weg ist, legt sich der Schaltschütz um und bezieht den Strom aus der Batterie.

## VI (Voltage Independent)

-       Netz-Interaktiv-USV

-       Eingangspannung ist synchron zur Ausgangsspannung (kann Spannung regulieren)

-       Schützt zusätzlich vor Unter- und Überspannung.

Kontrolliert durchgehend den Eingang der Spannung. Eine Umschaltzeit wie beim VFD gibt es nicht.

Bei Schwankung wird aus der Batterie Spannung hinzugefügt. Bei komplettem Ausfall schließt der Eingang, um das Entladen der Batterie ins Netz zu verhindern.

## VFI (Voltage and Frequency Independent)

-       Online-USV

-       am teuersten, mit den höchsten Anforderungen.

-       Schützt zusätzlich vor Über-/Unterspannung, Frequenzschwankungen und Oberschwingungen.

Besitzt einen Bypass. Wenn Batterie kaputt, kann der Strom direkt aus dem Eingang gezogen werden, solange die Batterie gewechselt wird.

---

## USB (Universal Serial Bus -  universales Verbindungskabel)

-          Serielles Bus-System zum verbinden von Computer mit externen Geräten

-          Hot-Plug Einbinden im laufenden Betrieb

-          Plug-n-Play automatische Erkennung der Geräte und Installation der Treiber

-          Host-Controller erforderlich (Standard auf jedem Mainboard)

-          Seriell werden immer nacheinander versendet

-          USB besteht aus der einem Sendungsleiter, einem Empfängerleiter und einem Masseleiter (Erdungsleiter)

-          Der Host Controller vergibt bis zu 127 Endgeräte (7 Bits // 126 + 0)

-          An einem Port ein Gerät gleichzeitig.

## USB – Übertragunsmodi

Endpunkt – Transfer            Jedes Gerät hat einen Endpunkt. Wichtig, wenn z.B. Webcams – Ton und Bild wird synchronisiert.

Isochroner – Transfer          Der isochrone Transfer garantiert eine Datenrate als konstanten Datenstrom.

                                               z.B. USB-Soundkarten, damit Lied gleichmäßig wiedergegeben werden kann.

Interrupt-Transfer                 Übertragung von kleineren Datenmengen, deren genauer                                        Zeitpunkt nicht genau festgelegt   usw.

## HID ( Human Interface Device)Maus, Touchpad.****

OTG – Transfer                    USB-„On-The-Go“ übertragt Daten zwischen zwei Endgeräten direkt. Dafür wird z.B. ein Endgerät als Host-Computer eingeschätzt. Z.B. USB Stick in ein Autoradio, das Radio wird „Host-Computer“

## USB-Stecker

USB Typ A                            Standard USB-Anschluss

USB Typ B                            „Andere Seite“ eines normalen USB-Kabels (Drucker usw.)

Mini-USB                              Mini-Ausgabe mit Daten und Stromleitung. (Wie beim Music-Pod)

Micro-USB                            Miniatur-Ausgabe mit Daten- und Stromleitung.

                                               (Samsung USB)

USB 3.0                                 Ähnlich aussehend wie USB Typ A, aber neu verschaltet.

                                               USB-B-Variante wesentlich anders ausgebaut, unterstützt „SuperSpeed-Übertragung“.

USB C                                   Einbau in flache USB-Geräte geeignet. Beidseitig einsteckbar. Unterstütz alle bissherigen Möglichkeiten der Datenübertragung, inklusive USB 3.1 (Gen 2)

                                               Doppelt so schnell durch zweites paralleles Adernpaar.

## IEE1394 (FireWire)

-          von Apple Entwickelt, serielles Bus-System, ähnlich USB 2.0.

-          Sony hat es unter dem Namen „i.Link“ lizensiert.

-          Maximal sind 63 Geräte pro FireWire-Bus möglich.

-          Allerdings können

## Generationen Firewire

|   |   |   |
|---|---|---|
|Generation|Marketingname|Datenrate|
|IEEE 1394a|FireWire 400|400 Mbit/s (- 50 MB/s)|
|IEEE 1394b|FireWire 800|800 Mbit/s (- 100 MB/s)|
|IEEE 1394-2008|FireWire S3200|3200 Mbit/s (- 400 MB/s)|

---
