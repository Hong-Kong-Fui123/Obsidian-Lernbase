---
typ: moc
thema: AZ-802
tags: [moc, az-802, zertifizierung, windows-server, azure, hybrid]
aliases: [AZ-802, AZ-802 MOC, Windows Server Administrator Associate, AZ-802 Kapitel]
erstellt: 2026-10-19
status: lernen
---
# AZ-802 – Administering Windows Server (Übersicht)

Start: [[Start]] · Thema: [[Windows Server]] · Grundlagen Cloud: [[Azure-Grundlagen für Windows-Admins]] · [[Cloud-Modelle IaaS PaaS SaaS]]

> [!info] Prüfung auf einen Blick (Stand Oktober 2026)
> | Punkt | Wert |
> |---|---|
> | Prüfung | **AZ-802: Administering Windows Server** |
> | Zertifikat | **Microsoft Certified: Windows Server Administrator Associate** (früher *Windows Server Hybrid Administrator Associate*) |
> | Ersetzt | **AZ-800 + AZ-801** – beide am **30.09.2026** ausgelaufen |
> | Dauer | 120 Min. Prüfungszeit (Termin ca. 150 Min.) |
> | Bestehen | **700** von 1000 Punkten |
> | Hilfsmittel | Microsoft Learn ist in der Prüfung aufrufbar („open book“) – kostet aber Zeit |
> | Gültigkeit | 1 Jahr, Verlängerung über **kostenlose** Online-Bewertung auf Microsoft Learn |
> | Anmeldung | Pearson VUE (Testcenter oder online) · nicht bestanden → Wiederholung frühestens nach 24 h |

## Prüfungsbereiche und Gewichtung
| Nr. | Bereich | Gewicht | Notiz |
|---|---|---|---|
| 1 | AD DS bereitstellen und verwalten | **20–25 %** | [[AZ-802 1 AD DS]] |
| 2 | Windows Server hybrid verwalten (WAC, Remoting, Azure Arc, Update Manager, Automation) | 10–15 % | [[AZ-802 2 Hybride Verwaltung]] |
| 3 | Virtuelle Maschinen (Hyper-V + Azure-VMs) | 10–15 % | [[AZ-802 3 Virtuelle Maschinen]] |
| 4 | Netzwerk lokal und hybrid (DNS, DHCP) | 10–15 % | [[AZ-802 4 Netzwerk DNS DHCP]] |
| 5 | Speicher und Dateidienste (Azure Files, File Sync, S2D, …) | **15–20 %** | [[AZ-802 5 Speicher und Dateidienste]] |
| 6 | Windows Server absichern (OS + AD DS) | 10–15 % | [[AZ-802 6 Sicherheit]] |
| 7 | Überwachen und Problembehandlung | **15–20 %** | [[AZ-802 7 Überwachung und Problembehandlung]] |

> [!tip] Prioritäten
> AD DS, Speicher und Troubleshooting zusammen = **50–65 %**. Die Azure-Themen (Arc, Files, File Sync, Monitor, Update Manager, Azure-VMs) sind für dich am meisten **neu** → früh anfangen.

## Was du schon im Vault hast
| Prüfungsthema | Vorhandene Notiz | Stand |
|---|---|---|
| AD DS, Gruppen, Vertrauensstellungen | [[AD DS Überblick]] · [[AD-Gruppen und AGDLP]] · [[Vertrauensstellungen]] | Schule ✅ |
| Gruppenrichtlinien | [[Gruppenrichtlinien]] | Schule ✅ |
| DNS / DHCP | [[Forward-Lookup-Zone]] · [[DNS-Records]] · [[DHCP-Server]] | Schule ✅ |
| Hyper-V | [[50_Wissen/Windows Server/VHD-und-VHDX\|VHD-und-VHDX]] · [[HyperV-VM-Export-Import]] · [[Hyper-V Livemigration]] | Selbstlernmodul |
| Hochverfügbarkeit | [[Failovercluster]] · [[Hochverfügbarer Dateiserver]] · [[Cluster und Failover]] | Schule ✅ |
| Speicher | [[Speicherpools]] · [[Storage Replica]] · [[TRIM-und-UNMAP]] | Schule/Lab |
| PowerShell | [[PowerShell Grundlagen]] · [[PowerShell AD und GPO]] | laufend |
| PKI (für SMB over QUIC, LDAPS) | [[PKI und Zertifikatdienste]] | Schule aktuell |

**Neu für AZ-802:** Azure Arc · Windows Admin Center · Azure Update Manager · Azure Automation · Azure-VMs (Verfügbarkeit, Bastion, JIT) · Azure Files + File Sync · Azure Monitor/VM Insights · Hybrid-DNS · Sicherheit (OSConfig, App Control, Defender for Servers, Entra-Kennwortschutz) · AD-Wiederherstellung.

