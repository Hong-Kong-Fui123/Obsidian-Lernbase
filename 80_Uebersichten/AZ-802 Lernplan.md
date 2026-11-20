---
tags: [lernplan, az-802]
dauer: 12 Wochen
rhythmus: 2–3 × 60 Min + 120 Min Wochenende
---
# AZ-802 Lernplan (12 Wochen)

Reihenfolge an Schule angepasst: GPO/PKI läuft dort → AD DS + Sicherheit zuerst.

| Woche | Thema | Einheiten 60 Min | Wochenende 120 Min | ✔ |
|---|---|---|---|---|
| 1 | AD DS: DCs, RODC, FSMO | Theorie 01 · Lab 01 A1–A2 | Lab 01 A3 + EXA-DC02 aufsetzen | ⬜ |
| 2 | AD DS: Standorte, Replikation, Trusts | Theorie · Lab 01 A4 | CON-DC + Forest-Trust | ⬜ |
| 3 | AD DS: Konten, gMSA, GPO | Lab 01 A5–A6 | Wiederholung + Glossar | ⬜ |
| 4 | Sicherheit AD + OS | Theorie 06 · Lab 06 A1–A3 | Lab 06 A4–A6 | ⬜ |
| 5 | Hyper-V | Theorie 03 · Lab 03 A1–A3 | Lab 03 A4–A6 | ⬜ |
| 6 | DNS / DHCP | Theorie 04 · Lab 04 A1–A3 | Lab 04 A4–A5 | ⬜ |
| 7 | Speicher: Datenträger, Spaces, iSCSI, BitLocker | Theorie 05 · Lab 05 A1–A3 | Lab 05 A4 | ⬜ |
| 8 | Dateidienste: SMB, FSRM, DFS, QUIC | Lab 05 A5–A6 | Wiederholung | ⬜ |
| 9 | Hybrid: WAC, Remoting, JEA, SSH | Theorie 02 · Lab 02 A1–A3 | Lab 02 A4 | ⬜ |
| 10 | Azure: Arc, Update Manager, VMs, Azure Files | Lab 02 A5 · Lab 03 A7 | Lab 05 A7 (File Sync) | ⬜ |
| 11 | Monitoring & Troubleshooting | Theorie 07 · Lab 07 A1–A4 | Lab 07 A5–A7 | ⬜ |
| 12 | Prüfungsvorbereitung | Schwächen wiederholen | [[AZ-802 Klausur 01]] + MS Übungsbewertung | ⬜ |

## Regeln
- Erst Leitfragen beantworten, dann Lab, dann Lösung vergleichen.
- Jede Lab-Aufgabe mit PowerShell-Validierung abschließen.
- Vor jedem Lab: Prüfpunkt (Checkpoint) der VMs.
- Azure-Labs: Ressourcengruppe `rg-az802-lab` → nach Lab `Remove-AzResourceGroup`.
