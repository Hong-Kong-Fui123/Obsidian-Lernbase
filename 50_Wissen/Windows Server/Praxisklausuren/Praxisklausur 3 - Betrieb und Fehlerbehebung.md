---
title: "Praxisklausur 3: Betrieb und Fehlerbehebung"
tags:
  - klausur
  - homelab
  - windows-server
thema: Windows Server 2022
typ: Praxisklausur
bearbeitungszeit: 180 min Praxis + 20 min Theorie
punkte: 100
status: offen
ergebnis:
datum:
---
# Praxisklausur 3: Betrieb und Fehlerbehebung

Zurück zur Übersicht: [[00 Uebersicht Praxisklausuren|Übersicht Praxisklausuren]] | Lab-Plan und Hinweise dort

> [!info] Rahmen
> - **Bearbeitungszeit:** 180 min Praxis + 20 min Theorie
> - **Punkte:** Teil A Praxis 70, Teil B Theorie 30, gesamt 100
> - **Benötigte VMs:** EXA-DC01, EXA-DC02, EXA-DHCP01, EXA-CL01
> - **Ausgangslage:** Endzustand von Praxisklausur 1 (Praxisklausur 2 ist nicht nötig). **Vor dem Start** das Vorbereitungsskript "Klausur 3" aus [[Vorbereitung - Fehler einbauen]] ausführen, ohne die Lösungen zu lesen. Aufgaben in der angegebenen Reihenfolge bearbeiten.
> - Jede Anforderung mit Kästchen abhaken, sobald erledigt und geprüft.
> - Lösungen sind eingeklappt. Erst nach der Bearbeitung öffnen (Lesemodus: Strg+E).

## Teil A: Praxis im Homelab (70 Punkte)

### Aufgabe 1: FSMO-Rollen übertragen (8 Punkte)

EXA-DC01 soll gewartet werden.

- [ ] Alle fünf [[FSMO]]-Rollen liegen geordnet auf EXA-DC02 (kein Seizing)
- [ ] Sie können begründen, warum hier nicht mit -Force gearbeitet wird

**Nachweis:** `netdom query fsmo`

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 1
> **Auf EXA-DC01 oder EXA-DC02** (PowerShell als Organisations- und Schema-Admin):
>
> ```powershell
> Move-ADDirectoryServerOperationMasterRole -Identity EXA-DC02 `
>   -OperationMasterRole SchemaMaster, DomainNamingMaster, PDCEmulator, RIDMaster, InfrastructureMaster `
>   -Confirm:$false
> netdom query fsmo
> ```
>
> Seizing (-Force) nur, wenn der alte Rolleninhaber dauerhaft ausgefallen ist. DC01 ist online, also Transfer.
>
> Wichtig für Aufgabe 6: Der [[PDC]]-Emulator ist jetzt **EXA-DC02**.

---

### Aufgabe 2: AD-Papierkorb und Wiederherstellung (10 Punkte)

- [ ] Der [[AD]]-Papierkorb ist aktiviert
- [ ] Simulieren: Löschschutz der [[OU]] `Vertrieb` entfernen und die OU samt Inhalt löschen
- [ ] OU, Benutzer und deren Mitgliedschaft in `GG_Vertrieb` sind wiederhergestellt
- [ ] Löschschutz ist wieder aktiv

