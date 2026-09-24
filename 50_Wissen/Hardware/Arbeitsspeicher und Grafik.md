---
typ: wissen
thema: Hardware
tags: [hardware, ram, gpu]
quelle: Word-Notizen
status: importiert
---
# Arbeitsspeicher und Grafik

Thema: [[Hardware]]

## RAM

Dual-Channel-Mode

-       FSB hilft es nicht, da Bandbreite zu hoch

-       Farben sind egal, ins Handbuch gucken, welche Slots wirklich gepaart sind.

-

## ECC-RAM (Error-Correcting-Code)

Fehlerkorrektur für Arbeitsspeicher (Meist Server)

## PAE (Physical Address Extension)

Adresserweiterung bei Betriebssystemen zur RAM-Ausnutzung.

## Remapping

Im BIOS wird Verwaltungsspeicher (z.B. PCI) als RAM freigegeben.

## Shared Memory

Hardware reserviert Speicher vom RAM für sich selbst.

## Dedicated (im RAM)

Hardware (Grafikkarte) mit dediziertem (eigenem) Arbeitsspeicher.

## Swapping

Auslagern von Daten auf die Festplatte als virtuelles RAM-Laufwerk.

## SPD (Serial Presence Detect)

Verfahren zur Erkennung des Arbeitsspeichers.

## Spannung Arbeitsspeicher

Heute ca. 1,5 V.

## RAMDAC (Arbeitsspeicher-Digital-Analog-Converter)

Für Analogmonitoren - mit 256 Zustände anzeigen. VGA.

## Grafikkarte

- steuert die Bildschirmanzeige auf dem Computer.

- Prozessor verarbeitet die Daten und Grafikkarte bereitet sie zur Anzeige auf.

- entweder als Steckkarte (überwiegend PCI-E) oder onboard verfügbar.

- Wichtigste komponenten: GPU (GraphicProcessorUnit), RAM, RAMDAC  und Anschlüsse.

- die erste VGA-Karten Ende der 80er bestimmen noch heute den „Notfall-Modus“ (640x480).

- Anfangs war nur das Setzen einfacher Pixel möglich, später kam der „    Windows-Beschleuniger“.

- Immer mehr Funktionen wurden auf der Grafikkarte integriert. (Z.B. 3D- Funktionalität oder AI).

- mittlerweile sind Grafikkarten zu einer Art „zweiter Prozessor“ geworden.

- immer mehr Berechnungen (auch nicht-grafische) sollen auf die Grafikkarte ausgelagert werden.

## GPU (Graphics Processing Unit)

-       Begriff „GPU“ von Nvidia 1999 als marketingbegriff eingeführt (mit GeForce 256)

-       CPU ist auf sequenzielles „Abarbeiten“ optimiert, eine GPU auf Parallelisierung.

-       GPUs daher schon früher den CPUs überlegen.

-       GPU soll rechen-intensive 2D- und 3D-Aufgaben durchführen und die CPU entlasten.

-       Zugriff auf die GPU-Funktionen über Software-Bibliotheken wie DirectX oder OpenGL.

-       Standartfunktionen im Grafikbereich werden auf Hardware-Ebene realisiert (ähnlich MMX und SSE).

-       Heutzutage ist die GPU-Technik „offen“, das heißt nahezu frei programmierbar.

-       Ging es früher um reine Spiele-Leistung, ist die GPU-Ausrichtung heute viel flexibler geworden.

-       CPUs und GPUs sind heutzutage sehr ähnlich, auch was Aussehen und Aufbau betrifft.

-       Bei GPU meist ein Hauptkern und etliche Nebenkerne.
