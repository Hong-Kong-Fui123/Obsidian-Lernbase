---
typ: wissen
thema: AZ-802
tags: [az-802, cloud, grundlagen, iaas, paas, saas, exam]
aliases: [Cloud-Servicemodelle, IaaS vs PaaS vs SaaS, Cloud-Modelle, Modell der geteilten Verantwortung Übersicht, Cloud-Bereitstellungsmodelle]
erstellt: 2026-10-21
status: lernen
---
# Cloud-Modelle: IaaS, PaaS, SaaS im Vergleich

Kapitel: [[AZ-802 Übersicht]] · Grundlagen: [[Azure-Grundlagen für Windows-Admins]] · Glossar: [[IaaS]] · [[PaaS]] · [[SaaS]] · [[FaaS]] · [[Modell der geteilten Verantwortung]] · [[Public Cloud]] · [[Private Cloud]] · [[Hybrid Cloud]]

> [!summary] Kernidee
> - Je weiter rechts (On-Premises → IaaS → PaaS → SaaS), desto **mehr übernimmt der Anbieter** – und desto **weniger Kontrolle** hast du.
> - **Immer deine Aufgabe:** Daten, Konten/Zugriffe, Endgeräte.
> - Merksatz: **IaaS** = du mietest den Server · **PaaS** = du mietest die Plattform · **SaaS** = du mietest die fertige Software.

## 1. Wer verwaltet was? (Modell der geteilten Verantwortung)
| Ebene | On-Premises | IaaS | PaaS | SaaS |
|---|---|---|---|---|
| Daten, Konten, Zugriffsrechte | 🟦 Du | 🟦 Du | 🟦 Du | 🟦 Du |
| Endgeräte (Clients) | 🟦 Du | 🟦 Du | 🟦 Du | 🟦 Du |
| Anwendung | 🟦 Du | 🟦 Du | 🟦 Du | 🟧 Anbieter |
| Laufzeit, Middleware (.NET, SQL-Engine, IIS) | 🟦 Du | 🟦 Du | 🟧 Anbieter | 🟧 Anbieter |
| Betriebssystem (Updates, Härtung, Virenschutz) | 🟦 Du | 🟦 Du | 🟧 Anbieter | 🟧 Anbieter |
| Virtualisierung (Hypervisor) | 🟦 Du | 🟧 Anbieter | 🟧 Anbieter | 🟧 Anbieter |
| Server, Speicher, Netzwerk (Hardware) | 🟦 Du | 🟧 Anbieter | 🟧 Anbieter | 🟧 Anbieter |
| Rechenzentrum (Strom, Kühlung, Zutritt) | 🟦 Du | 🟧 Anbieter | 🟧 Anbieter | 🟧 Anbieter |

> [!tip] Pizza-Vergleich
> On-Prem = selbst backen · IaaS = Fertigteig, eigener Ofen beim Anbieter · PaaS = Lieferservice, du deckst den Tisch · SaaS = Restaurant.

## 2. Vergleich
| Merkmal | On-Premises | [[IaaS]] | [[PaaS]] | [[SaaS]] |
|---|---|---|---|---|
| Du bekommst | eigene Hardware | VM, Datenträger, Netz | fertige Plattform/Laufzeit | fertige Anwendung |
| Kontrolle | volle | hoch (ab Betriebssystem) | mittel (Code + Daten) | gering (Einstellungen + Daten) |
| Verwaltungsaufwand | sehr hoch | hoch | gering | sehr gering |
| Patchen des OS | du | **du** | Anbieter | Anbieter |
| Skalierung | Hardware kaufen | VM-Größe / [[VMSS]] | meist automatisch | Lizenzen dazubuchen |
| Typische Nutzer | Admins | **Admins (FiSi!)** | Entwickler | Endanwender |
| Kosten | Investition (CapEx) | Verbrauch (OpEx) | Verbrauch (OpEx) | Abo pro Benutzer |
| Migration bestehender Server | – | **Lift-and-Shift** ohne Umbau | App muss angepasst werden | Datenübernahme |

## 3. Azure-Beispiele (mit AZ-802-Bezug)
| Modell | Azure-Dienst | AZ-802-Thema |
|---|---|---|
| **IaaS** | Azure Virtual Machines, [[Verwalteter Datenträger\|verwaltete Datenträger]], [[VNet]], [[VMSS]] | DC in Azure, Azure-VMs verwalten → [[AZ-802 3 Virtuelle Maschinen]] |
| **PaaS** | [[Azure Files]], Azure SQL Database, App Service, [[Azure Bastion]], Azure DNS / [[Azure DNS Private Resolver]] | Dateifreigaben ohne Server → [[AZ-802 5 Speicher und Dateidienste]] |
| **FaaS / Serverless** | Azure Functions, Logic Apps, Automation-[[Runbook\|Runbooks]] | Automatisierung → [[AZ-802 2 Hybride Verwaltung]] |
| **SaaS** | Microsoft 365, Exchange Online, [[Entra ID]], Defender-Portale | Identität hybrid → [[Azure-Grundlagen für Windows-Admins]] |
| **Hybrid** | [[Azure Arc]], [[Azure File Sync]], Azure Local (früher Azure Stack HCI) | eigene Server mit Azure-Diensten verwalten → [[AZ-802 2 Hybride Verwaltung]] |

