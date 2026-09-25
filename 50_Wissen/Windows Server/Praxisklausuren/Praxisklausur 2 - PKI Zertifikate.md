---
title: "Praxisklausur 2: Zweistufige PKI mit AD CS"
tags:
  - klausur
  - homelab
  - windows-server
thema: Windows Server 2022
typ: Praxisklausur
bearbeitungszeit: 210 min Praxis + 20 min Theorie
punkte: 100
status: offen
ergebnis:
datum:
---
# Praxisklausur 2: Zweistufige PKI mit AD CS

Zurück zur Übersicht: [[00 Uebersicht Praxisklausuren|Übersicht Praxisklausuren]] | Lab-Plan und Hinweise dort

> [!info] Rahmen
> - **Bearbeitungszeit:** 210 min Praxis + 20 min Theorie
> - **Punkte:** Teil A Praxis 70, Teil B Theorie 30, gesamt 100
> - **Benötigte VMs:** EXA-DC01, EXA-DC02, EXA-ROOTCA (VM EXA-TEST01), EXA-CA01, EXA-WEB01, EXA-CL01
> - **Ausgangslage:** Endzustand von Praxisklausur 1. EXA-CA01 und EXA-WEB01 sind installiert, benannt, mit IP laut Lab-Plan versehen und Domänenmitglied. EXA-ROOTCA ist installiert, benannt und hat eine IP, ist aber **kein** Domänenmitglied. Dateien zwischen EXA-ROOTCA und dem Rest werden über einen Ordner C:\Transfer ausgetauscht (z. B. per Hyper-V-Zwischenablage im erweiterten Sitzungsmodus oder per ISO/VHDX).
> - Jede Anforderung mit Kästchen abhaken, sobald erledigt und geprüft.
> - Lösungen sind eingeklappt. Erst nach der Bearbeitung öffnen (Lesemodus: Strg+E).

## Teil A: Praxis im Homelab (70 Punkte)

### Aufgabe 1: Offline-Stamm-CA (10 Punkte)

- [ ] Auf EXA-ROOTCA ist eine eigenständige Stamm-CA **EXA-Root-CA** installiert (RSA 4096, SHA256, 10 Jahre)
- [ ] Von ihr ausgestellte Zertifikate sind 5 Jahre gültig
- [ ] CRL-Gültigkeit 26 Wochen, keine Delta-CRL
- [ ] CDP und AIA zeigen auf `http://pki.exa.local/CertEnroll/`
- [ ] Die CA kennt die Konfigurationspartition von exa.local

