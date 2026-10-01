---
typ: wissen
thema: Hardware
tags: [hardware, cpu, mainboard, bios]
quelle: Word-Notizen
status: importiert
---
# Mainboard und Prozessor

Thema: [[Hardware]]

> [!warning] Korrekturen
> - [[TPM]] = **Trusted** Platform Module
> - 01.01.1970 = Unix-Zeit (Betriebssystem), nicht [[BIOS]]
> - Pin-Anzahl steht im Sockelnamen (z. B. LGA 1700), nicht in der [[CPU]]-Nummer
> - CPUs drosseln bei ca. 100 °C (Tjmax), sie „verlieren“ nicht ihre Wirkung

## Unix Startzeit bei BIOS

01.01.1970 – der Startpunkt der BIOS-Zeitrechnung. Von dort werden die Sekunden gerechnet und danach geteilt. So entstehen Datum und die Uhrzeit.

## Prozessor-Sockel

Die Zahlen bei den Bezeichnungen bei Intel, z.B. Intel 4710, gibt die Anzahl die der Pinne wieder.

## TPM (Tasted Plattform Modul)

Verschlüsselungsmodul

## AAFP (AnalogAudioFrontalPanel)

Mikro- und Kopfhörerbuchse.

## Clear-CMOS-Jumper

Setzt Bios-Einstellungen auf Werkseinstellungen zurück.

Prozessoren (Silizium) verlieren ab 120 Grad ihre Wirkung.

## Aufbau eines Prozessors

## Prozessoren

## „Register“

-       Speicherbereiche, die direkt mit der eigentlichen Recheneinheit verbunden sind.

-       Nehmen Ergebnisse aller Berechnungen auf (als „Zwischenspeicher“).

-       Register sind so groß wie die „Wortgröße“ des Prozessors (also meist 64 Bit)

-       Mehrere Register bilden einen „Registersatz“.

-       Die meisten Register speichern Befehle, Speicheradressen und Operanden.

-       Eigenschafen und Funktionen der Register unterscheiden sich herstellerspezifisch.

-       Register bestimmen durch ihre Kern-Nähe maßgeblich die Leistung.

-       Datenregister, Adressregister, free-to-use-Register, Spezialregister und Stapelregister.

## „Rechenwerk“ (ALU) Operationen (Arithmetic Logic Unit)

-       Führt die „Elementar-Operationen“ eines Rechners durch.

-       Durchführung von arithmetisch und logischen Operationen (Arithmetic Logic Unit).

Bsp.: Arithmetik: Addition zweier Zahlen.

Bsp.: Logik: AND-/OR-Verknüpfung.

-       Jeder Prozessor hat mehrere, von einander unabhängige Rechenwerke.

-       Je mehr spezialisierte Rechenwerke (Bspw. Gleitkomma), desto schneller der Prozessor.

## „Befehlsdecoder“

-       „Instruction Fetch Unit“ (IFU) holt Befehle aus dem [[RAM]]-Speicher und leitet sie weiter an Decoder, in den RAM kommen die Befehle aus dem Betriebssystem.

-       Übersetzt binäre Maschinenbefehle in Anweisungen.

-       Befehlstabelle (Instruction Table) wird als Hilfe verwendet.

-       Zerlegt Instruktionen in Arbeitsschritte und leitet diese an die CPU-Einheiten weiter.

-       Je nach Prozessorarchitektur ist Decodierung einfach oder komplex.

-       Arbeitsschritte des Decoders aufbauend (Lösung B möglich durch vorherige Lösung A).

## „Steuerwerk“

-       Kontrolliert die Ausführung der Anweisung.

-       Sorgt dafür, dass der Befehl im Befehlsregister vom Decoder dekodiert wird.

-       Sorgt ebenfalls für die anschließende Ausführung im Rechenwerk (ALU).

-       Sorgt für reibungslose Kommunikation von Befehls- und Befehlszählerregister.

-       Trägt Verantwortung für die Abarbeitung eines Programms.

-       Klassischer Ablauf:

FETCH, Aus dem RAM aus dem Befehlszählregister wird nächster Befehl ins Befehlsregister geladen

 -> DECODE (Umrechnen), Befehlsdecoder dekodiert den Befehl und aktiviert entsprechende Schaltungen

-> FETCH OPERANDS, Aus einem Speicher werden Daten ins Arbeitsregister geladen.

-> EXECUTE -> Befehl wird ausgeführt.

UPDATE INSTRUCTION POINTER (nächste Programmzeile).

## „Hyper-Threading“

-       Von INTEL entwickelte Version von „Multiprozess-Bearbeitung“ (bspw. 4 core/8 temporär)

