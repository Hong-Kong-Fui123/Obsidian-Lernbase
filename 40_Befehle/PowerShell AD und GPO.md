---
typ: befehle
thema: Windows Server
tags: [befehle, powershell, active-directory, gpo]
quelle: Word-Notizen
status: importiert
---
# PowerShell AD und GPO

Thema: [[Windows Server]]

### Schema in mmc einfügen (AD)?

regsvr32 schmmgmt.dll

Wo ist die netlogon-Datei gespeichert?

C:\Windows\System32\config\netlogon.dns

_Zum Wiederherstellen der DNS-Ordner in CMD_

_net stop netlogon_

_net start  netlogon_

_die DNS-Ordner werden wiederhergestellt._

(DNS): Vorteile in AD-Integrierte Zonen (4)

1. Alles Zonen sind primär

2. Replikationsgrenze bestimmt der Admin

3. Es können nur sichere Updates aktiviert werden (Sicherheit)

4. AD-Replikation ist verschlüsselt. (Sicherheit)

5. Geringerer Verwaltungsaufwand.

Wo werden AD-Informationen gespeichert?

C:\Windows\SYSVOL\sysvol\[domäne]

Was ist das KDC?

(Key Distribution Center)

besteht aus zwei Diensten

            Authentication Service (AS)

            Ticket Granting Service (TGS)

Wie läuft die Kerberos-Authentifizierung?

1. Client schickt Anmeldeanforderung mit verschlüsseltem Zeitstempel (Pre-Authentication)

   → KDC validiert Zeitstempel und Identität

2. KDC sendet TGT (Ticket Granting Ticket)

   → verschlüsselt mit krbtgt-Schlüssel

   → enthält Session Key für Client

3. Client fragt TGT bei TGS (Ticket Granting Service) an

   → sendet TGT + Anforderung für Service-Ticket

4. TGS validiert TGT

   → prüft Zeitstempel und Signatur

5. TGS sendet Service-Ticket

   → verschlüsselt mit Service-Schlüssel

   → enthält Session Key zwischen Client und Service

6. Client sendet Service-Ticket an Ziel-Service

   → Service validiert Ticket

   → mutual Authentication (beidseitige Authentifizierung)

7. Client und Service tauschen verschlüsselte Daten aus

   → Kommunikation mit Session Key gesichert

### Befehl zum Ändern der Masterrollen

ntdsutil

Darin gibt es einige Möglichkeiten

Objektidentifikation

Leerzeichen ist einfaches Anzeichen
**CN**                              Common Name

**OU**                              Organisational Unit

**DC**                              Domain Component

**DN**                              Distinguished Name

DN :“CN=[Name](RDN),OU=[OU],DC=example,DC=com“

(Eingabesyntax, wird von rechts nach links gelesen)

### PowerShell für das hinzufügen einer OU

New-ADOrganizationalUnit -Name "Sales" -Path "OU=Schulung,DC=example,DC=com"

### PowerShell für Computer Domäne hinzufügen

1. DNS auf DC01 richten

Set-DnsClientServerAdress -InterfaceAlias ethernet -ServerAddresses 192.168.1.200

2. Den Computer hinzufügen

Add-Computer -DomainName example.com -Restart

### Ausführen von Gruppenrichtlinien

gpupdate /force

Was ist UPN?

User Principal Name

PowerShell Format

Verb-Noun -Parameter Wert

z.B. Get-ChildItem, Set-DnsClientServerAddress

PowerShell Help aktualisieren
Get-Help Get-Command

Was sind OUs?

OUs (Organisation Units) sind Container, z.B. Gruppen, die wir in Windows erstellen, damit wir Rechte, Zugehörigkeiten und Zugriffe (GPOs) verwalten können.

Was sind die Vorteile einer OU - Vorteile

**a)        Strukturierung**: Hierachische Organisation von Objekten (User, Computer, Gruppen) im AD

**b)        Verwaltung**: Delegation von Admin-Rechten auf OU-Ebene möglich

**c)        GPOs**: Group Policy Objects selektiv auf OUs anwenden

**d)        Suche**: Schnelle Filterung und Verwaltung von Objektmengen

**e)        Skalierbarkeit**: Benutzerfreundliche Verwaltung großer Netze

PowerShell Anzeigen anpassen

z.B. Get-Service dns | fl name,display*

fl ist Format List, display* = beginnt mit display und Wildcard

Welches Format haben PowerShell-Dateien?

ps.1

### PowerShell auch Unterverzeichnisse einbeziehen.

-Recurse

Was ist TGT?

Ticket Granting Ticket von Kerberos. So funktioniert dann SSO-Berechtigungen

Was ist UNC

Universal Name Convention

Namenskonventionen

Was bedeutet NFTS

New Technology File System

Welche 4 Gruppenbereiche gibt es in AD

- Lokal

- Global

- Lokal (in Domäne)

- Universal

Wie funktioniert das A-G-P Prinzip?

(**A**ccount **G**roup **P**ermission)