**Nachweis:** `certutil -getreg CA\CRLPublicationURLs`, `certutil -getreg CA\CACertPublicationURLs`

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 1
> **Auf EXA-ROOTCA** (PowerShell als Administrator):
>
> ```powershell
> Install-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools
> Install-AdcsCertificationAuthority -CAType StandaloneRootCA -CACommonName "EXA-Root-CA" `
>   -KeyLength 4096 -HashAlgorithmName SHA256 -ValidityPeriod Years -ValidityPeriodUnits 10 -Force
>
> certutil -setreg CA\DSConfigDN "CN=Configuration,DC=exa,DC=local"
> certutil -setreg CA\ValidityPeriodUnits 5
> certutil -setreg CA\ValidityPeriod "Years"
> certutil -setreg CA\CRLPeriodUnits 26
> certutil -setreg CA\CRLPeriod "Weeks"
> certutil -setreg CA\CRLDeltaPeriodUnits 0
> certutil -setreg CA\CRLPublicationURLs "1:C:\Windows\system32\CertSrv\CertEnroll\%3%8%9.crl\n2:http://pki.exa.local/CertEnroll/%3%8%9.crl"
> certutil -setreg CA\CACertPublicationURLs "1:C:\Windows\system32\CertSrv\CertEnroll\%1_%3%4.crt\n2:http://pki.exa.local/CertEnroll/%1_%3%4.crt"
> Restart-Service certsvc
> certutil -crl
> Copy-Item C:\Windows\System32\CertSrv\CertEnroll\* C:\Transfer\
> ```
>
> Das `\n` bleibt in PowerShell wörtlich stehen und wird von certutil als Trenner gelesen. Die Zahlen vor dem Doppelpunkt sind Flags: 1 = Datei hier veröffentlichen, 2 = in die CDP- bzw. AIA-Erweiterung der Zertifikate schreiben.

---

### Aufgabe 2: Veröffentlichungspunkt auf EXA-WEB01 (8 Punkte)

- [ ] IIS ist auf EXA-WEB01 installiert
- [ ] Virtuelles Verzeichnis `CertEnroll` zeigt auf `C:\PKI\CertEnroll`, Double Escaping ist erlaubt (wegen `+` in Delta-CRLs)
- [ ] Freigabe `CertEnroll`, auf die das Computerkonto EXA-CA01$ schreiben darf
- [ ] DNS: `pki.exa.local` zeigt auf EXA-WEB01
- [ ] Root-Zertifikat und Root-CRL liegen in `C:\PKI\CertEnroll`

**Nachweis:** Von EXA-CL01 ist `http://pki.exa.local/CertEnroll/EXA-Root-CA.crl` abrufbar

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 2
> **Auf EXA-WEB01** (PowerShell als Administrator):
>
> ```powershell
> Install-WindowsFeature Web-Server -IncludeManagementTools
> New-Item C:\PKI\CertEnroll -ItemType Directory
> Import-Module WebAdministration
> New-WebVirtualDirectory -Site "Default Web Site" -Name CertEnroll -PhysicalPath C:\PKI\CertEnroll
> Set-WebConfigurationProperty -PSPath "IIS:\Sites\Default Web Site\CertEnroll" `
>   -Filter /system.webServer/security/requestFiltering -Name allowDoubleEscaping -Value $true
> New-SmbShare -Name CertEnroll -Path C:\PKI\CertEnroll -ChangeAccess "EXA\EXA-CA01$"
> icacls C:\PKI\CertEnroll /grant "EXA\EXA-CA01$:(OI)(CI)M"
> # Dateien aus C:\Transfer (von EXA-ROOTCA) nach C:\PKI\CertEnroll kopieren
> ```
>
> **Auf EXA-DC01** (PowerShell als Administrator):
>
> ```powershell
> Add-DnsServerResourceRecordCName -ZoneName exa.local -Name pki -HostNameAlias EXA-WEB01.exa.local
> ```
>
> **Test auf EXA-CL01:**
>
> ```powershell
> Invoke-WebRequest http://pki.exa.local/CertEnroll/EXA-Root-CA.crl -UseBasicParsing | Select-Object StatusCode
> ```

---

### Aufgabe 3: Root-Zertifikat verteilen (8 Punkte)

Alle Domänencomputer sollen der EXA-Root-CA vertrauen, ohne dass Sie jeden Rechner einzeln anfassen.

- [ ] Root-Zertifikat ist in AD veröffentlicht
- [ ] Auf EXA-CL01 und EXA-CA01 steht EXA-Root-CA unter "Vertrauenswürdige Stammzertifizierungsstellen"

**Nachweis:** `Get-ChildItem Cert:\LocalMachine\Root | Where-Object Subject -like "*EXA-Root-CA*"`

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 3
> **Auf EXA-DC01** (PowerShell als Organisations-Admin, Dateien aus C:\Transfer):
>
> ```powershell
> certutil -dspublish -f "C:\Transfer\EXA-ROOTCA_EXA-Root-CA.crt" RootCA
> certutil -dspublish -f "C:\Transfer\EXA-Root-CA.crl"
> ```
>
> **Auf EXA-CL01 und EXA-CA01** (PowerShell als Administrator):
>
> ```powershell
> gpupdate /force
> certutil -pulse
> Get-ChildItem Cert:\LocalMachine\Root | Where-Object Subject -like "*EXA-Root-CA*"
> ```
>
> Alternative: GPO mit dem Zertifikat unter Computerkonfiguration > Richtlinien > Windows-Einstellungen > Sicherheitseinstellungen > Richtlinien für öffentliche Schlüssel > Vertrauenswürdige Stammzertifizierungsstellen.

---

### Aufgabe 4: Untergeordnete Enterprise-CA (12 Punkte)

- [ ] Auf EXA-CA01 ist die untergeordnete Enterprise-CA **EXA-Issuing-CA** installiert (RSA 2048, SHA256)
- [ ] Ihr Zertifikat ist von EXA-Root-CA signiert
- [ ] CDP: lokal, `http://pki.exa.local/CertEnroll/` (in den Zertifikaten) und per Datei auf `\\EXA-WEB01.exa.local\CertEnroll` (Veröffentlichung, auch Delta-CRL)
- [ ] AIA: lokal und `http://pki.exa.local/CertEnroll/`
- [ ] `pkiview.msc` zeigt für beide CAs keine Fehler

