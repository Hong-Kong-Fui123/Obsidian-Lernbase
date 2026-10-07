---
typ: wissen
thema: Windows Server
tags: [windows-server, active-directory, gruppen, agdlp]
aliases: [AD-Gruppen, Gruppenbereiche]
quelle: Schulfolien Kap. 4
status: lernen
---
# AD-Gruppen und AGDLP

Thema: [[Windows Server]] · Glossar: [[AGDLP]] · [[SID]] · [[SAM]] · [[ACL]]
Siehe auch: [[AD DS Überblick]] · [[PowerShell AD und GPO]]

## Gruppentyp
| Typ | SID | Berechtigungen | Zweck |
|---|---|---|---|
| **Sicherheitsgruppe** | ja | ja | Zugriff steuern (kann auch E-Mail) |
| **Verteilergruppe** | nein | nein | nur E-Mail-Verteiler |

## Gruppenbereich (Scope)
| Bereich | Mitglieder | Verwendbar | Gespeichert |
|---|---|---|---|
| **Lokal** (Computer) | B, C, GG, UG, LDG (eigene Domäne) | nur lokaler Computer | [[SAM]] des Computers |
| **Lokal (in Domäne)** – LDG | B, C, GG, UG aus Gesamtstruktur/vertr. Domänen + LDG der eigenen Domäne | ganze Domäne | Domäne |
| **Global** – GG | nur **eigene Domäne**: B, C, GG | Gesamtstruktur + vertrauende Domänen | Domäne |
| **Universal** – UG | B, C, GG, UG der Gesamtstruktur | Gesamtstruktur | **Globaler Katalog** |

B = Benutzer, C = Computer, GG = globale, LDG = lokale Domänen-, UG = universelle Gruppe

## AGDLP
**A**ccounts → **G**lobal → **D**omain **L**ocal → **P**ermissions
- Globale Gruppe = **Rolle** (z. B. `GG_Vertrieb`)
- Lokale Domänengruppe = **Zugriffsregel** (z. B. `LDG_Share_Vertrieb_Lesen`)
- Berechtigung nur an die LDG vergeben

**Beispiel** – Maschine: EXA-DC01 (PowerShell)
```powershell
New-ADGroup -Name "GG_Vertrieb" -GroupScope Global -GroupCategory Security -Path "OU=Schulung,DC=example,DC=com"
New-ADGroup -Name "LDG_Share_Vertrieb_RW" -GroupScope DomainLocal -GroupCategory Security -Path "OU=Schulung,DC=example,DC=com"
Add-ADGroupMember -Identity "LDG_Share_Vertrieb_RW" -Members "GG_Vertrieb"
Add-ADGroupMember -Identity "GG_Vertrieb" -Members "hschmidt"
```

> [!tip] Best Practice
> Standardgruppen (Domänen-Admins, Konten-Operatoren …) möglichst leer lassen → eigene Gruppen mit genau den nötigen Rechten.

> [!question] Selbsttest
> Ein Benutzer aus `canberra.example.com` soll auf eine Freigabe in `example.com`. In welche Gruppe kommt er zuerst – und warum geht das mit einer globalen Gruppe aus `example.com` **nicht**?

## 📄 Unterlagen
- Folien Gruppen: [[AD-Gruppen.pdf#page=4|Gruppentyp]] · [[AD-Gruppen.pdf#page=5|Gruppenbereich]] · [[AD-Gruppen.pdf#page=6|Lokal]] · [[AD-Gruppen.pdf#page=7|Lokal (Domäne)]] · [[AD-Gruppen.pdf#page=8|Global]] · [[AD-Gruppen.pdf#page=9|Universal]] · [[AD-Gruppen.pdf#page=10|Zusammenfassung]] · [[AD-Gruppen.pdf#page=12|Standardgruppen]] · [[AD-Gruppen.pdf#page=13|Sonderidentitäten]]
- Buch 70-742: [[70-742_Server2016_Identitaet.pdf#page=88|Gruppen erstellen und verwalten]] · [[70-742_Server2016_Identitaet.pdf#page=97|Delegierung]]
- Buch 70-640: [[70-640_Server2008R2_AD.pdf#page=185|Kap. 4 Gruppen]]
- Prüfungsfragen: [[AD-DS_50_Pruefungsfragen.pdf#page=4|F21–34 OUs, Gruppen, Delegierung]]