**Nachweis:** `Get-ADGroupMember GG_Vertrieb`

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 2
> **Auf EXA-DC02** (PowerShell als Organisations-Admin):
>
> ```powershell
> Enable-ADOptionalFeature -Identity "Recycle Bin Feature" -Scope ForestOrConfigurationSet `
>   -Target exa.local -Confirm:$false
>
> $ou = "OU=Vertrieb,OU=Benutzer,OU=EXA,[[DC]]=exa,DC=local"
> Set-ADOrganizationalUnit $ou -ProtectedFromAccidentalDeletion $false
> Remove-ADOrganizationalUnit $ou -Recursive -Confirm:$false
>
> # Wiederherstellen: zuerst die OU, dann der Inhalt
> Get-ADObject -Filter 'isDeleted -eq $true -and Name -like "Vertrieb*"' -IncludeDeletedObjects |
>   Where-Object ObjectClass -eq "organizationalUnit" | Restore-ADObject
> Get-ADObject -Filter "LastKnownParent -eq '$ou'" -IncludeDeletedObjects | Restore-ADObject
>
> Set-ADOrganizationalUnit $ou -ProtectedFromAccidentalDeletion $true
> Get-ADGroupMember GG_Vertrieb
> ```
>
> Der Papierkorb lässt sich nicht mehr deaktivieren. Ohne Papierkorb wäre eine autoritative Wiederherstellung im DSRM nötig.

---

### Aufgabe 3: Fein abgestufte Kennwortrichtlinie (8 Punkte)

- [ ] PSO **PSO_Admins** für die Gruppe Domänen-Admins: mindestens 16 Zeichen, komplex, Kennwortchronik 24, maximal 90 Tage
- [ ] Alle anderen Benutzer behalten die Standardrichtlinie

**Nachweis:** `Get-ADUserResultantPasswordPolicy Administrator` und `Get-ADUserResultantPasswordPolicy aberg`

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 3
> **Auf EXA-DC02** (PowerShell als Domänen-Admin):
>
> ```powershell
> New-ADFineGrainedPasswordPolicy -Name PSO_Admins -Precedence 10 -MinPasswordLength 16 `
>   -ComplexityEnabled $true -PasswordHistoryCount 24 -MaxPasswordAge "90.00:00:00" `
>   -MinPasswordAge "1.00:00:00" -LockoutThreshold 5 -LockoutDuration "00:30:00" `
>   -LockoutObservationWindow "00:30:00" -ReversibleEncryptionEnabled $false
> Add-ADFineGrainedPasswordPolicySubject PSO_Admins -Subjects "Domänen-Admins"
>
> Get-ADUserResultantPasswordPolicy Administrator
> Get-ADUserResultantPasswordPolicy aberg      # keine Ausgabe = Standardrichtlinie
> ```

---

### Aufgabe 4: Delegierung für den Helpdesk (8 Punkte)

- [ ] Benutzer `hdesk` (OU Benutzer) und Gruppe `GG_Helpdesk` angelegt, hdesk ist Mitglied
- [ ] `GG_Helpdesk` darf in der OU `Benutzer` Kennwörter zurücksetzen und "Kennwort bei nächster Anmeldung ändern" setzen, sonst nichts

**Nachweis:** Mit hdesk-Anmeldedaten gelingt die Kennwortrücksetzung für aberg, für Administrator schlägt sie fehl

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 4
> **Auf EXA-DC02** (PowerShell als Domänen-Admin):
>
> ```powershell
> New-ADGroup -Name GG_Helpdesk -GroupScope Global -Path "OU=Gruppen,OU=EXA,DC=exa,DC=local"
> New-ADUser -Name "Helpdesk" -SamAccountName hdesk -UserPrincipalName hdesk@exa.local `
>   -Path "OU=Benutzer,OU=EXA,DC=exa,DC=local" -AccountPassword (Read-Host -AsSecureString) -Enabled $true
> Add-ADGroupMember GG_Helpdesk -Members hdesk
>
> dsacls "OU=Benutzer,OU=EXA,DC=exa,DC=local" /I:S /G `
>   "EXA\GG_Helpdesk:[[CA]];Reset Password;user" `
>   "EXA\GG_Helpdesk:RP;pwdLastSet;user" `
>   "EXA\GG_Helpdesk:WP;pwdLastSet;user"
> ```
>
> Alternativ per [[GUI]]: `dsa.msc` > OU Benutzer > Objektverwaltung zuweisen > "Setzt Benutzerkennwörter zurück und erzwingt Kennwortänderung bei der nächsten Anmeldung".
>
> **Test auf EXA-DC02:**
>
> ```powershell
> $hd = Get-Credential EXA\hdesk
> Set-ADAccountPassword aberg -Reset -NewPassword (Read-Host -AsSecureString) -Credential $hd          # klappt
> Set-ADAccountPassword Administrator -Reset -NewPassword (Read-Host -AsSecureString) -Credential $hd  # Zugriff verweigert
> ```

