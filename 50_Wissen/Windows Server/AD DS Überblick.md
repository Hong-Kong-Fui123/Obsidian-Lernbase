---
typ: wissen
thema: Windows Server
tags: [windows-server, active-directory, ad-ds, fsmo]
aliases: [Active Directory Überblick, AD DS Grundlagen, Active Directory Grundlagen]
quelle: Schulfolien + Bücher
status: lernen
---
# AD DS Überblick

Thema: [[Windows Server]] · Glossar: [[AD DS]] · [[DC]] · [[FSMO]] · [[OU]] · [[Kerberos]]
Siehe auch: [[AD und DNS Grundlagen]] · [[AD-Gruppen und AGDLP]] · [[Vertrauensstellungen]] · [[Lab AD-Grundlagen (Schule)]] · [[PowerShell AD und GPO]]

## Komponenten
| Logisch | Physisch |
|---|---|
| Partitionen, Schema, Domänen, Domänenstrukturen, Gesamtstrukturen, Standorte, OUs, Container | Domänencontroller, Datenspeicher (`ntds.dit`), Globale Katalogserver, RODCs |

- **Domäne** = Replikations- und Verwaltungsgrenze. Alle DCs halten eine Kopie der Domänendatenbank.
- **OU** = Gruppieren + **GPOs verknüpfen** + **Rechte delegieren**. Container (z. B. `Users`) können das nicht.
- **Schema** = Bauplan aller Objekttypen. Nur erweiterbar, nicht löschbar. Änderung auf dem **Schemamaster** durch *Schema-Admins*.
- **Globaler Katalog (GC)** = Teilattributsatz aller Domänen der Gesamtstruktur → gesamtstrukturweite Suche, universelle Gruppen.
- DCs finden: **SRV-Records** im [[DNS]] (`_ldap._tcp…`) → ohne DNS kein AD.

## Anmeldung (Kerberos)
1. Benutzer authentifiziert sich am DC → bekommt [[TGT]]
2. Mit TGT fordert der Client Diensttickets an (Arbeitsstation, Server)
3. Zeit wichtig: max. **5 Minuten** Abweichung → Zeitquelle = PDC-Emulator

## Betriebsmaster (FSMO) – 5 Rollen
| Ebene | Rolle | Ausfall bedeutet |
|---|---|---|
| Gesamtstruktur | **Schemamaster** | keine Schemaänderung |
| Gesamtstruktur | **Domänennamenmaster** | keine Domäne hinzufügen/umbenennen |
| Domäne | **RID-Master** | DC mit leerem RID-Pool kann keine Objekte anlegen |
| Domäne | **PDC-Emulator** | Zeit, Kennwortänderungen, GPO-Bearbeitung |
| Domäne | **Infrastrukturmaster** | domänenübergreifende Verweise veraltet |

**Abfragen** – Maschine: EXA-DC01 (PowerShell)
```powershell
Get-ADForest | Select-Object SchemaMaster, DomainNamingMaster
Get-ADDomain | Select-Object PDCEmulator, RIDMaster, InfrastructureMaster
netdom query fsmo
```

> [!question] Selbsttest
> Warum sollte der Infrastrukturmaster in einer Multi-Domänen-Umgebung **kein** GC sein – außer alle DCs sind GC?

## 📄 Unterlagen
- Folien AD DS: [[AD-DS_Ueberblick_Folien.pdf#page=3|Komponenten]] · [[AD-DS_Ueberblick_Folien.pdf#page=4|Domänen]] · [[AD-DS_Ueberblick_Folien.pdf#page=5|OUs]] · [[AD-DS_Ueberblick_Folien.pdf#page=6|Gesamtstruktur]] · [[AD-DS_Ueberblick_Folien.pdf#page=7|Schema]] · [[AD-DS_Ueberblick_Folien.pdf#page=9|DC]] · [[AD-DS_Ueberblick_Folien.pdf#page=11|GC]] · [[AD-DS_Ueberblick_Folien.pdf#page=12|Anmeldung]] · [[AD-DS_Ueberblick_Folien.pdf#page=13|DC finden]] · [[AD-DS_Ueberblick_Folien.pdf#page=14|FSMO]] · [[AD-DS_Ueberblick_Folien.pdf#page=16|RID/Infrastruktur]] · [[AD-DS_Ueberblick_Folien.pdf#page=17|PDC-Emulator]]
- Buch 70-742: [[70-742_Server2016_Identitaet.pdf#page=16|Grundlagen AD DS]] · [[70-742_Server2016_Identitaet.pdf#page=39|RODC]] · [[70-742_Server2016_Identitaet.pdf#page=43|GC]] · [[70-742_Server2016_Identitaet.pdf#page=57|FSMO übertragen/übernehmen]] · [[70-742_Server2016_Identitaet.pdf#page=133|AD sichern]]
- Buch 70-640: [[70-640_Server2008R2_AD.pdf#page=559|Kap. 10 DCs und Betriebsmaster]]
- Prüfungsfragen: [[AD-DS_50_Pruefungsfragen.pdf#page=1|AD DS 50 (MC)]] · [[AD-DS_50_Pruefungsfragen.pdf#page=6|F35–42 FSMO]] · [[AD-DS_20_Pruefungsfragen.pdf#page=1|AD DS 20 Szenarien]] · [[AD-DS_10_Pruefungsfragen.pdf#page=1|AD DS 10 Szenarien]]
