---
aliases: [Trust, Forest-Trust, Gesamtstrukturvertrauensstellung]
tags: [glossar, glossar/ad-ds, az-802]
en: Trust
de: Vertrauensstellung
bereich: ad-ds
---
# Vertrauensstellung

**Definition:** Erlaubt Authentifizierung über Domänen-/Forest-Grenzen. Typen: Forest, External, Shortcut, Realm, Parent-Child.

**Prüfungsfalle:** Zugriff fließt entgegen der Vertrauensrichtung; selektive Auth = *Allowed to authenticate* am Computerobjekt.

**Prüfen:** `Get-ADTrust -Filter *`

↑ [[AZ-802 01 AD DS]] · [[00_Glossar-AZ-802-Index]]
