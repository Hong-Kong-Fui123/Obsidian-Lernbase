---
tags: [az-802, klausur]
dauer: 60 Min
punkte: 40
bestanden_ab: 28 (70 %)
hilfsmittel: keine
---
# AZ-802 Probeklausur 01
↑ [[AZ-802 MOC]] · Lösungen: [[AZ-802 Klausur 01 - Loesungen]]

> Format wie Prüfung: Einfachauswahl (1 P), Mehrfachauswahl (2 P, alle richtig), Fallstudie, Reihenfolge. Ohne Unterlagen, Zeit stoppen.

## Teil A – AD DS (10 P)
**1.** EXA-DC01 (alle FSMO) ist endgültig defekt. Welche Aktion für den RID Master? (1 P)
a) Transfer per `Move-ADDirectoryServerOperationMasterRole` ohne Parameter
b) Seize per `Move-ADDirectoryServerOperationMasterRole -Force`
c) `ntdsutil` metadata cleanup reicht
d) Neuen DC hochstufen, Rolle wird automatisch übernommen

**2.** Benutzer aus example.com sollen auf Server in contoso.com zugreifen, aber nur auf CON-FS01. Welche zwei Einstellungen? (2 P)
a) Forest-Trust mit selektiver Authentifizierung
b) External Trust ohne SID-Filterung
c) *Allowed to authenticate* auf Computerobjekt CON-FS01
d) Benutzer in Protected Users

**3.** Außenstelle mit RODC. Nur Mitarbeiter der Außenstelle sollen dort Kennwörter zwischenspeichern. Wo konfigurierst du das? (1 P)

**4.** Welches Dienstkonto für einen IIS-App-Pool auf drei Webservern mit automatischer Kennwortrotation? (1 P)
a) sMSA b) gMSA c) virtuelles Konto d) Domänenbenutzer

**5.** Ordne zu: Domain Local / Global / Universal → (i) Mitglieder ganze Gesamtstruktur, im GC (ii) Rechte nur eigene Domäne (iii) Mitglieder nur eigene Domäne (3 P)

**6.** Zwei Standorte, Replikation nur nachts. Welches Objekt konfigurierst du? (1 P)

**7.** Reihenfolge GPO-Verarbeitung? (1 P)

## Teil B – Hybrid + VM (10 P)
**8.** Admin verbindet per `Enter-PSSession` von CL01 auf SRV01 und greift auf `\\SRV03\share` zu → Zugriff verweigert. Empfohlene Lösung? (1 P)
a) CredSSP b) RBKCD auf SRV03 c) TrustedHosts d) Firewall Port 445

**9.** JEA: Welche Datei enthält die sichtbaren Cmdlets? (1 P)

**10.** Welche Verbindung braucht ein Arc-Agent minimal? (1 P)
a) eingehend 443 b) ausgehend 443 c) eingehend 5986 d) Site-to-Site-VPN

**11.** VM ohne Netzwerk, Host Server 2025. Wie führst du Befehle im Gast aus? (1 P)

**12.** Was ist vor dem Aktivieren der geschachtelten Virtualisierung nötig? (2 P – zwei Antworten)
a) VM ausschalten b) dyn. RAM aktivieren c) `ExposeVirtualizationExtensions` d) Gen1-VM

**13.** Hyper-V-Replikat zwischen Hosts ohne gemeinsame Domäne. Authentifizierung und Port? (1 P)

**14.** Azure-VM soll 99,99 % SLA bekommen. Welche Option? (1 P)

**15.** Admins sollen RDP auf Azure-VMs ohne öffentliche IP nutzen. Dienst + Subnetzname? (2 P)

## Teil C – Netzwerk + Speicher (10 P)
**16.** Anfragen für contoso.com sollen an 10.20.0.10 gehen, alle anderen ins Internet. Was konfigurierst du? (1 P)

**17.** Zwei DHCP-Server, einer nur Reserve für Außenstelle. Modus? (1 P)

**18.** Azure-VNet-VMs sollen `example.com` (on-prem) auflösen, ohne eigene DNS-VMs in Azure. Dienst + Komponente? (2 P)

**19.** Freigabe *Vollzugriff*, NTFS *Lesen*. Effektiv über Netzwerk? (1 P)

**20.** Außenstellen-Dateiserver mit kleiner Platte, Daten in Azure. Welche Funktion? (1 P)

**21.** Speicherplatz, der 2 gleichzeitige Datenträgerausfälle übersteht, gute Schreibleistung. Typ + Mindestanzahl Datenträger? (2 P)

**22.** Mobiles Personal ohne VPN soll SMB-Freigabe nutzen. Technik + Port? (1 P)

**23.** Welches Dateisystem für das Boot-Volume? (1 P)

## Teil D – Sicherheit + Troubleshooting (10 P)
**24.** Admins min. 15 Zeichen, Rest 10. Werkzeug? Kann es auf OUs angewendet werden? (2 P)

**25.** Lokale Admin-Kennwörter aller Server automatisch rotieren und im AD speichern. Lösung? (1 P)

**26.** Welche Einschränkungen hat ein Mitglied von *Protected Users*? Nenne zwei. (2 P)

**27.** Benutzer versehentlich gelöscht, Papierkorb aktiv. Befehl? (1 P)

**28.** Client: „Vertrauensstellung zwischen Arbeitsstation und Domäne fehlgeschlagen“. Befehl? (1 P)

**29.** Kerberos-Fehler KRB_AP_ERR_SKEW. Ursache + Toleranz? (1 P)

**30.** Ereignis 4625 von Arc-Servern in Log Analytics sammeln. Welche zwei Komponenten? (2 P)
