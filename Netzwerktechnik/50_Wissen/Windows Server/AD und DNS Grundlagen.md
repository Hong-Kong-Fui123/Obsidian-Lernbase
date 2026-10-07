---
typ: wissen
thema: Windows Server
tags: [windows-server, active-directory, dns]
quelle: Word-Notizen
status: importiert
---
# AD und DNS Grundlagen

Thema: [[Windows Server]] · Vertiefung: [[AD DS Überblick]] · [[Glossar/Forward-Lookup-Zone]] · [[Glossar/DNS-Records]]

## Was ist eine Stub-Zone?

Kopie einer Zone, enthält NS, SOA und „Glue Host“- Einträge.

Nicht autorisierend.

## Was sind die DNS-Domänen?

1. Root-Domain ( . )

2. First-Level-Domain ( de )

3. Second-Level-Domain ( example )

## Was ist ein SAM?

[[SAM|Security Accounts Manager]] – lokale Kontendatenbank (Arbeitsgruppe/Mitgliedsserver)

## Was macht das AD?

Zentrale Verwaltung von Diensten, Gruppen und Richtlinien.

## Was ist das SSO?

**S**ingle **S**ign **O**n.

Einmal in der Domäne angemeldet, kann man auf die Daten in den freigegebenen Orten zugreifen, als wenn es der eigene PC ist.

Wird durch das [[Kerberos]]-Protokoll durchgeführt.

## Was sind die IDA?

Identity and Access Managment

1. **[[AD DS]]**       (Active Directory Domain Services) – Zentrale Verzeichnisdatenbank für

Benutzer, Computer, Gruppen

2. **[[AD CS]]**       (Active Directory Certificate Services) – Zertifikatverwaltung und [[PKI]]

3. **[[ADFS|AD FS]]**       (Active Directory Federation Services) – Sichere Identitätsverbund

Authentifizierung über Grenzen

4. **AD RMS**   (Active Directory Rights Management Services) – Dokumentenschutz

und Zugriffskontrolle

5.**AD LDS**     (Active Directory Lightweight Directory Services) – Leichtgewichtige

Verzeichnisdatenbank ohne AD DS

## Was bedeutet UPN?

User Principal Name

Aktueller Name für das einloggen. Z.B. [Administrator@example.com](mailto:Administrator@example.com)

## 📄 Unterlagen
- Folien: [[AD-DS_Ueberblick_Folien.pdf#page=3|AD DS Komponenten]] · [[DNS_WindowsServer2025.pdf#page=4|DNS-Namensraum]] · [[DNS_WindowsServer2025.pdf#page=7|Zonentypen (Stub-Zone)]]
- Buch 70-640: [[70-640_Server2008R2_AD.pdf#page=487|Kap. 9 DNS in AD DS]]
- Buch 70-742: [[70-742_Server2016_Identitaet.pdf#page=158|UPN-Suffixe]] · [[70-742_Server2016_Identitaet.pdf#page=355|AD FS]]
- Prüfungsfragen: [[AD-DS_50_Pruefungsfragen.pdf#page=1|AD DS 50]] · [[AD-FS_10_Pruefungsfragen.pdf#page=1|AD FS 10]]
