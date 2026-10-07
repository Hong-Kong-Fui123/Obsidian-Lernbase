---
typ: wissen
thema: Windows Server
tags: [windows-server, gpo, gruppenrichtlinien]
aliases: [Gruppenrichtlinien (GPO), GPO Grundlagen]
quelle: Schulfolien Kap. 6 + Übungen 1–4
status: lernen
---
# Gruppenrichtlinien

Thema: [[Windows Server]] · Glossar: [[GPO]] · [[GPMC]] · [[SYSVOL]] · [[WMI]]
Siehe auch: [[PowerShell AD und GPO]] · [[AD DS Überblick]] · [[Lab AD-Grundlagen (Schule)]]

## Grundbegriffe
- **GPO** = Container für Einstellungen; Teil 1 im AD (GPC), Teil 2 in [[SYSVOL]] (GPT)
- **Computerkonfiguration** gilt beim Start, **Benutzerkonfiguration** bei Anmeldung
- **Richtlinien** (verwaltet, werden zurückgesetzt) vs. **Einstellungen/Preferences** (nicht verwaltet, bleiben)
- **Zentraler Speicher** für ADMX: `\\example.com\SYSVOL\example.com\Policies\PolicyDefinitions`

## Verarbeitungsreihenfolge – LSDOU
**L**okal → **S**tandort → **D**omäne → **OU** (übergeordnet → untergeordnet). Letzte gewinnt.

| Werkzeug | Wirkung |
|---|---|
| **Erzwungen** (Enforced) | Verknüpfung kann nicht überschrieben/blockiert werden |
| **Vererbung deaktivieren** | OU ignoriert übergeordnete GPOs (außer erzwungene) |
| **Sicherheitsfilterung** | nur Gruppen mit *Lesen* + *Gruppenrichtlinie übernehmen* |
| **WMI-Filter** | Bedingung, z. B. nur Windows-Clients |
| **Loopback** (Ersetzen/Zusammenführen) | Benutzereinstellungen abhängig vom **Computer** (Kiosk, Laptops) |

WMI-Filter aus den Schulunterlagen (nur Clients mit Windows 10/11):
```sql
select * from Win32_OperatingSystem where Version like "10.%" and ProductType="1"
```

## Befehle
**Maschine: EXA-CL01** (CMD/PowerShell)
```powershell
gpupdate /force          # sofort anwenden
gpresult /r              # Kurzbericht RSoP
gpresult /h C:\rsop.html # HTML-Bericht
```
**Maschine: EXA-DC01** (PowerShell)
```powershell
New-GPO -Name "Bildschirmschoner" | New-GPLink -Target "OU=Schulung,DC=example,DC=com"
Get-GPInheritance -Target "OU=Schulung,DC=example,DC=com"
Backup-GPO -All -Path C:\GPOBackup
```

> [!question] Selbsttest
> Eine Domänen-GPO setzt den Bildschirmschoner auf 10 Min, eine OU-GPO auf „aus“. Welche gewinnt? Und was ändert sich, wenn die Domänen-GPO **erzwungen** ist?

## 📄 Unterlagen
- Folien (Kap. 6): [[AD-Gruppenrichtlinien.pdf#page=4|GPOs]] · [[AD-Gruppenrichtlinien.pdf#page=7|Gültigkeitsbereich]] · [[AD-Gruppenrichtlinien.pdf#page=9|Aktualisierung]] · [[AD-Gruppenrichtlinien.pdf#page=13|Speicherung]] · [[AD-Gruppenrichtlinien.pdf#page=16|Admin. Vorlagen]] · [[AD-Gruppenrichtlinien.pdf#page=17|Zentraler Speicher]] · [[AD-Gruppenrichtlinien.pdf#page=20|Vererbung/Rangfolge]] · [[AD-Gruppenrichtlinien.pdf#page=21|Sicherheitsfilterung]] · [[AD-Gruppenrichtlinien.pdf#page=22|WMI-Filter]] · [[AD-Gruppenrichtlinien.pdf#page=25|Loopback]] · [[AD-Gruppenrichtlinien.pdf#page=26|Verarbeitung]] · [[AD-Gruppenrichtlinien.pdf#page=31|RSoP]]
- Übungen: [[Uebung_Gruppenrichtlinien_1.pdf|1 GPO erstellen]] · [[Uebung_Gruppenrichtlinien_2.pdf|2 Vorrang/Erzwungen]] · [[Uebung_Gruppenrichtlinien_3.pdf|3 Sicherheitsfilter/Loopback]] · [[Uebung_Gruppenrichtlinien_4.pdf|4 RSoP/gpresult]]
- Buch 70-742: [[70-742_Server2016_Identitaet.pdf#page=185|Kap. 3 GPO]] · [[70-742_Server2016_Identitaet.pdf#page=221|Vorrang]] · [[70-742_Server2016_Identitaet.pdf#page=228|Sicherheits-/WMI-Filter]] · [[70-742_Server2016_Identitaet.pdf#page=238|Loopback]] · [[70-742_Server2016_Identitaet.pdf#page=272|Präferenzen]]
- Buch 70-640: [[70-640_Server2008R2_AD.pdf#page=287|Kap. 6 GPO-Infrastruktur]] · [[70-640_Server2008R2_AD.pdf#page=363|Kap. 7 Sicherheit mit GPOs]]
- Prüfungsfragen: [[AD-DS_50_Pruefungsfragen.pdf#page=7|F43–50 (u. a. GPO)]]
