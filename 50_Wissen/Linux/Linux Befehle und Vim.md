---
typ: wissen
thema: Linux
tags: [linux, vim, bash]
quelle: Word-Notizen
status: importiert
---
# Linux Befehle und Vim

Thema: [[Linux]]

|**Befehl**|**Beschreibung**|
|---|---|
|sudo|Befehle mit Rechten anderer Benutzerinnen bzw. Benutzer ausführen|
|ls|Verzeichnisinhalte auflisten|
|cd|Navigation im Verzeichnisbaum|
|touch|Neue Datei erstellen|
|mkdir|Neues Verzeichnis erstellen|
|rm|Datei entfernen|
|rmdir|Verzeichnis entfernen|
|mv|Datei oder Verzeichnis verschieben oder umbenennen|
|cp|Datei oder Verzeichnis kopieren|
|pwd|Aktuelle Position im Verzeichnisbaum ausgeben|
|zip|Dateien in Zip-Archiven schreiben|
|unzip|Dateien aus Zip-Archiven extrahieren|
|ln|Symbolische Verlinkung erstellen|
|cat|Datei-Inhalte zusammenführen|
|grep|Textdateien durchsuchen|
|diff|Unterschiede zwischen Text-Dateien finden|
|cmp|Unterschiede zwischen Dateien auf Byte-Ebene finden|
|tar|Dateien in Tar-Archive schreiben und extrahieren|
|echo|String auf der Standardangabe ausgeben|
|clear|Terminal leeren|
|ssh|Über eine _Secure Shell_ mit einem anderen Rechner verbinden|
|wget|Datei direkt aus dem Internet herunterladen|
|ping|Server anfragen und Latenz messen|
|ftp, sftp|Dateien via (S)[[FTP]] übertragen|
|ip|Netzwerkschnittstellen abfragen und konfigurieren|
|apt/pacman/yum|Software-Pakete herunterladen und verwalten|
|netstat|Status der Netzwerkschnittstelle ausgeben|
|traceroute|Datenpakete verfolgen|
|route|[[IP]]-Routing-Tabellen anzeigen und bearbeiten|
|dig|[[DNS]]-Informationen abfragen|
|mount/unmount|Dateisysteme einbinden (aufsetzen/einhängen/mounten)|
|dd|Bit-genaues Kopieren von Dateien, Partitionen oder Datenträgern|
|chmod|Zugriffsrechte verwalten|
|chown|Besitzrechte verwalten|
|adduser|Nutzerkonto hinzufügen/modifizieren|
|passwd|Passwörter für Nutzerkonten anlegen/bearbeiten|
|groupadd|Benutzergruppen anlegen|
|chattr|Datei-Attribute verwalten|
|lsattr|Datei-Attribute anzeigen|
|chgrp|Gruppenzugehörigkeit von Dateien und Verzeichnissen verwalten|
|man|Benutzerhandbuch aufrufen|
|shutdown, reboot|Das System herunterfahren/neu starten|
|top|Dynamische Prozessübersicht|
|lscpu|Prozessorinformationen ausgeben|
|lshw|Hardwareinformationen ausgeben|
|kill|Prozess via [[PID]] stoppen und beenden|
|killall|Prozesse via Namen stoppen und beenden|
|nice|Prozessprioritäten definieren|
|pgrep|PID via Suchbegriff ermitteln|
|ps|Liste aller laufenden Prozesse anzeigen|

Vim Modi

Navigation, Eingabe

MODI
i Insert-Modus (vor Cursor)
a Insert-Modus (nach Cursor)
o neue Zeile unten + Insert
O neue Zeile oben + Insert
Esc zurück in Normal-Modus
v Visual-Modus (Zeichen)
V Visual-Modus (Zeile)
Ctrl+v Visual Block
: Ex-/Command-Modus

NAVIGATION
h links
j runter
k hoch
l rechts
0 Zeilenanfang
$ Zeilenende
gg Anfang Datei
G Ende Datei
w nächstes Wort
b vorheriges Wort
e Wortende

EINGABE
i vor Cursor einfügen
a nach Cursor einfügen
o neue Zeile unten + Eingabe
O neue Zeile oben + Eingabe

Seite 2 – Commands, Bearbeitung, Copy, Search

COMMAND / EX-MODUS (:)
:w speichern
:q beenden
:wq speichern + beenden
:x speichern + beenden (nur wenn geändert)
:q! ohne speichern beenden
:w filename speichern unter neuem Namen
:w! erzwingen
:set number Zeilennummern anzeigen
:set paste Einfügen sauber
:noh Markierung entfernen
:%s/alt/neu/g ersetzen

BEARBEITUNG
x Zeichen löschen
dd Zeile löschen
dw Wort löschen
d$ bis Zeilenende löschen
u undo
Ctrl+r redo

KOPIEREN / EINFÜGEN
yy Zeile kopieren
yw Wort kopieren
p einfügen nach Cursor
P einfügen vor Cursor

ÄNDERN
ciw Wort ersetzen
diw Wort löschen
c$ bis Zeilenende ändern
d$ bis Zeilenende löschen

VISUAL MODE
v markieren Zeichen
V markieren Zeile
Ctrl+v Block markieren
danach: d löschen | y kopieren | > einrücken | < ausrücken

MERKSYSTEM
h j k l bewegen
d + Bewegung löschen
y + Bewegung kopieren