---

### Aufgabe 5: Fehlerbehebung: Vertrauensstellung (8 Punkte)

Ticket: *"Auf EXA-CL01 erscheint bei der Domänenanmeldung: Die Vertrauensstellung zwischen dieser Arbeitsstation und der primären Domäne konnte nicht hergestellt werden."*

- [ ] Ursache ermittelt
- [ ] Behoben, **ohne** den Computer aus der Domäne zu nehmen

**Nachweis:** `Test-ComputerSecureChannel` liefert True, Anmeldung als aberg funktioniert

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 5
> **Ursache:** Das Kennwort des Computerkontos in AD passt nicht mehr zu dem auf dem Client (sicherer Kanal defekt).
>
> **Auf EXA-CL01** (lokal als Administrator anmelden, z. B. `.\Administrator`):
>
> ```powershell
> Test-ComputerSecureChannel                      # False
> Test-ComputerSecureChannel -Repair -Credential EXA\Administrator
> Test-ComputerSecureChannel                      # True
> ```
>
> Alternative: `Reset-ComputerMachinePassword -Credential EXA\Administrator`

---

### Aufgabe 6: Fehlerbehebung: Konto wird ständig gesperrt (10 Punkte)

Setzen Sie zuerst die Kontosperrung in der Standarddomänenrichtlinie: 5 Fehlversuche, Sperrdauer und Zurücksetzen nach 15 Minuten.

Ticket danach: *"Anna Berg (aberg) ist ständig gesperrt, obwohl sie ihr Kennwort nicht falsch eingibt."*

- [ ] Kontosperrrichtlinie gesetzt
- [ ] Das Gerät gefunden, von dem die Sperrungen ausgehen, mit Diagnosebefehl
- [ ] Die Ursache auf dem Gerät beseitigt, Konto entsperrt, keine neuen Sperrungen