**Nachweis:** Screenshot pkiview.msc, `certutil -verify -urlfetch` auf das Zertifikat der Issuing-CA

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 4
> **Auf EXA-CA01** (PowerShell als Organisations-Admin):
>
> ```powershell
> Install-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools
> Install-AdcsCertificationAuthority -CAType EnterpriseSubordinateCA -CACommonName "EXA-Issuing-CA" `
>   -KeyLength 2048 -HashAlgorithmName SHA256 -OutputCertRequestFile C:\Transfer\EXA-Issuing-CA.req -Force
> ```
>
> **Auf EXA-ROOTCA** (Anforderung aus C:\Transfer):
>
> ```powershell
> certreq -submit -config "EXA-ROOTCA\EXA-Root-CA" C:\Transfer\EXA-Issuing-CA.req
> # Die angezeigte RequestId merken, z. B. 2
> certutil -resubmit 2
> certreq -retrieve -config "EXA-ROOTCA\EXA-Root-CA" 2 C:\Transfer\EXA-Issuing-CA.crt
> ```
>
> **Auf EXA-CA01** (Zertifikat aus C:\Transfer):
>
> ```powershell
> certutil -installcert C:\Transfer\EXA-Issuing-CA.crt
> Start-Service certsvc
>
> certutil -setreg CA\CRLPublicationURLs "65:C:\Windows\system32\CertSrv\CertEnroll\%3%8%9.crl\n6:http://pki.exa.local/CertEnroll/%3%8%9.crl\n65:file://\\EXA-WEB01.exa.local\CertEnroll\%3%8%9.crl"
> certutil -setreg CA\CACertPublicationURLs "1:C:\Windows\system32\CertSrv\CertEnroll\%1_%3%4.crt\n2:http://pki.exa.local/CertEnroll/%1_%3%4.crt"
> Restart-Service certsvc
> certutil -crl
> Copy-Item C:\Windows\System32\CertSrv\CertEnroll\*.crt \\EXA-WEB01.exa.local\CertEnroll\
> ```
>
> Flags: 1 = veröffentlichen, 2 = in CDP der Zertifikate, 4 = in Delta-CRL-Verweis, 64 = Delta-CRL veröffentlichen. 65 = 1 + 64, 6 = 2 + 4.
>
> Wenn `-installcert` mit "Sperrfunktion offline" abbricht: Root-CRL ist per HTTP nicht erreichbar (Aufgabe 2 prüfen).

---

### Aufgabe 5: Webserver-Zertifikat mit SAN (10 Punkte)

- [ ] Vorlage **EXA-Webserver** (Duplikat von "Webserver"), 2 Jahre gültig, Antragstellername wird in der Anforderung angegeben
- [ ] Nur die Gruppe `GG_Webserver` (Mitglied: EXA-WEB01$) darf registrieren
- [ ] Vorlage ist auf EXA-Issuing-CA veröffentlicht
- [ ] EXA-WEB01 hat ein Zertifikat mit `CN=intranet.exa.local` und den SANs `intranet.exa.local` und `EXA-WEB01.exa.local`
- [ ] HTTPS-Bindung auf Port 443 in IIS, DNS: `intranet.exa.local` zeigt auf EXA-WEB01

**Nachweis:** `https://intranet.exa.local` öffnet auf EXA-CL01 ohne Zertifikatswarnung

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 5
> **Vorlage auf EXA-CA01** (GUI `certtmpl.msc`):
>
> 1. "Webserver" > Vorlage duplizieren
> 2. Allgemein: Name `EXA-Webserver`, Gültigkeit 2 Jahre
> 3. Antragstellername: "Informationen werden in der Anforderung angegeben"
> 4. Sicherheit: `GG_Webserver` Lesen + Registrieren, "Authentifizierte Benutzer" nur Lesen
>
> **Gruppe auf EXA-DC01** (PowerShell):
>
> ```powershell
> New-ADGroup -Name GG_Webserver -GroupScope Global -Path "OU=Gruppen,OU=EXA,DC=exa,DC=local"
> Add-ADGroupMember GG_Webserver -Members (Get-ADComputer EXA-WEB01)
> Add-DnsServerResourceRecordCName -ZoneName exa.local -Name intranet -HostNameAlias EXA-WEB01.exa.local
> ```
>
> **Veröffentlichen auf EXA-CA01** (PowerShell):
>
> ```powershell
> Add-CATemplate -Name "EXA-Webserver" -Force
> ```
>
> **Auf EXA-WEB01** (PowerShell als Administrator). Zuerst neu starten, damit das Computerkonto die neue Gruppe im Ticket hat. Dann Datei `C:\Lab\web.inf`:
>
> ```text
> [NewRequest]
> Subject = "CN=intranet.exa.local"
> KeyLength = 2048
> MachineKeySet = TRUE
> Exportable = FALSE
> [Extensions]
> 2.5.29.17 = "{text}"
> _continue_ = "dns=intranet.exa.local&"
> _continue_ = "dns=EXA-WEB01.exa.local"
> [RequestAttributes]
> CertificateTemplate = EXA-Webserver
> ```
>
> ```powershell
> certreq -new C:\Lab\web.inf C:\Lab\web.req
> certreq -submit -config "EXA-CA01.exa.local\EXA-Issuing-CA" C:\Lab\web.req C:\Lab\web.cer
> certreq -accept C:\Lab\web.cer
>
> Import-Module WebAdministration
> New-WebBinding -Name "Default Web Site" -Protocol https -Port 443
> $cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object Subject -eq "CN=intranet.exa.local"
> (Get-WebBinding -Name "Default Web Site" -Protocol https).AddSslCertificate($cert.Thumbprint, "My")
> ```
>
> **Test auf EXA-CL01:**
>
> ```powershell
> Invoke-WebRequest https://intranet.exa.local -UseBasicParsing | Select-Object StatusCode
> ```

