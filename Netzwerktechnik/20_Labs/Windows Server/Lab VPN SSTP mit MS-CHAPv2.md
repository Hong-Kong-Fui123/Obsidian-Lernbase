---
typ: lab
thema: Windows Server
tags: [lab, vpn, sstp, mschapv2, zertifikate]
quelle: 00_Inbox/Notizen (Unterricht)
status: in-arbeit
---
# Lab VPN SSTP mit MS-CHAPv2

Thema: [[Windows Server]] · Theorie: [[DirectAccess_vs_VPN]] · [[RADIUS und NPS]] · Glossar: [[SSTP]] · [[MS-CHAPv2]] · [[RRAS]]

> [!info] Aufbau
> | Maschine | Rolle |
> |---|---|
> | EXA-SRV01 (`exa-srv01.example.com`) | VPN-Server (RRAS), SSTP über [[TCP]] 443 |
> | EXA-CL01 | VPN-Client |
> SSTP = [[TLS]]-Tunnel → der VPN-Server braucht ein **Serverzertifikat**, dem der Client vertraut.

## 1. Zertifikat ohne CA (selbstsigniert)
**Maschine: EXA-SRV01** (PowerShell als Admin)
```powershell
$certname = "exa-srv01.example.com"
New-SelfSignedCertificate -Subject "CN=$certname" -DnsName "exa-srv01.example.com" `
  -FriendlyName "myVPNServer" -CertStoreLocation "Cert:\CurrentUser\My" `
  -KeyExportPolicy Exportable -KeySpec Signature -KeyLength 2048 `
  -KeyAlgorithm RSA -HashAlgorithm SHA256
```

> [!warning] Prüfen
> RRAS sucht das SSTP-Zertifikat im **Computerspeicher**. Mit `Cert:\CurrentUser\My` taucht es in der RRAS-Konsole nicht auf → `-CertStoreLocation "Cert:\LocalMachine\My"` verwenden.
> Frage an dich: Warum reicht der Benutzerspeicher für einen **Dienst** nicht?

## 2. Zertifikat zum Client bringen
**Maschine: EXA-SRV01** – öffentlichen Teil exportieren (Freigabe `\\exa-srv01\certs`):
```powershell
$c = Get-ChildItem Cert:\LocalMachine\My | Where-Object Subject -eq "CN=exa-srv01.example.com"
Export-Certificate -Cert $c -FilePath "C:\certs\exa-srv01-vpn.cer"
```

**Maschine: EXA-CL01** – Version von Tillmann (laden + testen):
```powershell
$cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new("\\exa-srv01\certs\exa-srv01-vpn.cer")
Test-Certificate -Cert $cert
```
Selbstsigniert → Client muss es als **Stammzertifikat** vertrauen:
```powershell
Import-Certificate -FilePath "\\exa-srv01\certs\exa-srv01-vpn.cer" -CertStoreLocation Cert:\LocalMachine\Root
```

## 3. Sperrlistenprüfung abschalten (nur Lab!)
Selbstsigniertes Zertifikat hat keine [[CRL]] → Verbindung scheitert mit Fehler „Sperrfunktion konnte nicht prüfen“ (0x80092013).

**Maschine: EXA-CL01** – Regedit: `Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SstpSvc\Parameters` → neuer **DWORD-Wert (32-Bit)** `NoCertRevocationCheck` = `1`

PowerShell-Variante:
```powershell
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SstpSvc\Parameters" `
  -Name NoCertRevocationCheck -PropertyType DWord -Value 1 -Force
```
> [!tip] Produktiv
> Statt Abschalten: Zertifikat von der eigenen [[CA]] mit erreichbarem [[CDP]] → siehe [[Aufgabe_02_CA-Serverrolle]].

## 4. VPN-Verbindung
**Maschine: EXA-CL01**
```powershell
Add-VpnConnection -Name "EXA-VPN" -ServerAddress "exa-srv01.example.com" `
  -TunnelType Sstp -AuthenticationMethod MSChapv2 -RememberCredential
rasdial "EXA-VPN"
Get-VpnConnection -Name "EXA-VPN"
```

## 5. Prüffragen
1. Welcher Port muss an der Firewall für SSTP offen sein?
2. Warum gilt MS-CHAPv2 allein als schwach – und was schützt es hier?
3. Was ändert sich, wenn das Serverzertifikat von EXA-CA01 statt selbstsigniert kommt?

## 📄 Unterlagen
- Buch 70-741: [[70-741_Server2016_Netzwerk.pdf#page=196|VPN-Protokolle und Authentifizierung]] · [[70-741_Server2016_Netzwerk.pdf#page=199|Remotezugriff-VPN einrichten]]
- Buch 70-642: [[70-642_Server2008R2_Netzwerk.pdf#page=422|Verbinden mit Remotenetzwerken]]
- Prüfungsfragen: [[VPN-RADIUS_15_Pruefungsfragen.pdf#page=1|F1–5 VPN-Protokolle]] · [[VPN-RADIUS_15_Pruefungsfragen_Loesung.pdf#page=7|Lösungen]]
- PKI-Grundlagen: [[AD-Zertifikatdienste.pdf#page=13|PKI, CRL]] · [[AD-Zertifikatdienste.pdf#page=14|Inhalt eines Zertifikats]]