**Nachweis:** Ereignis mit Quellcomputer, `Search-ADAccount -LockedOut` leer

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 6
> **Auf EXA-DC02** (PowerShell als Domänen-Admin):
>
> ```powershell
> Set-ADDefaultDomainPasswordPolicy -Identity exa.local -LockoutThreshold 5 `
>   -LockoutDuration "00:15:00" -LockoutObservationWindow "00:15:00"
>
> Search-ADAccount -LockedOut | Select-Object SamAccountName
> Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4740} |
>   Select-Object TimeCreated, @{n='Konto';e={$_.Properties[0].Value}}, @{n='Quelle';e={$_.Properties[1].Value}}
> ```
>
> Ereignis 4740 steht auf dem **PDC-Emulator** (nach Aufgabe 1: EXA-DC02). Quelle: **EXA-CL01**.
>
> **Ursache auf EXA-CL01:** Die geplante Aufgabe "Laufwerk-Vertrieb" verbindet sich jede Minute mit einem alten Kennwort.
>
> ```powershell
> Get-ScheduledTask | Where-Object TaskPath -eq "\" | Select-Object TaskName, State
> Unregister-ScheduledTask -TaskName "Laufwerk-Vertrieb" -Confirm:$false
> ```
>
> **Auf EXA-DC02:**
>
> ```powershell
> Unlock-ADAccount aberg
> ```
>
> Falls kein Ereignis 4740 erscheint: In der "Default Domain Controllers Policy" die Überwachung "Benutzerkontenverwaltung" (Erfolg) aktivieren.

---

### Aufgabe 7: Fehlerbehebung: GPO greift nicht (8 Punkte)

- [ ] [[GPO]] **SEC-Basis** angelegt und mit der Domäne verknüpft: Interaktive Anmeldung - Letzten Benutzernamen nicht anzeigen = Aktiviert
- [ ] Die GPO muss auf **allen** Computern gelten

Ticket: *"Auf EXA-CL01 wird SEC-Basis nicht angewendet."* Die Einstellungen der betroffenen OU dürfen nicht geändert werden.

- [ ] Ursache ermittelt und so behoben, dass die OU unverändert bleibt

**Nachweis:** `gpresult /r /scope computer` auf EXA-CL01 zeigt SEC-Basis

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 7
> **Ursache:** EXA-CL01 liegt in der OU `Labor`, dort ist "Vererbung deaktivieren" gesetzt.
>
> **Auf EXA-DC02** (PowerShell als Domänen-Admin):
>
> ```powershell
> New-GPO -Name "SEC-Basis" | New-GPLink -Target "DC=exa,DC=local"
> Set-GPRegistryValue -Name "SEC-Basis" `
>   -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
>   -ValueName DontDisplayLastUserName -Type DWord -Value 1
>
> Get-ADComputer EXA-CL01 | Select-Object DistinguishedName
> Get-GPInheritance -Target "OU=Labor,OU=EXA,DC=exa,DC=local"
> Set-GPLink -Name "SEC-Basis" -Target "DC=exa,DC=local" -Enforced Yes
> ```
>
> **Auf EXA-CL01:**
>
> ```powershell
> gpupdate /force
> gpresult /r /scope computer
> ```
>
> Erzwungene Verknüpfungen setzen sich gegen blockierte Vererbung durch.

---

### Aufgabe 8: DNS erweitern (10 Punkte)

- [ ] AD-integrierte Reverse-Lookupzone für 192.168.100.0/24 (Replikation: Domäne)
- [ ] PTR-Einträge für EXA-DC01 und EXA-DC02
- [ ] Bedingte Weiterleitung für **fabrikam.local** an 10.99.0.53, gesamtstrukturweit repliziert
- [ ] Alias **dateien.exa.local** zeigt auf EXA-DHCP01

**Nachweis:** `nslookup 192.168.100.10`, `nslookup dateien.exa.local`, `Get-DnsServerZone`

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 8
> **Auf EXA-DC02** (PowerShell als Domänen-Admin):
>
> ```powershell
> Add-DnsServerPrimaryZone -NetworkId "192.168.100.0/24" -ReplicationScope Domain
> Add-DnsServerResourceRecordPtr -ZoneName "100.168.192.in-addr.arpa" -Name 10 -PtrDomainName EXA-DC01.exa.local
> Add-DnsServerResourceRecordPtr -ZoneName "100.168.192.in-addr.arpa" -Name 11 -PtrDomainName EXA-DC02.exa.local
> Add-DnsServerConditionalForwarderZone -Name fabrikam.local -MasterServers 10.99.0.53 -ReplicationScope Forest
> Add-DnsServerResourceRecordCName -ZoneName exa.local -Name dateien -HostNameAlias EXA-DHCP01.exa.local
> ```
>
> **Test auf EXA-CL01:**
>
> ```powershell
> nslookup 192.168.100.10
> nslookup dateien.exa.local
> ```

---

## Teil B: Theorie (30 Punkte)

Je Frage 3 Punkte. Genau eine Antwort ist richtig, bei Eingabefragen die Antwort eintragen.

**Frage 1** (Netzwerk - [[IPv4]]/[[IPv6]], Routing, [[DNS]], [[DHCP]])

Ein Multihomed-Server ([[LAN]] und [[WAN]]) hat auf beiden Netzwerkkarten ein Standardgateway eingetragen. Die Verbindungen sind unregelmäßig.

**Frage:** Was ist zu tun?