---

### Aufgabe 6: Automatische Registrierung für Computer (10 Punkte)

- [ ] Vorlage **EXA-Computer** (Duplikat von "Arbeitsstationsauthentifizierung")
- [ ] "Domänencomputer" dürfen Lesen, Registrieren und Automatisch registrieren
- [ ] Vorlage ist auf der CA veröffentlicht
- [ ] GPO **PKI-Autoenrollment** mit der Domäne verknüpft: Zertifikatdienstclient - Automatische Registrierung aktiviert, Erneuern und Aktualisieren angehakt

**Nachweis:** EXA-CL01 hat ohne manuelle Anforderung ein Zertifikat aus EXA-Computer im Computerspeicher

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 6
> **Vorlage auf EXA-CA01** (GUI `certtmpl.msc`): "Arbeitsstationsauthentifizierung" duplizieren, Name `EXA-Computer`, Sicherheit: Domänencomputer Lesen, Registrieren, Automatisch registrieren.
>
> ```powershell
> Add-CATemplate -Name "EXA-Computer" -Force
> ```
>
> **GPO auf EXA-DC01** (PowerShell):
>
> ```powershell
> New-GPO -Name "PKI-Autoenrollment" | New-GPLink -Target "DC=exa,DC=local"
> Set-GPRegistryValue -Name "PKI-Autoenrollment" `
>   -Key "HKLM\SOFTWARE\Policies\Microsoft\Cryptography\AutoEnrollment" `
>   -ValueName AEPolicy -Type DWord -Value 7
> ```
>
> AEPolicy 7 = aktiviert + Erneuern/Aktualisieren abgelaufener Zertifikate + Vorlagen aktualisieren. In der GUI: Computerkonfiguration > Richtlinien > Windows-Einstellungen > Sicherheitseinstellungen > Richtlinien für öffentliche Schlüssel > Zertifikatdienstclient - Automatische Registrierung.
>
> **Test auf EXA-CL01:**
>
> ```powershell
> gpupdate /force
> certutil -pulse
> Get-ChildItem Cert:\LocalMachine\My | Select-Object Subject, Issuer, NotAfter
> ```

