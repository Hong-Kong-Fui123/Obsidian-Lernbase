---
typ: wissen
thema: AZ-802
tags: [az-802, azure, grundlagen, hybrid]
aliases: [Azure Grundlagen, Azure für Windows-Admins, Azure-Hierarchie]
erstellt: 2026-10-19
status: lernen
---
# Azure-Grundlagen für Windows-Admins

Kapitel: [[AZ-802 Übersicht]] · Glossar: [[Entra ID]] · [[VNet]] · [[NSG]] · [[Azure Arc]]

> [!summary] Kernidee
> - Azure = Rechenzentren von Microsoft, die du per Portal, PowerShell oder CLI **mietest**.
> - Alles in Azure ist eine **Ressource** in einer **Ressourcengruppe** in einem **Abonnement**.
> - Identität kommt aus [[Entra ID]], Rechte über **RBAC**, Kosten pro Minute/GB.

## 1. Hierarchie
| Ebene | Bedeutung | Vergleich lokal |
|---|---|---|
| Entra-Mandant (Tenant) | Identitätsverzeichnis einer Organisation | Gesamtstruktur (Forest) |
| Verwaltungsgruppe | fasst Abonnements zusammen (Richtlinien vererben) | – |
| Abonnement (Subscription) | Abrechnungs- und Berechtigungsgrenze | Kostenstelle |
| Ressourcengruppe | Container für zusammengehörige Ressourcen, gemeinsam löschbar | [[OU]] |
| Ressource | VM, Speicherkonto, VNet, Arc-Server … | Computerobjekt |

**Region** = Standort (z. B. *Germany West Central* Frankfurt, *West Europe* Niederlande). **Verfügbarkeitszonen** = getrennte Rechenzentren innerhalb einer Region → [[Verfügbarkeitszone]].

## 2. Rechte: RBAC
| Rolle | Darf |
|---|---|
| Besitzer (Owner) | alles + Rechte vergeben |
| Mitwirkender (Contributor) | alles außer Rechte vergeben |
| Leser (Reader) | nur ansehen |
| Spezialrollen | z. B. *Virtual Machine Contributor*, *Storage File Data SMB Share Contributor* |

Zuweisung: **Wer** (Benutzer/Gruppe/verwaltete Identität) + **Rolle** + **Bereich** (Abonnement/Ressourcengruppe/Ressource). Vererbung nach unten.
**Verwaltete Identität** = Konto für eine Ressource (z. B. Arc-Server, Automation-Konto), ohne Kennwort.

## 3. Identität hybrid
- Lokales [[AD]] ↔ [[Entra ID]]: Synchronisierung mit **Entra Connect Sync** oder **Entra Cloud Sync**.
- Anmeldung: Kennwort-Hash-Synchronisierung (empfohlen), Passthrough-Authentifizierung oder Verbund (AD FS).
- Entra ID ist **kein** AD DS: keine GPOs, keine OUs im klassischen Sinn, kein Kerberos für Server (außer *Entra Kerberos* für Azure Files).

## 4. Werkzeuge
| Werkzeug | Beispiel |
|---|---|
| Azure-Portal | portal.azure.com |
| Azure PowerShell (Modul `Az`) | `Connect-AzAccount` · `Get-AzVM` |
| Azure CLI | `az login` · `az vm list -o table` |
| Cloud Shell | Browser-Konsole im Portal (PowerShell oder Bash) |
| ARM/Bicep | Vorlagen für wiederholbare Bereitstellung |

```powershell
# Maschine: Admin-PC / EXA-DC01 (Internetzugang)
Install-Module Az -Scope CurrentUser -Repository PSGallery
Connect-AzAccount
New-AzResourceGroup -Name rg-az802-lab -Location germanywestcentral
Get-AzResourceGroup | Format-Table ResourceGroupName, Location
Remove-AzResourceGroup -Name rg-az802-lab -Force     # Lab aufräumen = Kosten stoppen
```

## 5. Netzwerk-Grundbegriffe
| Begriff | Bedeutung |
|---|---|
| [[VNet]] | privates Netz in Azure (Adressraum, Subnetze) |
| [[NSG]] | Firewall-Regeln für Subnetz oder NIC |
| Öffentliche IP | Erreichbarkeit aus dem Internet (für Server meist vermeiden → [[Azure Bastion]]) |
| VPN-Gateway / ExpressRoute | Verbindung Rechenzentrum ↔ Azure (verschlüsselt über Internet / private Leitung) |
| Peering | VNets miteinander verbinden |
| 168.63.129.16 | interne Azure-Adresse (u. a. Azure-DNS) |

## 6. Kosten
- VMs: pro Minute, solange **zugeordnet** – „Beenden“ im Portal hebt die Zuordnung auf, Herunterfahren im Gast **nicht**.
- Speicher: pro GB + Transaktionen; Log Analytics: pro aufgenommenem GB.
- Sparen: Azure Hybrid Benefit (vorhandene Windows-Server-Lizenzen mit Software Assurance), Reservierungen, automatisches Herunterfahren.
- Lab: **Budget + Kostenwarnung** im Abonnement anlegen.

## Quellen
- [Study guide AZ-802 – Microsoft Learn](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-802)
