---
typ: wissen
thema: AZ-802
tags: [az-802, hybrid, azure-arc, wac, powershell, exam]
aliases: [AZ-802 Bereich 2, Hybride Verwaltung, Azure Arc Verwaltung]
gewicht: "10–15 %"
erstellt: 2026-10-19
status: lernen
---
# AZ-802 Bereich 2 – Windows Server hybrid verwalten (10–15 %)

Kapitel: [[AZ-802 Übersicht]] · Zurück: [[AZ-802 1 AD DS]] · Weiter: [[AZ-802 3 Virtuelle Maschinen]]
Vorwissen: [[PowerShell Grundlagen]] · [[PS-Remoting]] · [[WinRM]] · [[SSH]] · [[Azure-Grundlagen für Windows-Admins]]

## Prüfungsziele (Checkliste)
- [ ] [[Windows Admin Center]] lokal und im Azure-Portal bereitstellen
- [ ] PowerShell-Remoting inkl. **Doppel-Hop** und [[JEA]] → [[JEA Übersicht]]
- [ ] Remote-[[SSH]] einrichten und verwalten
- [ ] Remotedesktopzugriff verwalten
- [ ] Server mit [[Azure Arc]] anbinden
- [ ] Gerätekonfiguration über Azure Arc (Azure Policy / Computerkonfiguration)
- [ ] Azure-Dienste per **VM-Erweiterungen** auf Nicht-Azure-Servern
- [ ] Updates mit [[Azure Update Manager]]
- [ ] Azure-Automation-[[Runbook|Runbooks]] erstellen und ausführen

## 1. Windows Admin Center (WAC)
| Variante | Wo läuft es | Für |
|---|---|---|
| Gateway auf Server | z. B. EXA-DC01 oder eigener Verwaltungsserver, Zugriff per Browser (HTTPS) | lokale Server, Cluster, Hyper-V |
| Auf Windows 10/11 | lokaler Admin-PC | Einzelplatz |
| **Im Azure-Portal** | Erweiterung auf Azure-VM bzw. Arc-Server | Verwaltung direkt aus dem Portal, Anmeldung per Entra ID + RBAC |

- Nutzt intern PowerShell-Remoting/WMI über [[WinRM]] → Ziele brauchen WinRM.
- Rechte im Portal: Rolle **Windows Admin Center Administrator Login**.
- Erweiterungen (Extensions) für z. B. Active Directory, DNS, DHCP, Storage Migration Service.

## 2. PowerShell-Remoting und Doppel-Hop
**Doppel-Hop-Problem:** Admin-PC → EXA-SRV01 → (Zugriff auf) EXA-DC01-Freigabe scheitert, weil Kerberos-Anmeldedaten nicht weitergereicht werden.

| Lösung | Wie | Bewertung |
|---|---|---|
| Ressourcenbasierte eingeschränkte Delegierung | Am **Ziel** eintragen, wer delegieren darf | ✅ empfohlen, kein Domänen-Admin am Server nötig |
| [[Eingeschränkte Delegierung]] (klassisch) | Am **mittleren** Server eintragen | ✅ geht, Domänen-Admin nötig |
| [[CredSSP]] | Anmeldedaten werden weitergereicht | ⚠ unsicher, mit [[Credential Guard]] blockiert |
| JEA mit RunAs-Konto / gMSA | Endpunkt läuft unter eigenem Konto | ✅ für feste Aufgaben |
| Anmeldedaten im Skript übergeben (`-Credential` im Scriptblock) | `$using:cred` | ⚠ Notlösung |

```powershell
# Maschine: EXA-DC01 – ressourcenbasierte Delegierung: EXA-SRV01 darf zu EXA-SRV02 weiterreichen
Set-ADComputer EXA-SRV02 -PrincipalsAllowedToDelegateToAccount (Get-ADComputer EXA-SRV01)
# Maschine: EXA-SRV01 – Kerberos-Cache leeren, damit es sofort wirkt
klist purge -li 0x3e7
```

## 3. Just Enough Administration (JEA)
> [!tip] Ausführlich im Unterkapitel [[JEA Übersicht]]
> [[JEA Grundlagen und Ablauf|Grundlagen]] · [[JEA Rollenfunktionsdatei|.psrc]] · [[JEA Sitzungskonfiguration|.pssc]] · [[JEA RunAs-Konten|RunAs]] · [[JEA Bereitstellen und Verbinden|Bereitstellen]] · [[JEA Sicherheit und Überwachung|Sicherheit]] · [[JEA Lab DNS-Operator|Lab]]

Admins bekommen **nur die Cmdlets**, die sie brauchen, auf einem eigenen Remoting-Endpunkt – oft unter einem virtuellen Konto mit Admin-Rechten.
| Datei | Inhalt |
|---|---|
| Rollenfunktion `.psrc` | erlaubte Cmdlets/Parameter/Funktionen (liegt in einem Modulordner `RoleCapabilities`) |
| Sitzungskonfiguration `.pssc` | Sitzungstyp `RestrictedRemoteServer`, RunAs (virtuelles Konto/gMSA), Zuordnung **Gruppe → Rolle**, Transkript |
```powershell
# Maschine: EXA-SRV01
$m = 'C:\Program Files\WindowsPowerShell\Modules\JEA-DNS'
New-Item "$m\RoleCapabilities" -ItemType Directory -Force
New-PSRoleCapabilityFile -Path "$m\RoleCapabilities\DnsOperator.psrc" `
  -VisibleCmdlets 'Restart-Service', 'Get-DnsServerZone', 'Clear-DnsServerCache'
