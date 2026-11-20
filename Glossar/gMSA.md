---
aliases: [Group Managed Service Account]
tags: [glossar, glossar/ad-ds, az-802]
en: Group Managed Service Account
de: Gruppenverwaltetes Dienstkonto
bereich: ad-ds
---
# gMSA

**Definition:** Dienstkonto mit automatischem Kennwort (KDS), nutzbar auf mehreren Servern.

**Prüfungsfalle:** Voraussetzung `Add-KdsRootKey`; sMSA = nur 1 Server.

**Prüfen:** `Test-ADServiceAccount gmsa-web`

↑ [[AZ-802 01 AD DS]] · [[00_Glossar-AZ-802-Index]]