1. Globale Gruppe wird erstellt. Berechtigungen die benötigt werden.

2. Jeder bekommt alle Rechte vom Ordner und Globale Gruppe explizit.

Wie funktioniert das A-G-DL-P Prinzip

(**A**ccount **G**roup **D**omain **L**ocal **P**ermission)

oder auch IGDLP Prinzip

**I**dentity **G**lobalgroup **D**omain **L**ocal **P**ermission

Wie schränkt User ein, dass diese keine Computer in Domäne einfügen können?

erweiterte Features > Example.com > Eigenschaften > Attribute Editor > ms-DS-MachineAccountQuota 0 setzen

### PowerShell Computer in Domäne hinzufügen

Add-Computer -DomainName example.com -Restart

Dann Administratordaten eingeben

PowerShell User in Domäne und Ordner hinzufügen

$Password = ConvertTo-SecureString "Pa$$w0rd" -AsPlainText -Force

New-ADUser -Name "thomas klein" -SamAccountName "tklein" -UserPrincipalName "tklein@example.com" -PasswordNeverExpires $true -AccountPassword $Password -Enabled $true -Path "OU=HR,OU=Schulung,DC=example,DC=com"

### Befehl Umleitung von Computern

Umleitung

redircmp „OU=HR,OUR=Schulung,DC=example,DC=com“

Zurück

redircmp "CN=Computers,DC=example,DC=com"

PowerShell Blob für Join erstellen

Anleitung „Konfigurieren Windows Server 2008“ Seite 254

Konfigurationsverwaltung – Erwartungen

- **Zentrale Verwaltung:** Alle Konfigurationen werden zentral verwaltet.
- **Einstellung:** Konfigurationswerte können festgelegt und geändert werden.
- **Gültigkeitsbereich:** Es wird festgelegt, für welche Systeme oder Benutzer die Konfiguration gilt.
- **Anwendung:** Die Einstellungen werden auf die entsprechenden Systeme angewendet.
- **_Versionierung:_** _Änderungen werden gespeichert und ältere Versionen können nachvollzogen bzw. wiederhergestellt werden. (nicht offiziell)_

Wann wird eine Gruppenrichtlinienaktualisierung durchgeführt?

Konfiguration von:

Computer:                 a) Start

                                    b) Alle 90 - 120 Minuten

                                    c) gpupdate

Benutzer:                  a) Anmelden

                                    b) Alle 90 -120 Minuten

                                    c) gpupdate

Wie wirken Gruppenrichtlinien?

1) Kumulativ bis zu der Gruppe des Computer/User

2) Bei Konflikt gilt Rangfolge. Also die direktere gilt (es sei denn eine andere Einstellung)

### PowerShell lokalen User erstellen.

New-LocalUser -Name "Benutzername" -Password (ConvertTo-SecureString "Passwort" -AsPlainText -Force)

Welche beiden Domänen Polcies gibt es?

DDP = Default Domain Policy

a)    Standardrichtlinie für die gesamte Domäne

b)    Wirkt auf alle Benutzer & Computer in der Domäne

c)    Sicherheitsrichtlinien (Passwörter, Konten-Sperrung etc.)

DDCP = Default Domain Controller Policy

a)    Standardrichtlinie speziell für Domain Controller

b)    Wirkt nur auf die DCs

c)    Sicherheit & Verhalten der DCs

### Lokale Gruppenrichtlinie aufrufen Befehl

gpedit.msc

Wiederherstellung der Default GPOs

dcgpofix /:Target:Domain(DC)

### GPs anzeigen lassen

gpresult

GPO Wirkungen anzeigen lassen

Gruppenrichtlinienergebnisse anzeigen lassen.

(Es kann sein, dass die Firewall eingestellt werden muss

Computer -> Firewall erweitert -> eingehende Regeln -> Windows-Verwaltungsinstrumentation (WMI eingehend), 2x vorhanden, aktivieren)

Dann kann ausgewählt werden wofür die Ergebnisse angezeigt werden soll.

PowerShell-Befehl für Remote GPupdate
Invoke-GPUpdate -RandomDelayInMinutes 0 -Computer exa-cl01 -Force

### Aktivieren der Remotedienste auf Clients

Terminal als Administrator

winrm quickconfig

### PowerShell Verbindung zu Computer

Enter-PSSession exa-dc01

### PowerShell Computer ohne Domänenverbindung trauen

Set-Item WSMan:\localhost\Client\TrustedHosts exa-srv02.example.com

### PowerShell Freigabe Firewall

