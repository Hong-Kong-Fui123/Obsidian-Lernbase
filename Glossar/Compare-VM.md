---
aliases:
  - Compare-VM
  - Kompatibilitätsbericht
tags:
  - glossar
  - glossar/virtualisierung
en: Compare-VM
de: VM-Kompatibilitätsprüfung
bereich: Virtualisierung
---

**Compare-VM** = *Compare-VM*
**Deutsch:** VM-Kompatibilitätsprüfung

## Kurz
Cmdlet, das vor dem Import einen Kompatibilitätsbericht erstellt und Probleme auflistet.

## Details
- `$r.Incompatibilities` zeigt MessageId und Meldung
- Probleme im Bericht beheben, dann `Import-VM -CompatibilityReport $r`
- 33012 = vSwitch nicht gefunden

## Beispiel
Maschine: **Ziel-Hyper-V-Host**
```powershell
$r = Compare-VM -Path $vmcx -Copy -GenerateNewId
$r.Incompatibilities | Format-Table MessageId, Message
Import-VM -CompatibilityReport $r
```

## Prüfungsfrage
In welcher Reihenfolge läuft ein Import mit Prüfung?

> [!success]- Lösung
> `Compare-VM` → Inkompatibilitäten beheben → `Import-VM -CompatibilityReport`.

## Siehe auch
[[VM-Import]] · [[vSwitch]] · [[Konfigurationsversion]] · [[HyperV-VM-Export-Import]] · [[00_Glossar-Index]]
