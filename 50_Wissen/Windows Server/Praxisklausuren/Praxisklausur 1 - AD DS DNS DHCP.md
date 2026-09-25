---
title: "Praxisklausur 1: Aufbau AD DS, DNS und DHCP"
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
# Praxisklausur 1: Aufbau AD DS, DNS und DHCP

Zurück zur Übersicht: [[00 Uebersicht Praxisklausuren|Übersicht Praxisklausuren]] | Lab-Plan und Hinweise dort

> [!info] Rahmen
> - **Bearbeitungszeit:** 180 min Praxis + 20 min Theorie
> - **Punkte:** Teil A Praxis 70, Teil B Theorie 30, gesamt 100
> - **Benötigte VMs:** EXA-DC01, EXA-DC02, EXA-DHCP01, EXA-CL01
> - **Ausgangslage:** Alle vier VMs sind frisch installiert (Server 2022 bzw. Windows 11), noch nicht umbenannt und nicht konfiguriert. Es existiert noch keine Domäne.
> - Jede Anforderung mit Kästchen abhaken, sobald erledigt und geprüft.
> - Lösungen sind eingeklappt. Erst nach der Bearbeitung öffnen (Lesemodus: Strg+E).

## Teil A: Praxis im Homelab (70 Punkte)

### Aufgabe 1: Netzwerk-Grundkonfiguration (6 Punkte)

Die Server benötigen feste Namen und Adressen.

- [ ] EXA-DC01, EXA-DC02 und EXA-DHCP01 sind wie im Lab-Plan benannt
- [ ] Alle drei Server haben die statische IP-Adresse laut Lab-Plan
- [ ] DNS-Server: DC01 zeigt auf .10 und .11, DC02 auf .11 und .10, DHCP01 auf .10 und .11

**Nachweis:** `ipconfig /all` auf jedem Server

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 1
> **Auf EXA-DC01** (PowerShell als Administrator), für DC02 und DHCP01 analog mit eigener IP:
>
> ```powershell
> Rename-Computer -NewName EXA-DC01 -Restart
> # nach dem Neustart:
> New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.100.10 -PrefixLength 24 -DefaultGateway 192.168.100.1
> Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 192.168.100.10,192.168.100.11
> ```
>
> Hinweis: Solange DC02 noch nicht läuft, bleibt der zweite DNS-Eintrag einfach unbenutzt.

---

### Aufgabe 2: Neue Gesamtstruktur exa.local (10 Punkte)

- [ ] Auf EXA-DC01 ist die Rolle AD DS installiert
- [ ] Die Gesamtstruktur **exa.local** (NetBIOS **EXA**) existiert, DNS ist mitinstalliert
- [ ] Ein DSRM-Kennwort ist gesetzt und dokumentiert

