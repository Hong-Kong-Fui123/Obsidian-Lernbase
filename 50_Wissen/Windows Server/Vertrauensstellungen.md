---
typ: wissen
thema: Windows Server
tags: [windows-server, active-directory, trust, vertrauensstellung]
aliases: [AD-Vertrauensstellungen, Trusts, Forest Trust]
quelle: Schulfolien + Übungen 01-01/01-02
status: lernen
---
# Vertrauensstellungen

Thema: [[Windows Server]] · Glossar: [[Kerberos]] · [[KDC]] · [[SID]] · [[UPN]]
Siehe auch: [[AD DS Überblick]] · [[AD-Gruppen und AGDLP]] · [[Forward-Lookup-Zone]] (Stub-Zone / bedingte Weiterleitung)

> [!abstract] Kern
> **Vertrauende** Domäne (trusting) lässt Benutzer der **vertrauten** Domäne (trusted) auf ihre Ressourcen. Zugriff fließt **entgegen** der Vertrauensrichtung.

## Typen
| Typ | Erstellt | Transitiv | Richtung |
|---|---|---|---|
| Über-/Unterordnung (Parent-Child) | implizit | ja | bidirektional |
| Strukturstamm (Tree-Root) | implizit | ja | bidirektional |
| **Shortcut** | explizit, gleiche Gesamtstruktur | nein | ein-/zweiseitig – verkürzt Anmeldeweg |
| **Extern** | explizit, Domäne ↔ Domäne fremder Gesamtstruktur | nein | ein-/zweiseitig |
| **Gesamtstruktur** (Forest) | explizit, Stamm ↔ Stamm | **ja** | ein-/zweiseitig |
| Bereich (Realm) | explizit, zu Kerberos-5-Bereich (z. B. Linux) | konfigurierbar | konfigurierbar |

## Voraussetzungen und Optionen
- **Namensauflösung** zuerst: Stub-Zone oder bedingte Weiterleitung auf beiden DNS-Servern
- **Namenssuffix-Routing**: welche UPN-Suffixe über den Forest-Trust geroutet werden
- **Ausgewählte Authentifizierung**: nur explizit erlaubte Benutzer/Gruppen (Recht *Authentifizierung zulassen* am Computerkonto)
- **SID-Filterung** (Quarantäne): standardmäßig an; nach Migration ggf. aus (SID-History)

**Prüfen** – Maschine: EXA-DC01 (PowerShell)
```powershell
Get-ADTrust -Filter * | Select-Object Name, Direction, ForestTransitive, SelectiveAuthentication
nltest /domain_trusts
netdom trust example.com /domain:contoso.com /verify
```

> [!example] Home-Lab-Ziel
> Gesamtstruktur-Vertrauensstellung **example.com ↔ contoso.com** (EXA-DC01 ↔ CON-DC) → EXAMPLE-Benutzer greifen per SSO auf ein Laufwerk bei CON-DC zu. Reihenfolge: DNS (bedingte Weiterleitung) → Trust → Freigabe + Berechtigung über [[AD-Gruppen und AGDLP|AGDLP]].

> [!question] Selbsttest
> contoso.com vertraut example.com (einseitig). Wer kann auf wessen Freigaben zugreifen?

## 📄 Unterlagen
- Folien: [[AD-Vertrauensstellungen.pdf#page=1|Was ist eine VS?]] · [[AD-Vertrauensstellungen.pdf#page=2|Implizit/explizit]] · [[AD-Vertrauensstellungen.pdf#page=5|Typen]] · [[AD-Vertrauensstellungen.pdf#page=7|Shortcut]] · [[AD-Vertrauensstellungen.pdf#page=10|Ablauf in Gesamtstruktur]] · [[AD-Vertrauensstellungen.pdf#page=12|Ablauf zwischen Gesamtstrukturen]] · [[AD-Vertrauensstellungen.pdf#page=14|Erstellen]] · [[AD-Vertrauensstellungen.pdf#page=15|Namenssuffix-Routing]] · [[AD-Vertrauensstellungen.pdf#page=16|Ausgewählte Auth.]] · [[AD-Vertrauensstellungen.pdf#page=17|SID-Filterung]]
- Übungen: [[Uebung_AD-Vertrauensstellungen_1.pdf|01-01 Domänen und Gesamtstrukturen]] · [[Uebung_AD-Vertrauensstellungen_2.pdf|01-02 Vertrauensstellungen]] · [[Uebung_AD-Vertrauensstellungen_2.pdf#page=2|Suffix-Routing/Ausgewählte Auth.]] · [[Uebung_AD-Vertrauensstellungen_2.pdf#page=3|Shortcut/SID-Filter]]
- Buch 70-742: [[70-742_Server2016_Identitaet.pdf#page=160|Vertrauensstellungen einrichten]] · [[70-742_Server2016_Identitaet.pdf#page=158|UPN-Suffixe]]
- Buch 70-640: [[70-640_Server2008R2_AD.pdf#page=674|Mehrere Domänen und Vertrauensstellungen]]