- [ ] A) Beide Standardgateways belassen
- [ ] B) Die WAN-Karte deaktivieren
- [ ] C) Nur ein Standardgateway konfigurieren und für andere Netze statische Routen verwenden
- [ ] D) Die Metrik auf 0 setzen

> [!success]- Lösung Frage 1
> **C)** Nur ein Standardgateway konfigurieren und für andere Netze statische Routen verwenden
>
> Ein Host sollte nur eine Standardroute haben; weitere Ziele werden über statische Routen erreicht.

**Frage 2** (Netzwerk - IPv4/IPv6, Routing, DNS, DHCP)

Wie lautet die korrekte Kurzschreibweise von 2001:0db8:0000:0000:0000:0000:0000:0001?
(Adresse eingeben)

Antwort: 

> [!success]- Lösung Frage 2
> **2001:db8::1**
>
> Führende Nullen entfallen, eine Folge von Nullgruppen wird einmal durch :: ersetzt.

**Frage 3** ([[AD DS]] - Domänendienste)

Wie viele FSMO-Rollen (Betriebsmaster) gibt es insgesamt?
(Zahl eingeben)

Antwort: 

> [!success]- Lösung Frage 3
> **5**
>
> Fünf Rollen: Schemamaster, Domänennamenmaster, PDC-Emulator, [[RID]]-Master, Infrastrukturmaster.

**Frage 4** (AD DS - Domänendienste)

Welche Voraussetzung sollte vor der Heraufstufung eines Servers zum Domänencontroller erfüllt sein?

- [ ] A) Der Server erhält seine [[IP]]-Adresse per DHCP
- [ ] B) Der Server hat eine statische IP-Adresse und einen eindeutigen Computernamen
- [ ] C) Auf dem Server ist Exchange installiert
- [ ] D) Der Server ist Mitglied einer Arbeitsgruppe mit dem Namen der künftigen Domäne

> [!success]- Lösung Frage 4
> **B)** Der Server hat eine statische IP-Adresse und einen eindeutigen Computernamen
>
> Ein DC braucht eine statische IP-Adresse und einen festen Computernamen.

**Frage 5** (AD DS - Domänendienste)

In einer Domäne ist der AD-Papierkorb nicht aktiviert. Ein Benutzerkonto samt Gruppenmitgliedschaften wurde gestern gelöscht. Es existiert eine Systemstatus-Sicherung von vorgestern.

**Frage:** Welches Verfahren stellt das Objekt mit den ursprünglichen Attributen wieder her?

- [ ] A) Restore-ADObject ohne Sicherung
- [ ] B) Ein neues Konto mit gleichem Namen anlegen; die [[SID]] ist dann identisch
- [ ] C) gpupdate /force
- [ ] D) Autoritative Wiederherstellung aus der Sicherung im DSRM mit ntdsutil

> [!success]- Lösung Frage 5
> **D)** Autoritative Wiederherstellung aus der Sicherung im DSRM mit ntdsutil
>
> Ohne Papierkorb hilft die autoritative Wiederherstellung (DSRM, Systemstatus-Sicherung, ntdsutil), damit die Replikation das Objekt nicht wieder löscht.

**Frage 6** (AD DS - Domänendienste)

Mit welchem Befehl prüfen Sie den Replikationsstatus aller DCs übersichtlich?

- [ ] A) repadmin /replsummary
- [ ] B) ping -r
- [ ] C) gpupdate /repl
- [ ] D) netstat -ad

> [!success]- Lösung Frage 6
> **A)** repadmin /replsummary
>
> repadmin /replsummary fasst den Replikationsstatus zusammen.

**Frage 7** (AD DS - Domänendienste)

Benutzer melden Anmeldeprobleme und [[Kerberos]]-Fehler. Eine Prüfung zeigt, dass die Uhr des Mitgliedsservers SRV03 zehn Minuten von der Domänenzeit abweicht.

**Frage:** Warum schlägt die Anmeldung fehl, und wie beheben Sie es?