## Lernpfad (Vorschlag, 12 Wochen neben der Schule)
| Woche | Bereich | Lab (Home-Lab) |
|---|---|---|
| 1 | [[Azure-Grundlagen für Windows-Admins]] · [[Cloud-Modelle IaaS PaaS SaaS]] | kostenloses Azure-Konto, Ressourcengruppe, Budgetwarnung |
| 2–3 | [[AZ-802 1 AD DS]] | RODC, FSMO verschieben, 2. Standort, gMSA |
| 4 | [[AZ-802 2 Hybride Verwaltung]] | WAC auf EXA-DC01, EXA-SRV01 per Azure Arc anbinden |
| 5 | [[AZ-802 3 Virtuelle Maschinen]] | Nested Hyper-V, PowerShell Direct, Replikat; 1 Azure-VM mit Bastion |
| 6 | [[AZ-802 4 Netzwerk DNS DHCP]] | bedingte Weiterleitung, DNS-Richtlinie, DNSSEC, DHCP-Failover |
| 7–8 | [[AZ-802 5 Speicher und Dateidienste]] | Azure-Dateifreigabe + File Sync mit EXA-SRV01, FSRM, Dedup |
| 9 | [[AZ-802 6 Sicherheit]] | LAPS, Protected Users, OSConfig-Baseline, Firewall-Regeln |
| 10–11 | [[AZ-802 7 Überwachung und Problembehandlung]] | Datensammlersatz, Azure Monitor (DCR), AD-Papierkorb, DSRM |
| 12 | Wiederholung | kostenlose Practice Assessment auf Microsoft Learn, Schwächen nacharbeiten |

> [!warning] Kosten im Azure-Lab
> Budgetwarnung anlegen, VMs nach dem Lab **beenden (Zuordnung aufheben)** oder Ressourcengruppe löschen. Bastion, VMs und Log Analytics kosten pro Stunde bzw. pro GB.

## Prüfungstipps
- Fragetypen: Einfach-/Mehrfachauswahl, Drag-and-Drop (Reihenfolge von Schritten), Fallstudien, Ja/Nein-Serien. Laut Erfahrungsberichten derzeit keine Live-Labs.
- Reihenfolgefragen üben: z. B. *File Sync: Speichersynchronisierungsdienst → Synchronisierungsgruppe → Server registrieren → Serverendpunkt*.
- Bei „kostengünstigste / geringster Verwaltungsaufwand“ zählt das Wort – oft ist die verwaltete Azure-Lösung gemeint.
- Microsoft Learn in der Prüfung nur für Syntax nutzen, nicht zum Suchen jeder Antwort.
- Server-2025-Neuerungen kennen: [[Credential Guard]] Standard, SMB über QUIC in allen Editionen, Hotpatch über Arc, dMSA, OSConfig.

## Glossar zum Kapitel
[[Azure Arc]] · [[Windows Admin Center]] · [[JEA]] · [[Azure Update Manager]] · [[Runbook]] · [[Hotpatch]] · [[Geschachtelte Virtualisierung]] · [[PowerShell Direct]] · [[Erweiterter Sitzungsmodus]] · [[DDA]] · [[GPU-P]] · [[SET]] · [[Hyper-V-Replikat]] · [[Verwalteter Datenträger]] · [[Verfügbarkeitsgruppe]] · [[Verfügbarkeitszone]] · [[VMSS]] · [[Azure Bastion]] · [[JIT-VM-Zugriff]] · [[NSG]] · [[VNet]] · [[Bedingte Weiterleitung]] · [[DNS-Richtlinien]] · [[DNSSEC]] · [[Azure DNS Private Resolver]] · [[DHCP-Failover]] · [[Azure Files]] · [[Azure File Sync]] · [[Cloud-Tiering]] · [[SMB over QUIC]] · [[Storage QoS]] · [[Deduplizierung]] · [[Storage Migration Service]] · [[App Control for Business]] · [[OSConfig]] · [[Defender for Servers]] · [[Protected Users]] · [[Entra-Kennwortschutz]] · [[gMSA]] · [[AD-Standort]] · [[Azure Monitor]] · [[AMA]] · [[DCR]] · [[Log Analytics]] · [[KQL]] · [[VM Insights]] · [[System Insights]] · [[Datensammlersatz]] · [[AD-Papierkorb]] · [[DSRM]] · [[repadmin]] · [[dcdiag]] · [[W32Time]] · [[Sicherer Kanal]] · [[Azure Migrate]] · [[00_Glossar-Index]]

## Quellen
- [Study guide for Exam AZ-802 – Microsoft Learn](https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/az-802)
- [Windows Server Administrator Associate – Microsoft Learn](https://learn.microsoft.com/en-us/credentials/certifications/windows-server-administrator-associate/)
- [AZ-802 Exam Study Guide – Charbel Nemnom (MVP)](https://charbelnemnom.com/az-802-exam-study-guide/)
- [AZ-802 Certification Guide – StormWind Studios](https://stormwindstudios.com/blog/az-802-certification-guide-the-windows-server-exam-that-replaced-az-800-and-az-801)
