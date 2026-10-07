---
title: Übersicht Theorieklausuren
tags:
  - moc
  - klausur
  - windows-server
---
# 00 Uebersicht Theorieklausuren

Drei Theorieklausuren zu Windows Server 2022 ([[AD DS]], [[AD CS]], [[AD]] FS/WAP, Netzwerk). Keine Frage kommt doppelt vor.

| Klausur | Aufgaben | Zeit |
|---|---|---|
| [[Theorieklausur 1 - Windows Server 2022]] | 40 | 90 min |
| [[Theorieklausur 2 - Windows Server 2022]] | 40 | 90 min |
| [[Theorieklausur 3 - Windows Server 2022]] | 40 | 90 min |

## Themenverteilung je Klausur

| Thema | Aufgaben |
|---|---|
| AD DS - Domänendienste | 16 MC + Eingabe |
| Netzwerk - [[IPv4]]/[[IPv6]], Routing, [[DNS]], [[DHCP]] | 10 MC + Eingabe |
| AD CS - Zertifikatdienste | 6 MC |
| AD FS & Webanwendungsproxy | 3 MC |

## Ergebnisse

```dataview
TABLE status, ergebnis, datum
FROM #klausur AND -#moc
SORT file.name ASC
```

> [!tip] Ohne Dataview-Plugin
> Die Tabelle oben braucht das Community-Plugin **Dataview**. Ohne Plugin einfach in jeder Klausur die Eigenschaften `status`, `ergebnis` und `datum` pflegen.

## 📄 Weitere Prüfungsfragen (PDF)
| Thema | Fragen | Lösungen |
|---|---|---|
| AD DS (50 MC) | [[AD-DS_50_Pruefungsfragen.pdf#page=1\|öffnen]] | [[AD-DS_50_Pruefungsfragen.pdf#page=9\|S. 9]] |
| AD DS (20 Szenarien) | [[AD-DS_20_Pruefungsfragen.pdf#page=1\|öffnen]] | [[AD-DS_20_Pruefungsfragen.pdf#page=7\|S. 7]] |
| AD DS (10 Szenarien) | [[AD-DS_10_Pruefungsfragen.pdf#page=1\|öffnen]] | [[AD-DS_10_Pruefungsfragen.pdf#page=4\|S. 4]] |
| AD CS (20 + 10) | [[AD-CS_20_Pruefungsfragen.pdf#page=1\|öffnen]] | [[AD-CS_20_Pruefungsfragen.pdf#page=8\|S. 8]] |
| AD FS (10) | [[AD-FS_10_Pruefungsfragen.pdf#page=1\|öffnen]] | [[AD-FS_10_Pruefungsfragen.pdf#page=3\|S. 3]] |
| Netzwerk (30 + 20) | [[Netzwerk_30_Pruefungsfragen.pdf#page=1\|öffnen]] | [[Netzwerk_30_Pruefungsfragen.pdf#page=11\|S. 11]] |
| Netzwerk (10 Szenarien) | [[Netzwerk_10_Pruefungsfragen.pdf#page=1\|öffnen]] | [[Netzwerk_10_Pruefungsfragen.pdf#page=4\|S. 4]] |
| VPN/RADIUS (15 + 10) | [[VPN-RADIUS_15_Pruefungsfragen.pdf#page=1\|öffnen]] | [[VPN-RADIUS_15_Pruefungsfragen_Loesung.pdf#page=7\|S. 7]] |

Praxis: [[00 Uebersicht Praxisklausuren]]
