---
typ: lab
thema: Windows Server
tags: [lab, active-directory, gpo]
quelle: Word-Notizen
status: importiert
---
# Lab AD-Grundlagen (Schule)

Thema: [[Windows Server]]

> [!warning] Korrekturen
> - IP-Adressen weichen von [[VM-Infrastruktur]] ab (z. B. .201 = EXA-SRV01 hier, EXA-DC02 dort) – eine Quelle festlegen
> - Defender-Abschaltung per Registry nur im Lab!

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f

Einstellungen Startimages

Grundeinstellung Firewall:

Datei- und Druckerfreigabe (Echoanforderung - ICMPv4 eingehend) aktiviert

Datei- und Druckerfreigabe (Echoanforderung - ICMPv6 eingehend) aktiviert

bei Windows 11 System

Überwachung für virtuelle Computer (Echoanforderung - ICMPv4 eingehend) aktiviert

Überwachung für virtuelle Computer (Echoanforderung - ICMPv4 eingehend) aktiviert

Maschine:                 EXA-CL01                Betriebssystem:       Windows 10/11

Kerne:                        2                                 Ram:                          4096

Festplattenplatten:   1                                 Speicher:                   50 GB

Netzwerk:                  privat1

IP:                               192.168.1.10/24

Maschine:                 EXA-SRV01             Betriebssystem:       Windows Server 2022

Kerne:                        2                                 Ram:                          2048

Festplattenplatten:   1                                 Speicher:                   50 GB

Netzwerk:                  privat1

IP:                               192.168.1.201/24

Maschine:                 EXA-SRV02             Betriebssystem:       Windows Server 2022

Kerne:                        2                                 Ram:                          2048

Festplattenplatten:   1                                 Speicher:                   50 GB

Netzwerk:                  privat1

IP:                               192.168.1.202/24

Maschine:                 EXA-DC01                Betriebssystem:       Windows Server 2022

Kerne:                        2                                 Ram:                          2048

Festplattenplatten:   1                                 Speicher:                   50 GB

Netzwerk:                  privat1

IP:                               192.168.1.200/24

## Prüfpunkt Example

Domäne                    example.com

## Auf DC-01

1.         Alternative Suffixe hinzufügen.

Test.de und Linux.org

2.        Schemas in MMC aktivieren

regsvr32 schmmgmt.dll ausführen (Win+r)

3.        OUs und User erstellen

(Main) OU

OU-Schulung erstellen

Sub-OUs                   Users                         Anmeldename

HR                              Thomas Klein           tklein

IT                                Paul Panzer              ppanzer

Management            Thorsten Gross        tgross

Sales                         Harald Schmidt        hschmidt

Password Pa$$w0rd und Kennwort läuft nie ab

IPCONFIG

4.        Netzwerk-Ordner Home

Auf SRV01

**Home** Ordner in C:\ erstellen und erweiterte Freigabe auf „Jeder“ setzen.

Auf DC01

5.        Alternative Suffixe hinzufügen

Test.de und Linux.org hinzufügen

AD „Domains and Trust“ > Rechte Maustaste auf den „Domains and Trusts“ - Einstellungen und dann „alternative UPN - Suffixe“ hinzufügen.

6.         GPO Remote-Desktop

GPO Remote-Desktop erstellen, dann **Gpedit.msc** → Computer-Konfiguration → Richtlinien → Windows-Einstellungen → Sicherheitseinstellungen → Eingeschränkte Gruppen. >> Domänen-User hinzufügen