---

### Aufgabe 7: Zertifikat sperren (6 Punkte)

Ticket: *"Das Notebook EXA-CL01 wurde gestohlen."*

- [ ] Das Computerzertifikat von EXA-CL01 ist mit dem Grund "Schlüsselkompromittierung" gesperrt
- [ ] Eine neue CRL ist veröffentlicht und liegt auf EXA-WEB01

**Nachweis:** Zertifikat unter "Gesperrte Zertifikate" in `certsrv.msc`, Änderungsdatum der CRL in `\\EXA-WEB01\CertEnroll`

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 7
> **Auf EXA-CA01** (PowerShell als Administrator):
>
> ```powershell
> certutil -view -restrict "RequesterName=EXA\EXA-CL01$" -out "RequestId,SerialNumber,CommonName,NotAfter"
> certutil -revoke <SerialNumber> 1
> certutil -crl
> ```
>
> Grund 1 = Schlüsselkompromittierung. In der Praxis zusätzlich: Computerkonto deaktivieren, Kennwörter des Benutzers zurücksetzen.

---

### Aufgabe 8: CA sichern (6 Punkte)

- [ ] Vollständige Sicherung von EXA-Issuing-CA nach `C:\CABackup` (privater Schlüssel, Zertifikat, Datenbank, Konfiguration)
- [ ] Die Sicherung ist mit Kennwort geschützt
- [ ] Erinnerung dokumentiert, wann die Offline-Root-CA spätestens eine neue CRL ausstellen muss

**Nachweis:** Inhalt von `C:\CABackup`

**Meine Lösung:**

- 

> [!success]- Lösung Aufgabe 8
> **Auf EXA-CA01** (PowerShell als Administrator):
>
> ```powershell
> Backup-CARoleService -Path C:\CABackup -Password (Read-Host -AsSecureString "Kennwort")
> reg export "HKLM\SYSTEM\CurrentControlSet\Services\CertSvc\Configuration" C:\CABackup\CAConfig.reg
> ```
>
> Alternativ: `certutil -backup C:\CABackup`. Die Root-CRL ist 26 Wochen gültig: spätestens nach ca. 24 Wochen EXA-ROOTCA einschalten, `certutil -crl` ausführen, die neue CRL nach `\\EXA-WEB01\CertEnroll` kopieren, VM wieder ausschalten.

---

## Teil B: Theorie (30 Punkte)

Je Frage 3 Punkte. Genau eine Antwort ist richtig, bei Eingabefragen die Antwort eintragen.

**Frage 1** (AD FS & Webanwendungsproxy)

Welche Konfigurationsdatenbank verwendet AD FS standardmäßig?

- [ ] A) Die AD-Datenbank NTDS.dit
- [ ] B) Die Registry
- [ ] C) Die Windows Internal Database (WID); für große Farmen optional SQL Server
- [ ] D) Eine Textdatei im SYSVOL

> [!success]- Lösung Frage 1
> **C)** Die Windows Internal Database (WID); für große Farmen optional SQL Server
>
> Standard ist die WID, die zwischen den Farmknoten repliziert wird; SQL Server ist für große Umgebungen möglich.

**Frage 2** (AD CS - Zertifikatdienste)

Wie aktivieren Sie die automatische Zertifikatregistrierung (Autoenrollment) für Domänenmitglieder?

- [ ] A) Über die Registry der CA
- [ ] B) Über eine Gruppenrichtlinie "Zertifikatdienstclient - Automatische Registrierung" sowie passende Rechte auf der Vorlage
- [ ] C) Über einen DNS-Eintrag
- [ ] D) Über DHCP-Optionen

