---
tags: [az-802, loesung, az-802/ad-ds]
bereich: 01
---
# Lab 01 AD DS – Lösungen
↑ [[AZ-802 Lab 01 AD DS - Aufgaben]]

> [!warning] Erst nach eigenem Versuch öffnen.

### A1
- Leitfrage: DNS = **EXA-DC01** (sonst kein Auffinden der Domäne). Danach Replikation/dcdiag prüfen.
```powershell
# EXA-DC02
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSDomainController -DomainName example.com -InstallDns -Credential (Get-Credential EXAMPLE\Administrator) -SiteName Default-First-Site-Name
# EXA-DC01 – Validierung
dcdiag /s:EXA-DC02 /q
repadmin /replsummary
```

### A2
- Infrastructure Master auf GC sieht keine veralteten Referenzen (GC hat alle Objekte) → aktualisiert nichts. Egal, wenn alle DCs GC sind.
```powershell
# EXA-DC01
Move-ADDirectoryServerOperationMasterRole -Identity EXA-DC02 -OperationMasterRole RIDMaster,InfrastructureMaster
netdom query fsmo
Move-ADDirectoryServerOperationMasterRole -Identity EXA-DC01 -OperationMasterRole RIDMaster,InfrastructureMaster
```

### A3
- Zwischengespeichert: `Get-ADDomainControllerPasswordReplicationPolicyUsage -Identity EXA-SRV02 -RevealedAccounts`
```powershell
# EXA-DC01
Add-ADDSReadOnlyDomainControllerAccount -DomainControllerAccountName EXA-SRV02 -DomainName example.com -SiteName Default-First-Site-Name -DelegatedAdministratorAccountName rodc-admin
Add-ADDomainControllerPasswordReplicationPolicy -Identity EXA-SRV02 -AllowedList GG_Aussenstelle
# EXA-SRV02
Install-ADDSDomainController -DomainName example.com -UseExistingAccount -InstallDns -Credential (Get-Credential EXAMPLE\Administrator)
```
> Nach dem Lab: EXA-SRV02 herabstufen (`Uninstall-ADDSDomainController`) oder Checkpoint zurück.

### A4
- DNS zuerst: Trust-Assistent muss Gegenseite-DC finden.
- Selektive Auth in contoso: auf **Computerobjekt** des Zielservers in contoso → Recht *Allowed to authenticate* für EXAMPLE-Gruppe.
```powershell
# EXA-DC01
New-ADReplicationSite -Name Aussenstelle
New-ADReplicationSubnet -Name 10.10.20.0/24 -Site Aussenstelle
New-ADReplicationSiteLink -Name HQ-Aussenstelle -SitesIncluded Default-First-Site-Name,Aussenstelle -Cost 200 -ReplicationFrequencyInMinutes 60
Add-DnsServerConditionalForwarderZone -Name contoso.com -MasterServers <IP-CON-DC> -ReplicationScope Forest
# CON-DC
Add-DnsServerConditionalForwarderZone -Name example.com -MasterServers <IP-EXA-DC01> -ReplicationScope Forest
```
Trust: *Active Directory Domains and Trusts* (EXA-DC01) → example.com → Eigenschaften → Vertrauensstellungen → Neu → Gesamtstruktur, Zweiseitig, beide Domänen, Auth-Ebene contoso: selektiv.
```powershell
# EXA-DC01 – Validierung
Get-ADTrust -Filter * | ft Name,Direction,ForestTransitive,SelectiveAuthentication
```

### A5
- Ohne `-EffectiveTime` wartet AD 10 h, damit alle DCs den Key replizieren.
```powershell
# EXA-DC01
New-ADGroup GG_IT -GroupScope Global -Path "OU=Gruppen,DC=example,DC=com"
New-ADGroup DL_Share_IT_RW -GroupScope DomainLocal -Path "OU=Gruppen,DC=example,DC=com"
Add-ADGroupMember DL_Share_IT_RW -Members GG_IT
Add-KdsRootKey -EffectiveTime ((Get-Date).AddHours(-10))   # nur Lab!
New-ADServiceAccount gmsa-web -DNSHostName gmsa-web.example.com -PrincipalsAllowedToRetrieveManagedPassword EXA-SRV01$
# EXA-SRV01
Install-WindowsFeature RSAT-AD-PowerShell
Install-ADServiceAccount gmsa-web
Test-ADServiceAccount gmsa-web
```

### A6
- GPO muss vom Computer gelesen werden können: Bei Entfernen von *Authenticated Users* braucht **Domain Computers** Leserecht (seit MS16-072).
```powershell
# EXA-DC01
New-GPO GPO_Laufwerk_IT | New-GPLink -Target "OU=Clients,DC=example,DC=com"
# Laufwerk per GPMC: Benutzerkonfiguration > Einstellungen > Windows-Einstellungen > Laufwerkzuordnungen
# EXA-CL01
gpupdate /force; gpresult /r /scope user
```