- [ ] A) [[NTLM]] ist deaktiviert; NTLM aktivieren
- [ ] B) Die Kerberos-Zeittoleranz von 5 Minuten ist überschritten; Zeit mit der Domäne synchronisieren (z. B. w32tm /resync)
- [ ] C) Das Kennwort ist abgelaufen; Kennwort zurücksetzen
- [ ] D) Der Globale Katalog ist nicht erreichbar; GC neu starten

> [!success]- Lösung Frage 7
> **B)** Die Kerberos-Zeittoleranz von 5 Minuten ist überschritten; Zeit mit der Domäne synchronisieren (z. B. w32tm /resync)
>
> Kerberos toleriert standardmäßig nur 5 Minuten Abweichung. Die Domänenzeit kommt vom PDC-Emulator.

**Frage 8** (Netzwerk - IPv4/IPv6, Routing, DNS, DHCP)

Ein Administrator legt mit "route add 10.4.0.0 mask 255.255.0.0 10.1.0.254" eine Route an. Nach dem Neustart des Servers ist die Route verschwunden.

**Frage:** Wie legen Sie die Route dauerhaft an?

- [ ] A) Den Server nie mehr neu starten
- [ ] B) Die Route in den Ordner [[SYSVOL]] kopieren
- [ ] C) Mit dem Parameter -p (route add ... -p) oder mit New-NetRoute (persistenter Speicher) anlegen
- [ ] D) Einen DNS-Eintrag für das Zielnetz anlegen

> [!success]- Lösung Frage 8
> **C)** Mit dem Parameter -p (route add ... -p) oder mit New-NetRoute (persistenter Speicher) anlegen
>
> route add ohne -p gilt nur bis zum Neustart; mit -p bzw. New-NetRoute wird die Route dauerhaft gespeichert.

**Frage 9** (Netzwerk - IPv4/IPv6, Routing, DNS, DHCP)

Welcher Adressbereich (Netz/Präfix) wird bei einem Windows-Client verwendet, wenn kein DHCP-Server erreichbar ist ([[APIPA]])?
(Eingabe, z. B. 10.0.0.0/8)

Antwort: 

> [!success]- Lösung Frage 9
> **169.254.0.0/16**
>
> APIPA vergibt Adressen aus 169.254.0.0/16 (Link-Local).

**Frage 10** (AD DS - Domänendienste)

Welches Werkzeug prüft die allgemeine Integrität eines Domänencontrollers?

- [ ] A) chkdsk
- [ ] B) sfc /scannow
- [ ] C) dcdiag
- [ ] D) msinfo32

> [!success]- Lösung Frage 10
> **C)** dcdiag
>
> dcdiag führt Integritäts- und Funktionstests des DCs durch.

---

## Bewertung

| Teil | Max. | Erreicht |
|---|---|---|
| A1 FSMO-Rollen übertragen | 8 | |
| A2 AD-Papierkorb und Wiederherstellung | 10 | |
| A3 Fein abgestufte Kennwortrichtlinie | 8 | |
| A4 Delegierung für den Helpdesk | 8 | |
| A5 Fehlerbehebung: Vertrauensstellung | 8 | |
| A6 Fehlerbehebung: Konto wird ständig gesperrt | 10 | |
| A7 Fehlerbehebung: GPO greift nicht | 8 | |
| A8 DNS erweitern | 10 | |
| Teil B Theorie (10 x 3) | 30 | |
| **Gesamt** | **100** | |

| Punkte | Note (IHK) |
|---|---|
| 92-100 | 1 - sehr gut |
| 81-91 | 2 - gut |
| 67-80 | 3 - befriedigend |
| 50-66 | 4 - ausreichend |
| 30-49 | 5 - mangelhaft |
| 0-29 | 6 - ungenügend |

Bewertungshinweis Praxis: volle Punkte nur, wenn alle Kästchen erfüllt und per Nachweis geprüft sind. Teilpunkte anteilig.

**Themen zum Wiederholen:**

- 