> [!success]- Lösung Frage 2
> **B)** Über eine Gruppenrichtlinie "Zertifikatdienstclient - Automatische Registrierung" sowie passende Rechte auf der Vorlage
>
> Autoenrollment wird per GPO aktiviert; die Vorlage muss zudem Registrierungsrechte bieten.

**Frage 3** (AD CS - Zertifikatdienste)

Alle Domänencomputer sollen automatisch ein Computerzertifikat (z. B. für WLAN- oder VPN-Authentifizierung) erhalten, ohne dass Administratoren eingreifen müssen.

**Frage:** Welche Schritte sind erforderlich?

- [ ] A) Manuelle Ausstellung über certsrv für jeden Computer
- [ ] B) Ein Skript im NETLOGON-Ordner
- [ ] C) Vorlage duplizieren, Gruppe "Domänencomputer" Lesen, Registrieren und Autoregistrierung erlauben, Vorlage auf der CA veröffentlichen und Autoenrollment per GPO aktivieren
- [ ] D) Ein DHCP-Bereich mit Zertifikatsoption

> [!success]- Lösung Frage 3
> **C)** Vorlage duplizieren, Gruppe "Domänencomputer" Lesen, Registrieren und Autoregistrierung erlauben, Vorlage auf der CA veröffentlichen und Autoenrollment per GPO aktivieren
>
> Autoenrollment benötigt Vorlage mit passenden Rechten, Veröffentlichung auf der CA und die GPO-Einstellung.

**Frage 4** (AD FS & Webanwendungsproxy)

Worin unterscheidet sich die AD FS-Vorauthentifizierung von der Pass-Through-Vorauthentifizierung im WAP?

- [ ] A) Bei der AD FS-Vorauthentifizierung wird der Benutzer bereits am WAP über AD FS authentifiziert, bevor Datenverkehr an die Anwendung weitergeleitet wird; bei Pass-Through übernimmt die Anwendung die Authentifizierung
- [ ] B) Es gibt keinen Unterschied
- [ ] C) Pass-Through ist sicherer als AD FS-Vorauthentifizierung
- [ ] D) Die AD FS-Vorauthentifizierung funktioniert nur intern

> [!success]- Lösung Frage 4
> **A)** Bei der AD FS-Vorauthentifizierung wird der Benutzer bereits am WAP über AD FS authentifiziert, bevor Datenverkehr an die Anwendung weitergeleitet wird; bei Pass-Through übernimmt die Anwendung die Authentifizierung
>
> Mit Vorauthentifizierung gelangt nur authentifizierter Datenverkehr in das interne Netz.

**Frage 5** (AD CS - Zertifikatdienste)

Clients melden beim Aufbau von HTTPS-Verbindungen: "Der Sperrstatus des Zertifikats konnte nicht überprüft werden." Die untergeordnete CA läuft; die Offline-Root-CA wurde zuletzt vor sieben Monaten eingeschaltet.

**Frage:** Was ist die wahrscheinlichste Ursache?

- [ ] A) Die Vorlage ist veraltet
- [ ] B) Der DHCP-Server ist ausgefallen
- [ ] C) Die CRL der Offline-Root-CA ist abgelaufen; sie muss neu veröffentlicht und im CDP-Ort bereitgestellt werden
- [ ] D) Das Webserver-Zertifikat wurde nicht signiert

> [!success]- Lösung Frage 5
> **C)** Die CRL der Offline-Root-CA ist abgelaufen; sie muss neu veröffentlicht und im CDP-Ort bereitgestellt werden
>
> Offline-CAs haben lange CRL-Laufzeiten; abgelaufene CRLs verhindern die Sperrprüfung.

**Frage 6** (AD FS & Webanwendungsproxy)

Was sind Ansprüche (Claims) in AD FS?

- [ ] A) IP-Adressen der Clients
- [ ] B) Berechtigungen auf Dateiservern
- [ ] C) Kennwörter der Benutzer
- [ ] D) Aussagen über einen Benutzer (z. B. Name, E-Mail, Gruppenmitgliedschaft), die im Sicherheitstoken enthalten sind und von Anwendungen ausgewertet werden