> [!info] Gleiche Aufgabe – drei Modelle (AD-Beispiel)
> - **IaaS:** eigener DC als Azure-VM → du patchst, sicherst, überwachst.
> - **PaaS:** Microsoft Entra Domain Services → verwaltete Domäne, kein Domänen-Admin, keine DC-Patches.
> - **SaaS:** [[Entra ID]] → Cloud-Identität, aber kein klassisches AD (keine GPOs, kein Kerberos für Server).

## 4. Bereitstellungsmodelle
| Modell | Bedeutung | Beispiel |
|---|---|---|
| [[Public Cloud]] | Ressourcen eines Anbieters, von vielen Kunden geteilt, Zugang übers Internet | Azure, AWS, Google Cloud |
| [[Private Cloud]] | Cloud-Technik nur für **eine** Organisation (eigenes RZ oder dediziert) | Hyper-V/Azure Local im eigenen Rechenzentrum |
| [[Hybrid Cloud]] | Private + Public verbunden, Workloads wandern | Home-Lab EXAMPLE.COM + Azure über VPN/[[Azure Arc]] |
| Multicloud | mehrere Public-Cloud-Anbieter | Azure + AWS, verwaltet mit Arc |
| Community Cloud | gemeinsame Cloud einer Branche/Behörde | Behördencloud |

## 5. Merkmale von Cloud Computing (NIST)
1. **Selbstbedienung** nach Bedarf (Portal statt Bestellung)
2. **Breiter Netzwerkzugriff** (überall per Internet)
3. **Ressourcen-Pooling** (viele Kunden teilen Hardware)
4. **Schnelle Elastizität** (hoch- und runterskalieren)
5. **Messbarer Dienst** (Abrechnung nach Verbrauch)

## 6. Kosten: CapEx vs. OpEx
| | CapEx (Investition) | OpEx (Betriebskosten) |
|---|---|---|
| Wann | vorab, einmalig groß | laufend, nach Verbrauch |
| Typisch | eigene Server, Lizenzen kaufen | Cloud, Abos |
| Vorteil | planbar über Jahre, Eigentum | kein Startkapital, flexibel |
| Nachteil | Überkapazität, Abschreibung | kann ohne Kontrolle teuer werden → Budgets |

## 7. Prüfungsfallen (AZ-802 und IHK)
- „**geringster Verwaltungsaufwand**“ → meist PaaS/SaaS (z. B. Azure Files statt Datei-VM).
- „**volle Kontrolle über das Betriebssystem**“ / „ohne Anpassung umziehen“ → IaaS.
- Bei IaaS bleiben **Patchen, Sicherung, Virenschutz der VM** deine Aufgabe – Azure sichert die VM nicht automatisch.
- Datenschutz/Zugriffsrechte sind in **keinem** Modell Aufgabe des Anbieters.
- Hybrid ≠ Multicloud: Hybrid = eigenes RZ + Cloud; Multicloud = mehrere Clouds.

## 8. Prüfungsfragen
1. Ein Dateiserver soll ohne eigene VM in Azure laufen, Patches sollen entfallen. Welches Modell, welcher Dienst?
2. Wer installiert bei einer Azure-VM die Windows-Updates?
3. Ordne zu: Microsoft 365 · Azure SQL Database · Azure Virtual Machines.
4. Was bleibt in jedem Modell beim Kunden?
5. Euer DC läuft lokal, ein zweiter als Azure-VM. Welches Bereitstellungsmodell ist das?

> [!success]- Lösungen
> 1. PaaS – [[Azure Files]] (optional mit [[Azure File Sync]] als lokaler Cache).
> 2. Der Kunde (IaaS: Betriebssystem ist deine Aufgabe; Hilfe: [[Azure Update Manager]]).
> 3. SaaS · PaaS · IaaS.
> 4. Daten, Konten/Zugriffsrechte, Endgeräte.
> 5. Hybrid Cloud (DC-VM selbst ist IaaS).

## Quellen
- [Shared responsibility in the cloud – Microsoft Learn](https://learn.microsoft.com/en-us/azure/security/fundamentals/shared-responsibility)
- [What are IaaS, PaaS, SaaS? – Microsoft Azure](https://azure.microsoft.com/en-us/resources/cloud-computing-dictionary/what-is-iaas)
- [NIST SP 800-145: The NIST Definition of Cloud Computing](https://csrc.nist.gov/pubs/sp/800/145/final)
