---
title: Übersicht Theorieklausuren
tags:
  - moc
  - klausur
  - windows-server
---
# 00 Uebersicht Theorieklausuren

Drei Übungsklausuren zu Windows Server 2022 ([[AD DS]], [[AD CS]], [[AD]] FS/WAP, Netzwerk). Keine Frage kommt doppelt vor.

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