> [!success]- Lösung Frage 6
> **D)** Aussagen über einen Benutzer (z. B. Name, E-Mail, Gruppenmitgliedschaft), die im Sicherheitstoken enthalten sind und von Anwendungen ausgewertet werden
>
> Claims sind Attribute, die der Anspruchsanbieter in das Token schreibt.

**Frage 7** (AD FS & Webanwendungsproxy)

Welche Voraussetzung muss vor dem Einrichten einer AD FS-Farm erfüllt sein?

- [ ] A) Ein Exchange-Server
- [ ] B) Ein Domänencontroller mit Windows Server 2003
- [ ] C) Ein TLS/SSL-Zertifikat mit dem Namen des Verbunddienstes (z. B. sts.contoso.com) und ein passender DNS-Eintrag
- [ ] D) Ein DHCP-Bereich für den Verbunddienst

> [!success]- Lösung Frage 7
> **C)** Ein TLS/SSL-Zertifikat mit dem Namen des Verbunddienstes (z. B. sts.contoso.com) und ein passender DNS-Eintrag
>
> Für den Verbunddienstnamen werden ein vertrauenswürdiges Zertifikat und DNS benötigt; empfohlen ist zudem ein gruppenverwaltetes Dienstkonto (gMSA).

**Frage 8** (AD CS - Zertifikatdienste)

Wie gehen Sie vor, wenn Sie eine Standardzertifikatvorlage anpassen möchten?

- [ ] A) Die Standardvorlage direkt bearbeiten
- [ ] B) Die Vorlage löschen und neu erstellen
- [ ] C) Die CA neu installieren
- [ ] D) Die Vorlage duplizieren und die Kopie anpassen

> [!success]- Lösung Frage 8
> **D)** Die Vorlage duplizieren und die Kopie anpassen
>
> Standardvorlagen sollten nicht verändert werden; man arbeitet mit Duplikaten.

**Frage 9** (AD CS - Zertifikatdienste)

Was ist eine PKI (Public Key Infrastructure)?

- [ ] A) Eine Infrastruktur zur Ausstellung, Verwaltung, Verteilung und Sperrung digitaler Zertifikate
- [ ] B) Ein Protokoll zur Vergabe von IP-Adressen
- [ ] C) Ein Verzeichnis für Benutzerkonten
- [ ] D) Ein Verfahren zur Datensicherung

> [!success]- Lösung Frage 9
> **A)** Eine Infrastruktur zur Ausstellung, Verwaltung, Verteilung und Sperrung digitaler Zertifikate
>
> Eine PKI besteht aus Zertifizierungsstellen, Richtlinien und Diensten zur Verwaltung von Zertifikaten.

**Frage 10** (AD FS & Webanwendungsproxy)

Wofür werden die Active Directory-Verbunddienste (AD FS) hauptsächlich eingesetzt?

- [ ] A) Für Single Sign-On und Identitätsföderation über Organisations- und Netzwerkgrenzen hinweg (anspruchsbasierte Authentifizierung)
- [ ] B) Für die Vergabe von IP-Adressen
- [ ] C) Für die Verwaltung von Druckern
- [ ] D) Für die Sicherung von Domänencontrollern

> [!success]- Lösung Frage 10
> **A)** Für Single Sign-On und Identitätsföderation über Organisations- und Netzwerkgrenzen hinweg (anspruchsbasierte Authentifizierung)
>
> AD FS stellt Sicherheitstoken mit Ansprüchen aus und ermöglicht Single Sign-On zu internen und externen Anwendungen.

---

## Bewertung

| Teil | Max. | Erreicht |
|---|---|---|
| A1 Offline-Stamm-CA | 10 | |
| A2 Veröffentlichungspunkt auf EXA-WEB01 | 8 | |
| A3 Root-Zertifikat verteilen | 8 | |
| A4 Untergeordnete Enterprise-CA | 12 | |
| A5 Webserver-Zertifikat mit SAN | 10 | |
| A6 Automatische Registrierung für Computer | 10 | |
| A7 Zertifikat sperren | 6 | |
| A8 CA sichern | 6 | |
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