**Nachweis:** `Get-ADDomain`, SRV-Eintrag für `_ldap._tcp.dc._msdcs.exa.local` wird aufgelöst

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 2
> **Auf EXA-DC01** (PowerShell als Administrator):
>
> ```powershell
> Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
> Install-ADDSForest -DomainName exa.local -DomainNetbiosName EXA -InstallDns `
>   -SafeModeAdministratorPassword (Read-Host -AsSecureString "DSRM-Kennwort") -Force
> ```
>
> Prüfen nach dem Neustart:
>
> ```powershell
> Get-ADDomain | Select-Object DNSRoot, NetBIOSName, PDCEmulator
> nslookup -type=SRV _ldap._tcp.dc._msdcs.exa.local
> ```

---

### Aufgabe 3: Zweiter Domänencontroller (8 Punkte)

Die Anmeldung muss auch bei Ausfall von DC01 funktionieren.

- [ ] EXA-DC02 ist zusätzlicher DC der Domäne exa.local
- [ ] DC02 ist DNS-Server und Globaler Katalog
- [ ] Die Replikation läuft fehlerfrei

**Nachweis:** `repadmin /replsummary`, Liste aller DCs mit GC-Status

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 3
> **Auf EXA-DC02** (PowerShell als Administrator):
>
> ```powershell
> Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
> Install-ADDSDomainController -DomainName exa.local -InstallDns `
>   -Credential (Get-Credential EXA\Administrator) `
>   -SafeModeAdministratorPassword (Read-Host -AsSecureString "DSRM-Kennwort") -Force
> ```
>
> Prüfen, **auf EXA-DC01 oder EXA-DC02**:
>
> ```powershell
> repadmin /replsummary
> Get-ADDomainController -Filter * | Select-Object Name, IPv4Address, IsGlobalCatalog
> ```
>
> Ein Domänenbeitritt vorher ist nicht nötig. Install-ADDSDomainController erledigt das.

---

### Aufgabe 4: OU-Struktur und Benutzer per CSV (10 Punkte)

- [ ] OU-Struktur: `EXA` mit den Unter-OUs `Benutzer`, `Computer`, `Gruppen`; unter `Benutzer` die OUs `Vertrieb` und `Technik`
- [ ] Alle OUs sind vor versehentlichem Löschen geschützt
- [ ] Die Benutzer aus der CSV sind per PowerShell in der OU ihrer Abteilung angelegt
- [ ] Anmeldename: erster Buchstabe Vorname + Nachname, klein (z. B. aberg)
- [ ] Die Benutzer müssen das Kennwort bei der ersten Anmeldung ändern

Datei `C:\Lab\neue_mitarbeiter.csv` auf EXA-DC01 anlegen:

```text
Vorname;Nachname;Abteilung
Anna;Berg;Vertrieb
Ben;Kaiser;Vertrieb
Eva;Nowak;Vertrieb
Clara;Lenz;Technik
David;Moser;Technik
```

**Nachweis:** `Get-ADUser -Filter * -SearchBase "OU=Benutzer,OU=EXA,DC=exa,DC=local" -Properties Department`

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 4
> **Auf EXA-DC01** (PowerShell als Administrator):
>
> ```powershell
> $basis = "DC=exa,DC=local"
> New-ADOrganizationalUnit -Name EXA -Path $basis
> foreach ($ou in "Benutzer","Computer","Gruppen") {
>   New-ADOrganizationalUnit -Name $ou -Path "OU=EXA,$basis"
> }
> foreach ($ou in "Vertrieb","Technik") {
>   New-ADOrganizationalUnit -Name $ou -Path "OU=Benutzer,OU=EXA,$basis"
> }
>
> $pw = Read-Host -AsSecureString "Startkennwort"
> Import-Csv C:\Lab\neue_mitarbeiter.csv -Delimiter ';' -Encoding UTF8 | ForEach-Object {
>   $sam = ($_.Vorname.Substring(0,1) + $_.Nachname).ToLower()
>   New-ADUser -Name "$($_.Vorname) $($_.Nachname)" -GivenName $_.Vorname -Surname $_.Nachname `
>     -SamAccountName $sam -UserPrincipalName "$sam@exa.local" -Department $_.Abteilung `
>     -Path "OU=$($_.Abteilung),OU=Benutzer,OU=EXA,$basis" `
>     -AccountPassword $pw -ChangePasswordAtLogon $true -Enabled $true
> }
> ```
>
> New-ADOrganizationalUnit setzt den Löschschutz standardmäßig. Prüfen:
>
> ```powershell
> Get-ADOrganizationalUnit -Filter * -Properties ProtectedFromAccidentalDeletion |
>   Select-Object Name, ProtectedFromAccidentalDeletion
> ```

---

### Aufgabe 5: DHCP-Server (10 Punkte)

- [ ] EXA-DHCP01 ist Mitglied der Domäne, die DHCP-Rolle ist installiert und in AD autorisiert
- [ ] Bereich 192.168.100.100 bis .200, Lease-Dauer 8 Tage
- [ ] Ausschlussbereich .100 bis .109
- [ ] Optionen: Router .1, DNS-Server .10 und .11, DNS-Domäne exa.local
- [ ] Reservierung für den Drucker "Drucker-Flur" (MAC 00-15-5D-00-00-99) auf .150

**Nachweis:** `Get-DhcpServerInDC`, `Get-DhcpServerv4Scope`, `Get-DhcpServerv4Reservation -ScopeId 192.168.100.0`

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 5
> **Auf EXA-DHCP01** (PowerShell als Administrator):
>
> ```powershell
> Add-Computer -DomainName exa.local -Credential EXA\Administrator -Restart
> # nach dem Neustart als EXA\Administrator anmelden:
> Install-WindowsFeature DHCP -IncludeManagementTools
> Add-DhcpServerSecurityGroup
> Restart-Service DHCPServer
> Add-DhcpServerInDC -DnsName EXA-DHCP01.exa.local -IPAddress 192.168.100.50
>
> Add-DhcpServerv4Scope -Name "EXA-LAN" -StartRange 192.168.100.100 -EndRange 192.168.100.200 `
>   -SubnetMask 255.255.255.0 -LeaseDuration 8.00:00:00 -State Active
> Add-DhcpServerv4ExclusionRange -ScopeId 192.168.100.0 -StartRange 192.168.100.100 -EndRange 192.168.100.109
> Set-DhcpServerv4OptionValue -ScopeId 192.168.100.0 -Router 192.168.100.1 `
>   -DnsServer 192.168.100.10,192.168.100.11 -DnsDomain exa.local
> Add-DhcpServerv4Reservation -ScopeId 192.168.100.0 -IPAddress 192.168.100.150 `
>   -ClientId "00-15-5D-00-00-99" -Name "Drucker-Flur"
> ```
>
> Optional, damit der Server-Manager keinen Hinweis mehr zeigt:
>
> ```powershell
> Set-ItemProperty HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2
> ```

---

### Aufgabe 6: Dateifreigabe nach AGDLP (8 Punkte)

Der Vertrieb braucht eine Freigabe mit Änderungsrechten. Abteilungswechsel sollen nur eine Gruppenänderung erfordern.

- [ ] Globale Gruppe `GG_Vertrieb` mit allen Vertriebsmitarbeitern (OU Gruppen)
- [ ] Domänenlokale Gruppe `DL_Vertrieb_Aendern`, Mitglied: `GG_Vertrieb`
- [ ] Ordner `C:\Shares\Vertrieb` auf EXA-DHCP01, freigegeben als `Vertrieb`
- [ ] NTFS: `DL_Vertrieb_Aendern` hat Ändern; die Freigabeberechtigung steht der NTFS-Berechtigung nicht im Weg

**Nachweis:** Als aberg auf `\\EXA-DHCP01\Vertrieb` eine Datei anlegen; als clenz (Technik) keinen Zugriff

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 6
> **Auf EXA-DC01** (PowerShell als Administrator):
>
> ```powershell
> $gr = "OU=Gruppen,OU=EXA,DC=exa,DC=local"
> New-ADGroup -Name GG_Vertrieb -GroupScope Global -GroupCategory Security -Path $gr
> New-ADGroup -Name DL_Vertrieb_Aendern -GroupScope DomainLocal -GroupCategory Security -Path $gr
> Get-ADUser -Filter "Department -eq 'Vertrieb'" | ForEach-Object { Add-ADGroupMember GG_Vertrieb -Members $_ }
> Add-ADGroupMember DL_Vertrieb_Aendern -Members GG_Vertrieb
> ```
>
> **Auf EXA-DHCP01** (PowerShell als Administrator):
>
> ```powershell
> New-Item C:\Shares\Vertrieb -ItemType Directory
> New-SmbShare -Name Vertrieb -Path C:\Shares\Vertrieb -ChangeAccess "EXA\DL_Vertrieb_Aendern" `
>   -FullAccess "EXA\Domänen-Admins"
> icacls C:\Shares\Vertrieb /inheritance:d
> icacls C:\Shares\Vertrieb /remove:g "VORDEFINIERT\Benutzer"
> icacls C:\Shares\Vertrieb /grant "EXA\DL_Vertrieb_Aendern:(OI)(CI)M"
> ```
>
> Die Gruppenmitgliedschaft wirkt erst nach neuer Anmeldung (neues Kerberos-Ticket).

---

### Aufgabe 7: Client in die Domäne (8 Punkte)

- [ ] EXA-CL01 erhält seine Adresse per DHCP
- [ ] EXA-CL01 ist Domänenmitglied und liegt in der OU `Computer`
- [ ] Neue Computerkonten landen künftig automatisch in dieser OU
- [ ] Anmeldung als aberg funktioniert, das Kennwort muss geändert werden

**Nachweis:** `ipconfig /all` auf CL01, `Get-ADComputer EXA-CL01`

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 7
> **Auf EXA-CL01** (PowerShell als Administrator):
>
> ```powershell
> ipconfig /all        # Adresse aus 192.168.100.110-200, DNS .10 und .11
> Rename-Computer -NewName EXA-CL01 -Restart
> Add-Computer -DomainName exa.local -Credential EXA\Administrator `
>   -OUPath "OU=Computer,OU=EXA,DC=exa,DC=local" -Restart
> ```
>
> **Auf EXA-DC01** (Eingabeaufforderung als Administrator):
>
> ```cmd
> redircmp "OU=Computer,OU=EXA,DC=exa,DC=local"
> ```

---

### Aufgabe 8: Fehlerbehebung: Client ohne Domäne (10 Punkte)

**Erst ausführen, wenn Aufgabe 1 bis 7 fertig sind:** Vorbereitungsskript "Klausur 1 - Aufgabe 8" aus [[Vorbereitung - Fehler einbauen]] ausführen, ohne die Lösung zu lesen.

Ticket: *"Nach einem Neustart kann sich auf EXA-CL01 niemand mehr an der Domäne anmelden. Die IP-Adresse beginnt mit 169.254."*

- [ ] Alle Ursachen gefunden (es sind zwei)
- [ ] Beide Ursachen behoben, Anmeldung als aberg funktioniert wieder
- [ ] Dokumentation: Symptom, Diagnosebefehl, Ursache, Lösung

**Nachweis:** Kurze Dokumentation in dieser Notiz unter "Meine Lösung"

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 8
> **Ursache 1:** Der DHCP-Server ist in AD nicht mehr autorisiert (roter Pfeil im DHCP-Manager). Der Client erhält keine Adresse und nutzt APIPA (169.254.x.x).
>
> **Ursache 2:** Auf dem Client ist als DNS-Server 8.8.8.8 fest eingetragen. Die SRV-Einträge der Domäne sind dort nicht bekannt.
>
> **Diagnose auf EXA-CL01:**
>
> ```powershell
> ipconfig /all
> nslookup -type=SRV _ldap._tcp.dc._msdcs.exa.local
> ```
>
> **Diagnose auf EXA-DHCP01:**
>
> ```powershell
> Get-DhcpServerInDC
> ```
>
> **Lösung auf EXA-DHCP01** (PowerShell als Administrator):
>
> ```powershell
> Add-DhcpServerInDC -DnsName EXA-DHCP01.exa.local -IPAddress 192.168.100.50
> ```
>
> **Lösung auf EXA-CL01** (lokal als Administrator):
>
> ```powershell
> Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ResetServerAddresses
> ipconfig /renew
> Test-ComputerSecureChannel
> ```

---

## Teil B: Theorie (30 Punkte)

Je Frage 3 Punkte. Genau eine Antwort ist richtig, bei Eingabefragen die Antwort eintragen.

**Frage 1** (AD DS - Domänendienste)

Für Administratoren soll eine Kennwortrichtlinie mit 16 Zeichen gelten, für alle anderen Benutzer nur 8 Zeichen. Es soll keine zweite Domäne angelegt werden.

**Frage:** Welche Funktion nutzen Sie?

- [ ] A) Fein abgestufte Kennwortrichtlinie (PSO), zugewiesen an eine Sicherheitsgruppe
- [ ] B) Mehrere Default Domain Policies
- [ ] C) Ein zweiter Globaler Katalog
- [ ] D) Ein RODC für Administratoren

> [!success]- Lösung Frage 1
> **A)** Fein abgestufte Kennwortrichtlinie (PSO), zugewiesen an eine Sicherheitsgruppe
>
> Fine-Grained Password Policies (Password Settings Objects) erlauben unterschiedliche Kennwortrichtlinien innerhalb einer Domäne.

**Frage 2** (Netzwerk - IPv4/IPv6, Routing, DNS, DHCP)

Drei Webserver (10.0.0.11 bis 10.0.0.13) sollen unter dem Namen www.contoso.com erreichbar sein und Anfragen möglichst gleichmäßig verteilt bekommen. Eine Lastenausgleichslösung steht nicht zur Verfügung.

**Frage:** Was tun Sie im DNS?

- [ ] A) Nur einen A-Eintrag für den ersten Server anlegen
- [ ] B) Einen MX-Eintrag anlegen
- [ ] C) Drei A-Einträge mit dem Namen www anlegen (Round Robin)
- [ ] D) Einen SRV-Eintrag anlegen

> [!success]- Lösung Frage 2
> **C)** Drei A-Einträge mit dem Namen www anlegen (Round Robin)
>
> DNS Round Robin liefert die Adressen abwechselnd zurück; eine Ausfallerkennung erfolgt dabei nicht.

**Frage 3** (Netzwerk - IPv4/IPv6, Routing, DNS, DHCP)

Wie lautet die Standardroute in IPv4?

- [ ] A) 127.0.0.1/32
- [ ] B) 255.255.255.255/32
- [ ] C) 0.0.0.0/0
- [ ] D) 169.254.0.0/16

> [!success]- Lösung Frage 3
> **C)** 0.0.0.0/0
>
> 0.0.0.0/0 (IPv6: ::/0) passt auf alle Ziele ohne spezifischere Route.

**Frage 4** (AD DS - Domänendienste)

Wofür wird das DSRM-Kennwort (Verzeichnisdienste-Wiederherstellungsmodus) benötigt?

- [ ] A) Für die Anmeldung des Domänen-Administrators am Client
- [ ] B) Für den Offline-Start des DC im Wiederherstellungsmodus
- [ ] C) Für die Replikation zwischen DCs
- [ ] D) Für den Betrieb des DNS-Servers

> [!success]- Lösung Frage 4
> **B)** Für den Offline-Start des DC im Wiederherstellungsmodus
>
> DSRM ist der Offline-Wiederherstellungsmodus mit eigenem lokalem Kennwort.

**Frage 5** (AD DS - Domänendienste)

Welche Gruppenbereiche (Scopes) gibt es in Active Directory?

- [ ] A) Lokal, Remote, Global
- [ ] B) Domänenlokal, Global, Universal
- [ ] C) Privat, Öffentlich, Universal
- [ ] D) Benutzer, Computer, Gerät

> [!success]- Lösung Frage 5
> **B)** Domänenlokal, Global, Universal
>
> Domänenlokal, Global und Universal.

**Frage 6** (Netzwerk - IPv4/IPv6, Routing, DNS, DHCP)

Die Domäne contoso.com wird öffentlich von einem Provider aufgelöst. Intern soll intranet.contoso.com auf 10.0.0.5 zeigen, extern auf die öffentliche Adresse.

**Frage:** Welche Lösung setzen Sie um?

- [ ] A) Split-DNS: Auf den internen DNS-Servern eine Zone contoso.com mit den internen Einträgen führen; die externe Zone bleibt beim Provider
- [ ] B) Auf jedem Client die Hosts-Datei pflegen
- [ ] C) Nur einen CNAME anlegen
- [ ] D) Einen DHCP-Bereich mit Domänenoption anlegen

> [!success]- Lösung Frage 6
> **A)** Split-DNS: Auf den internen DNS-Servern eine Zone contoso.com mit den internen Einträgen führen; die externe Zone bleibt beim Provider
>
> Bei Split-DNS liefern interne und externe DNS-Server für denselben Namen unterschiedliche Antworten.

**Frage 7** (Netzwerk - IPv4/IPv6, Routing, DNS, DHCP)

Wie aktivieren Sie die Paketweiterleitung (IP-Forwarding) auf einer Netzwerkschnittstelle per PowerShell?

- [ ] A) Set-NetFirewallProfile -Enabled False
- [ ] B) Set-NetIPInterface -Forwarding Enabled
- [ ] C) Enable-NetAdapter
- [ ] D) Disable-NetAdapterBinding -ComponentID ms_tcpip

> [!success]- Lösung Frage 7
> **B)** Set-NetIPInterface -Forwarding Enabled
>
> Set-NetIPInterface -Forwarding Enabled aktiviert das Weiterleiten.

**Frage 8** (Netzwerk - IPv4/IPv6, Routing, DNS, DHCP)

Was ist in einer Active Directory-Umgebung vor dem produktiven Betrieb eines DHCP-Servers erforderlich?

- [ ] A) Ein Neustart des Clients
- [ ] B) Ein statisches Gateway
- [ ] C) Die Autorisierung des DHCP-Servers in AD
- [ ] D) Ein Schreibzugriff auf SYSVOL

> [!success]- Lösung Frage 8
> **C)** Die Autorisierung des DHCP-Servers in AD
>
> Nicht autorisierte DHCP-Server vergeben in AD-Domänen keine Adressen (Schutz vor Rogue-DHCP).

**Frage 9** (AD DS - Domänendienste)

Welches Protokoll wird in einer AD-Domäne standardmäßig zur Authentifizierung verwendet?

- [ ] A) NTLMv1
- [ ] B) RADIUS
- [ ] C) Kerberos
- [ ] D) SMTP

> [!success]- Lösung Frage 9
> **C)** Kerberos
>
> Kerberos ist das Standardprotokoll; NTLM dient nur als Fallback.

**Frage 10** (Netzwerk - IPv4/IPv6, Routing, DNS, DHCP)

Clients im Büro erhalten plötzlich das Standardgateway 192.168.0.1 und einen unbekannten DNS-Server, obwohl der zentrale DHCP-Server (10.0.0.1) andere Werte verteilt. Ein Mitarbeiter hat einen privaten WLAN-Router am Netzwerk angeschlossen.

**Frage:** Was ist die Ursache und Gegenmaßnahme?

- [ ] A) Der DNS-Cache der Clients ist beschädigt
- [ ] B) Der Bereich des zentralen Servers ist zu klein
- [ ] C) Ein nicht autorisierter DHCP-Server (Rogue-DHCP) im Netz; Gerät entfernen und DHCP-Snooping auf den Switches aktivieren
- [ ] D) Die Kerberos-Zeit weicht ab

> [!success]- Lösung Frage 10
> **C)** Ein nicht autorisierter DHCP-Server (Rogue-DHCP) im Netz; Gerät entfernen und DHCP-Snooping auf den Switches aktivieren
>
> Ein privater Router mit aktivem DHCP antwortet schneller und verteilt falsche Einstellungen.

---

## Bewertung

| Teil | Max. | Erreicht |
|---|---|---|
| A1 Netzwerk-Grundkonfiguration | 6 | |
| A2 Neue Gesamtstruktur exa.local | 10 | |
| A3 Zweiter Domänencontroller | 8 | |
| A4 OU-Struktur und Benutzer per CSV | 10 | |
| A5 DHCP-Server | 10 | |
| A6 Dateifreigabe nach AGDLP | 8 | |
| A7 Client in die Domäne | 8 | |
| A8 Fehlerbehebung: Client ohne Domäne | 10 | |
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