New-PSSessionConfigurationFile -Path C:\JEA\DnsOperator.pssc -SessionType RestrictedRemoteServer `
  -RunAsVirtualAccount -TranscriptDirectory C:\JEA\Transkripte `
  -RoleDefinitions @{ 'EXAMPLE\GG_DNS-Operatoren' = @{ RoleCapabilities = 'DnsOperator' } }
Register-PSSessionConfiguration -Name DnsOperator -Path C:\JEA\DnsOperator.pssc -Force
# Maschine: Admin-PC – Test
Enter-PSSession -ComputerName EXA-SRV01 -ConfigurationName DnsOperator
Get-Command      # zeigt nur erlaubte Befehle
```

## 4. SSH und Remotedesktop
- OpenSSH-Server: Port 22. In Server 2025 vorinstalliert, über Server-Manager aktivierbar; ältere Versionen als optionales Feature.
- PowerShell über SSH: `Enter-PSSession -HostName EXA-SRV01 -UserName EXAMPLE\admin` (auch zu Linux).
```powershell
# Maschine: EXA-SRV01 (Server 2022: Feature nachinstallieren)
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Set-Service sshd -StartupType Automatic; Start-Service sshd
Get-NetFirewallRule -Name *OpenSSH* | Select-Object Name, Enabled
```
- RDP: TCP/UDP 3389, **NLA** einschalten, Zugriff über Gruppe *Remotedesktopbenutzer*; aus dem Internet nur über RD-Gateway oder [[Azure Bastion]].

## 5. Azure Arc
Macht lokale (oder andere Cloud-)Server zu **Azure-Ressourcen** – ohne sie umzuziehen.
| Baustein | Bedeutung |
|---|---|
| Connected Machine Agent (`azcmagent`) | Dienst auf dem Server, spricht **ausgehend HTTPS 443** mit Azure (kein eingehender Port) |
| Ressource *Arc-fähiger Server* | erscheint in Ressourcengruppe, hat verwaltete Identität, Tags, RBAC |
| VM-Erweiterungen | z. B. Azure Monitor Agent ([[AMA]]), Defender for Endpoint, Custom Script, WAC |
| Azure Policy / Computerkonfiguration | Einstellungen im Gast prüfen und erzwingen („Gerätekonfiguration“) |
| Dienste | [[Azure Update Manager]], [[Azure Monitor]], [[Defender for Servers]], Change Tracking, [[Hotpatch]], ESU |

**Onboarding:** Portal → Azure Arc → Server hinzufügen → Skript erzeugen (einzeln interaktiv, oder viele Server per Dienstprinzipal / GPO / Configuration Manager).
```powershell
# Maschine: EXA-SRV01 – nach Agent-Installation (Werte aus dem Portal-Skript)
& "$env:ProgramFiles\AzureConnectedMachineAgent\azcmagent.exe" connect `
  --resource-group rg-az802-lab --tenant-id <Mandant-ID> --location germanywestcentral --subscription-id <Abo-ID>
azcmagent show          # Status: Connected
azcmagent check         # Netzwerkprüfung der Endpunkte
```
```powershell
# Maschine: Admin-PC (Az-Modul) – Erweiterung auf Arc-Server ausrollen
New-AzConnectedMachineExtension -ResourceGroupName rg-az802-lab -MachineName EXA-SRV01 -Location germanywestcentral `
  -Name AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ExtensionType AzureMonitorWindowsAgent
```

## 6. Azure Update Manager
- Nachfolger von *Update Management* in Azure Automation (eingestellt 31.08.2024). Braucht **keinen** Log-Analytics-Agent.
- Für Azure-VMs und Arc-Server: **Bewertung** (einmalig oder periodisch alle 24 h), **sofort installieren**, **Wartungskonfiguration** (Zeitplan, Klassifikationen, Neustartverhalten).
- Arc-Server: Nutzung ist kostenpflichtig, außer z. B. bei Windows Server Management über Arc / Defender for Servers Plan 2.
- Server 2025: [[Hotpatch]] über Arc – Updates ohne Neustart (Abo-Funktion).

## 7. Azure Automation – Runbooks
| Baustein | Bedeutung |
|---|---|
| Automation-Konto | Container für Runbooks, Zeitpläne, Variablen, Anmeldeinfos, verwaltete Identität |
| [[Runbook]] | PowerShell- oder Python-Skript, das in Azure läuft |
| Hybrid Runbook Worker | Runbook läuft **auf einem lokalen/Arc-Server** (erweiterungsbasiert) → Zugriff auf lokale Ressourcen |
| Auslöser | Zeitplan, Webhook, Warnung (Aktionsgruppe), manuell |
```powershell
# Runbook-Inhalt (läuft in Azure, verwaltete Identität des Automation-Kontos)
Connect-AzAccount -Identity
Get-AzVM -ResourceGroupName rg-az802-lab -Status | Where-Object PowerState -eq 'VM running' |
  Stop-AzVM -Force       # Lab-VMs abends stoppen
```

## Fallen
- Arc-Server brauchen nur **ausgehend 443** – keine eingehenden Ports, kein VPN.
- WAC im Azure-Portal: Rechte über Azure-RBAC, nicht über lokale Gruppen allein.
- JEA: Rollenfunktionsdateien müssen in einem **Modulordner** unter `RoleCapabilities` liegen, sonst findet sie die Sitzung nicht.
- Doppel-Hop: CredSSP ist die *einfachste*, nicht die *sicherste* Antwort.

## Glossar
[[Windows Admin Center]] · [[JEA]] · [[PS-Remoting]] · [[WinRM]] · [[SSH]] · [[Azure Arc]] · [[Azure Update Manager]] · [[Runbook]] · [[Hotpatch]] · [[AMA]] · [[CredSSP]] · [[Eingeschränkte Delegierung]]
