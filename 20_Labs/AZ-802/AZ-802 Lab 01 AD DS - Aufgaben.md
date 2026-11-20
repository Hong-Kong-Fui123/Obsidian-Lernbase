---
tags: [az-802, lab, az-802/ad-ds]
bereich: 01
umgebung: HL
maschinen: [EXA-DC01, EXA-DC02, EXA-SRV01, CON-DC]
status: offen
---
# Lab 01 AD DS – Aufgaben
↑ [[AZ-802 01 AD DS]] · Lösungen: [[AZ-802 Lab 01 AD DS - Loesungen]]

> [!tip] Vorher: Checkpoint aller beteiligten VMs (Hyper-V-Host).

### A1 – Zweiten DC hochstufen
**Maschine:** EXA-DC02 (neu, Server 2025 Core oder GUI)
**Auftrag:** EXA-DC02 als zusätzlichen DC mit DNS + GC in example.com aufnehmen.
**Leitfragen:** Welche DNS-Server-Adresse braucht EXA-DC02 *vor* dem Hochstufen? Was prüfst du danach als erstes?
**Validierung (EXA-DC01):** `Get-ADDomainController -Filter * | ft Name,IsGlobalCatalog,Site`

### A2 – FSMO verteilen
**Maschine:** EXA-DC01
**Auftrag:** RID Master + Infrastructure Master auf EXA-DC02 übertragen. Danach zurück.
**Leitfrage:** Warum Infrastructure Master nicht auf GC (in Multi-Domänen-Forest)?
**Validierung:** `netdom query fsmo`

### A3 – RODC + PRP
**Maschine:** EXA-SRV02 (temporär als RODC) · Verwaltung auf EXA-DC01
**Auftrag:** Konto `rodc-admin` vorbereiten, EXA-SRV02 als RODC hochstufen, Gruppe `GG_Aussenstelle` in Allowed-Liste.
**Leitfrage:** Wo siehst du, welche Kennwörter auf dem RODC zwischengespeichert sind?
**Validierung:** `Get-ADDomainControllerPasswordReplicationPolicy -Identity EXA-SRV02 -Allowed`

### A4 – Standort + Forest-Trust
**Maschinen:** EXA-DC01, CON-DC
**Auftrag:**
1. Standort `Aussenstelle` mit Subnetz `10.10.20.0/24`, Standortverknüpfung Kosten 200, Intervall 60 Min.
2. Bedingte Weiterleitungen in beide Richtungen.
3. Zweiseitige Forest-Vertrauensstellung example.com ↔ contoso.com, selektive Authentifizierung in contoso.
**Leitfragen:** Welche Seite braucht *Allowed to authenticate* auf welchem Objekt? Warum zuerst DNS?
**Validierung:** `Get-ADReplicationSite -Filter *` · `Get-ADTrust -Filter *` · `nltest /domain_trusts`

### A5 – Gruppen nach AGDLP + gMSA
**Maschinen:** EXA-DC01, EXA-SRV01
**Auftrag:**
1. `GG_IT` (global), `DL_Share_IT_RW` (domänenlokal), Verschachtelung nach AGDLP.
2. KDS-Root-Key, gMSA `gmsa-web` nur für EXA-SRV01, auf EXA-SRV01 installieren.
**Leitfrage:** Warum braucht ein Lab `-EffectiveTime` beim KDS-Key?
**Validierung (EXA-SRV01):** `Test-ADServiceAccount gmsa-web` → `True`

### A6 – GPO + Preferences
**Maschine:** EXA-DC01 · Test auf EXA-CL01
**Auftrag:** GPO `GPO_Laufwerk_IT`: Laufwerk `I:` → `\\EXA-SRV03\IT` per GPP mit Item-Level-Targeting auf `GG_IT`; OU *Clients* verknüpfen.
**Leitfrage:** Warum greift ein Computer-Sicherheitsfilter nicht, wenn nur Benutzergruppe gesetzt ist und *Authenticated Users* entfernt wurde?
**Validierung (EXA-CL01):** `gpresult /r /scope user`
