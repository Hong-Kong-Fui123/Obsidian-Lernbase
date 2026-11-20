---
tags: [az-802, loesung, az-802/sicherheit]
bereich: 06
---
# Lab 06 Sicherheit – Lösungen
↑ [[AZ-802 Lab 06 Sicherheit - Aufgaben]]

### A1
- Niedrigste Precedence gewinnt → **10**. Direkt am Benutzer verknüpfte PSO schlägt Gruppen-PSO.
```powershell
# EXA-DC01
New-ADFineGrainedPasswordPolicy -Name PSO_Admins -Precedence 10 -MinPasswordLength 15 -LockoutThreshold 5 `
  -LockoutDuration 00:30:00 -LockoutObservationWindow 00:30:00 -ComplexityEnabled $true -MaxPasswordAge 90.00:00:00
Add-ADFineGrainedPasswordPolicySubject PSO_Admins -Subjects GG_Admins
```

### A2
```powershell
# EXA-DC01
Update-LapsADSchema
Set-LapsADComputerSelfPermission -Identity "OU=Server,DC=example,DC=com"
Set-LapsADReadPasswordPermission -Identity "OU=Server,DC=example,DC=com" -AllowedPrincipals "EXAMPLE\GG_IT"
# GPO: Computerkonfiguration > Administrative Vorlagen > System > LAPS
#  Kennwortsicherungsverzeichnis = Active Directory, Kennworteinstellungen 14 Tage, Kennwortverschlüsselung aktivieren
# EXA-SRV02
gpupdate /force; Invoke-LapsPolicyProcessing
```

### A3
- IP → kein Kerberos (kein SPN) → NTLM → für Protected Users gesperrt.
```powershell
# EXA-DC01
Add-ADGroupMember "Protected Users" -Members admin.test
Set-ADAccountControl admin.test -AccountNotDelegated $true
```

### A4
- Assistent *Objektverwaltung zuweisen* → Benutzerobjekte → *Kennwort zurücksetzen*, Eigenschaft *lockoutTime* lesen/schreiben.
```powershell
# EXA-DC01 (Alternative)
dsacls "OU=Benutzer,DC=example,DC=com" /I:S /G "EXAMPLE\GG_Helpdesk:CA;Reset Password;user"
dsacls "OU=Benutzer,DC=example,DC=com" /I:S /G "EXAMPLE\GG_Helpdesk:RPWP;lockoutTime;user"
```

### A5
- Audit zeigt Blockierungen im Ereignisprotokoll (*CodeIntegrity/Operational* 3076) ohne Ausfall.
```powershell
# EXA-SRV01
Install-Module Microsoft.OSConfig -Scope AllUsers   # Lab ohne Internet: Modul offline übertragen
Set-OSConfigDesiredConfiguration -Scenario SecurityBaseline/WS2025/MemberServer -Default
# Credential Guard: GPO > System > Device Guard > Virtualisierungsbasierte Sicherheit aktivieren (Credential Guard: mit UEFI-Sperre/ohne)
Copy-Item C:\Windows\schemas\CodeIntegrity\ExamplePolicies\DefaultWindows_Audit.xml C:\WDAC\Policy.xml
ConvertFrom-CIPolicy C:\WDAC\Policy.xml C:\WDAC\SiPolicy.p7b
Get-ProcessMitigation -RegistryConfigFilePath C:\WDAC\ExploitProtection.xml
```
> Hinweis: Credential Guard in VM braucht vTPM + Secure Boot (Gen2) und ggf. Nested-Unterstützung.

### A6
```powershell
# EXA-SRV01
New-NetFirewallRule -DisplayName "RDP nur LAN" -Direction Inbound -Protocol TCP -LocalPort 3389 -RemoteAddress 10.10.10.0/24 -Action Allow
Disable-NetFirewallRule -DisplayGroup "Remote Desktop"
# EXA-SRV01 + EXA-SRV03
New-NetIPsecRule -DisplayName "SRV-Isolation" -RemoteAddress <IP-Gegenseite> -InboundSecurity Request -OutboundSecurity Request
# nach Test: -InboundSecurity Require -OutboundSecurity Require (Set-NetIPsecRule)
Get-NetIPsecMainModeSA
```