Invoke-Command -ComputerName "192.168.1.203" -Credential $cred -ScriptBlock {

    # 1. COM+ Network Access aktivieren (erforderlich für DCOM/Server-Manager)

    Enable-NetFirewallRule -DisplayGroup "COM+-Netzwerkzugriff"

    # 2. Remote-Ereignisprotokollverwaltung erlauben (behebt den Fehler im Screenshot)

    Enable-NetFirewallRule -DisplayGroup "Remote-Ereignisprotokollverwaltung"

    # 3. Empfohlen für vollständige Server-Manager-Verwaltung (Dienste, Datenträger, etc.)

    Enable-NetFirewallRule -DisplayGroup "Remoteverwaltung für Dienst"

    Enable-NetFirewallRule -DisplayGroup "Remoteverwaltung für geplante Aufgaben"

    Enable-NetFirewallRule -DisplayGroup "Remotebon"

}

### PowerShell eine Session finden und beitreten

New-PSSession -ComputerName [Computer]

dieser beitreten

Enter-PSSession -id [angezeigte ID]

### PowerShell eine PS-Session beenden

Get-PSSession die [Nr] finden

Remove-PSSession [Nr] die Session beenden

### PowerShell die Verbindung testen und reparieren

Test-ComputerSecureChannel -Repair -Credential (Get-Credential)

### PowerShell lokale Sicherheitsrichtlinien öffnen

secpol.msc

### PowerShell Schalter für Ausgabe der PowerShell-Wirkung

-PassThru

### PowerShell eine Gruppe erstellen und einen User hinzufügen

New-ADGroup -Name "[Gruppenname]" -Path "[DN zur Gruppe]" -GroupScope GlobalAdd-ADGroupMember -Identity [Gruppe] -Members [Principal]

Bei Dienstkonten denken

Immer NetBios Name nutzen, wenn der Dienst nach Namen und Passwort gefragt wird

PowerShell KdsRootkey, nicht erst in 10 Stunden

Add-KdsRootKey -EffectiveTime ((get-date).AddHours(-10))

### PowerShell Weiterleitung Passwortabfrage für Dienstkonto

New-ADServiceAccount [Dienstkonto] -PrincipalsAllowedToRetrieveManagedPassword [Zielcomputer EXA-SRV01$,EXA-SRV02$] -PassThru

### PowerShell-Befehl für Installation AD-Powershell

Install-WindowsFeature -Name RSAT-AD-Powershell

### PowerShell-Befehl Account als

setspn -S http:/exa-srv01.example.com:80 example\mysvc1

### PowerShell Interface IP, DNS und Name einstellen

## Neue fixe IP-Adresse

New-NetIPAddress -InterfaceAlias "[Interfacename]" -IPAddress [Fixe IP] -PrefixLength 24

## _Neue fixe DNS-Server_

Set-DnsClientServerAddress -InterfaceAlias

"Ethernet" -ServerAddresses ("[DNS-IP1, DNS-IP2")

### PowerShell AD-Service-Account erstellen

Install-ADServiceAccount [Accountname]myGMSA2

## Erlaubnis für die Server geben

Set-ADServiceAccount -Identity "mygmsa1" -PrincipalsAllowedToRetrieveManagedPassword "EXA-SRV01$","EXA-SRV02$"

## Kontrolle, welche da sind

Get-ADServiceAccount | fl -Property *

PowerShell die AD stoppen

net stop ntds

Befehl die Computerstartoptionen zu ändern

msconfig

### Ntsutil DSRM Passwort modifizieren

In CMD

ntdsutil > activate instance ntds > set dsrm passwort > reset password on server [Server-Name]

### Ntsutil restore durchführen

ntdsutil > activate instance ntds > restroe subtree [Pfad]

### CMD Snapshot mounten und nutzten

ntdsutil > snapshot > Activate Instance NTDS oder AD LDS > create > list all > mount [Nummer]

Dann den Pfad mit ntds in CMD

dsamain -dbpath [Pfad zur \NTDS\ntds.dit -ldapport 5000

In AD den alternativen DC Controller auswählen

EXA-DC01:5000

### PowerShell Vertrauensstellung wiederherstellen

Test-ComputerSecureChannel -Repair -Credential (Get-Credential)

### **PowerShell Neustart unnötig machen**
klist purge -li 0x3e7

### PowerShell RootKey erstellen
Add-KDSRootKey -EffectiveTime ((Get-Date).AddHours(-10))  #Bypass

New-ADServiceAccount -Name [name] -PrincipalsAllowedToRetrieveManagedPassword EXA-SRV01$,EXA-SVR02$

(Dienstkonto erstellen) $= für anmeldename für Computer. Passwort generiert sich automatisch vom System, Server angeben wo der Dienst bzw automatische Passwort generierung ausführen darf. Muss auf DC ausgeführt werden.

Get-WindowsFeature -name *rsat*ad* powershell modul installieren

Install-WindowsFeature -name RSAT-AD-Powershell

Install-ADServiceAccount -Identity  "EXAgMSA"; Test-ADServiceAccount -Identity "EXAgMSA"

setspn -S http/exa-srv01.example.com example\mysvc1 (eindeutiger Erkkenungsname eines Dienstes, das  Kerberos dann nutzt) hat Kontextmenü

PowerShell 
Install-WindowsFeature RSAT-AD-PowerShell -IncludeAllSubFeature; 


