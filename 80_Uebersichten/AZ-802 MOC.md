---
aliases: [AZ-802, Windows Server Hybrid Admin]
tags: [moc, az-802]
pruefung: AZ-802 Verwalten von Windows Server
zertifikat: Windows Server Hybrid Administrator Associate
bestehen: 700/1000
sprache: Englisch
quelle: https://learn.microsoft.com/de-de/credentials/certifications/resources/study-guides/az-802
stand_quelle: 2026-10-23
---
# AZ-802 – Übersicht (MOC)

> [!info] Prüfung
> Windows Server als Workload: lokal, Azure, hybrid. Bestehen ab **700**. Nur **Englisch** → 30 Min Verlängerung beantragbar.
> Tools: Windows Admin Center, Hyper-V, PowerShell, Azure Arc, Azure Monitor, Azure Update Manager, Defender for Cloud, AD DS.

## Bereiche & Gewichtung
| Nr | Bereich | Gewicht | Thema | Lab | Status |
|---|---|---|---|---|---|
| 01 | AD DS bereitstellen/verwalten | 20–25 % | [[AZ-802 01 AD DS]] | [[AZ-802 Lab 01 AD DS - Aufgaben]] | ⬜ |
| 02 | Hybrid: Instanzen & Workloads | 10–15 % | [[AZ-802 02 Hybrid-Verwaltung]] | [[AZ-802 Lab 02 Hybrid - Aufgaben]] | ⬜ |
| 03 | Virtuelle Computer | 10–15 % | [[AZ-802 03 Virtuelle Computer]] | [[AZ-802 Lab 03 Hyper-V - Aufgaben]] | ⬜ |
| 04 | Netzwerkinfrastruktur | 10–15 % | [[AZ-802 04 Netzwerk DNS DHCP]] | [[AZ-802 Lab 04 Netzwerk - Aufgaben]] | ⬜ |
| 05 | Speicher & Dateidienste | 15–20 % | [[AZ-802 05 Speicher und Dateidienste]] | [[AZ-802 Lab 05 Speicher - Aufgaben]] | ⬜ |
| 06 | Sicherheit | 10–15 % | [[AZ-802 06 Sicherheit]] | [[AZ-802 Lab 06 Sicherheit - Aufgaben]] | ⬜ |
| 07 | Überwachung & Troubleshooting | 15–20 % | [[AZ-802 07 Ueberwachung und Troubleshooting]] | [[AZ-802 Lab 07 Troubleshooting - Aufgaben]] | ⬜ |

Status: ⬜ offen · 🟨 gelernt · 🟩 Lab erledigt · ✅ Klausur bestanden

## Navigation
- Lernplan: [[AZ-802 Lernplan]]
- Befehle: [[AZ-802 PowerShell-Referenz]]
- Glossar: [[00_Glossar-AZ-802-Index]]
- Probeklausur: [[AZ-802 Klausur 01]] → [[AZ-802 Klausur 01 - Loesungen]]
- Vorlage: [[Vorlage AZ-802 Lab]]

## Lab-Umgebungen
| Kürzel | Umgebung | Maschinen | Hinweis |
|---|---|---|---|
| HL | Home-Lab Hyper-V | EXA-DC01, EXA-DC02, EXA-SRV01–03, EXA-CL01, CON-DC, Hyper-V-Host | kein Internet |
| AZ | Azure (Free/Pay-as-you-go) | Azure-Portal, Cloud Shell, Azure-VMs | Kosten! Ressourcen nach Lab löschen |
| HY | Hybrid | HL-VM mit Internet (NAT-Switch) + Azure | nötig für Arc, Update Manager, File Sync |

> [!warning] School-Lab
> Schul-PC nutzt ebenfalls example/contoso – Home-Lab-Aufgaben **nicht** im School-Lab ausführen.

## Offizielle Quellen
- Prüfungsseite: https://learn.microsoft.com/de-de/credentials/certifications/exams/az-802/
- Studienleitfaden: https://learn.microsoft.com/de-de/credentials/certifications/resources/study-guides/az-802
- Prüfungs-Sandbox: https://aka.ms/examdemo
- Windows-Server-Doku: https://learn.microsoft.com/de-de/windows-server/