-       Durch komplexes Rechen- und Steuerwerk wird physischer Kern simuliert (Sibling-Core)

-       Betriebssystem lagert Berechnungen in den virtuellen Kern aus.

-       Der Prozessor wird besser ausgelastet, weil er nicht auf eine Bearbeitung „warten“ muss (ST).

-       Software muss angepasst werden, um den virtuellen Kern anzusteuern.

-       Funktion auf INTEL-Prozessoren beschränkt, AMD nutzt aber „Flag“-Trick für eigene CPUs (z.B. Wartefunktion, da keine Rechnung gerade erforderlich)

-       Hauptfeature von SMT (Simultanes Multi-Theading).

**** **Datenleitungen (BUS-Anbindungen, 64-Bit)**

-       BUS= Gemeinsam genutzter Übertragungskanal (wenn zwei reden, schweigt der Rest).

-       „BUS“ kann frei mit „Signalleitung“ übersetzt werden.

-       Datenbus: Kommunikation mit dem Arbeitsspeicher. (64-Datenleitungen)

-       Adressbus: Adressierung der einzelnen Speicherzellen des Arbeitsspeichers (lesen + schreiben). (32-Datenleitungen)

-       Steuerbus: Steuerung von Peripherie-Anschlüssen wie PCI oder [[USB]].

-       Interner Bus: „lokaler Bus“ verbindet interne Geräte miteinander (Stichwort: Mainboard, z.B. Grafikkare oder andere verbaute Geräte)

-       Externer Bus: schließt externe Peripheriegeräte an die Hauptplatine an. (z.B. USB)

## Cache (Zwischenspeicher)

-       Zwischenspeicher für die zuletzt verwendeten Daten.

-       Bereits erledigte Aufgaben können schnell erneut geladen werden.

-       Prozesse haben meist 3 Caches (Level=L1, L2 und L3). Je niedriger die Zahl, desto schneller und „näher“ an der CPU

o   L1: direkt im Kern, sehr klein und optimiert CPU-Auslastung durch RAM-Auslagerungsvermeidung.

o   L2: direkt im Kern, größer als Level 1, tauscht Daten im RAM aus.

o   L3: Shared-Kohärenz-Cache, der die Kommunikation der Kerne untereinander optimiert. (Kohärenz = aufeinanderfolgend festgeschrieben)

-       Ist der Cache voll, wird der jeweils älteste Eintrag überschrieben (FIFO-Prinzip).

## TDP (Thermal Design Power) „Verlustleistung bei Prozessoren“

-       TDP gibt die maximale Verlustleistung (Wärmeabgabe) eines Prozessors in Watt an.

-       Wurde eingeführt, um die thermische Dimensionierung eines Systems planen zu können.

-       „Energie“, die als Verlust bei Höchstleistung an eine normaltemperierte Umgebung abgegeben wird.

-       Hochleistungsprozessoren haben logischerweise höhere TDP als Stromspar-CPUs (bspw. „Atom“)

## Der „DIE“ „Halbleiter-Chip ohne Gehäuse“

-       Auf dem DIE sind die einzelnen Kerne eines Prozessors untergebracht und herstellerspezifisch.

-       „DIE“ kommt von „Slice ´n Dice“ (Schneiden und würfeln) und bezieht sich auf den Silizium-Wafer (Herstellungsprozess).

-       Um die „DIE“ zu schützen (reagiert mit Luft), wird er von einem Heatspreader abgeschirmt (sonst „DIE-break)

-       GPU und Cache sind ebenfalls auf dem „DIE“

-

---

## Die „Northbridge“

-       Separater Chip, dicht an der CPU (kurze Wege = höhere Performanz)-

-       Wichtigster Chip auf dem Mainboard (oberste Hierarchie-Ebene)

-       Verbindet im Regelfall Prozessor mit Grafikkarte und Arbeitsspeicher.

-       Durch direkte Anbindung an Kernkomponenten ist der Chip „breitbandig“ ausgelegt.

-       Aufgrund der hohen Leistungserwartung ist mindestens eine passive Kühlung erforderlich.

-       Bei älteren Systemen: Verbindung zum Prozessor über „Front-Side-BUS“ (FSB).

## Die „Southbridge“

-       Seperater Chip, nahe an den PCI-Steckplätzen (kurze Wege, hohe Performanz)

-       Regelt den Datentransfer und die Datensteuerung zwischen den Geräten.

-       Angebunden sind bspw. PCI, PCI-X, SATA, Sound, USB, IEEE1394, [[LAN]], Controller, Energieverwaltung.

-       Langsamer getraktet und weniger hohe Ansprüche an die Hardware.

-       Kühlung im Regelfall nicht erforderlich.

-       Anbindung an die Northbride.
