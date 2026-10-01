---
typ: wissen
thema: Windows Server
tags: [windows-server, active-directory, dns]
quelle: Word-Notizen
status: importiert
---
# AD und DNS Grundlagen

Thema: [[Windows Server]]

## Was ist eine Stub-Zone?

Kopie einer Zone, enthält NS, SOA und „Glue Host“- Einträge.

Nicht autorisierend.

## Was sind die DNS-Domänen?

1. Root-Domain ( . )

2. First-Level-Domain ( de )

3. Second-Level Domain ( example )l

## Was ist ein SAM?

Security Accounts Manager

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

3. **[[AD]] FS**       (Active Directory Federation Services) – Sichere Identitätsverbund

Authentifizierung über Grenzen

4. **AD RMS**   (Active Directory Rights Management Services) – Dokumentenschutz

und Zugriffskontrolle

5.**AD LDS**     (Active Directory Lightweight Directory Services) – Leichtgewichtige

Verzeichnisdatenbank ohne AD DS

## Was bedeutet UPN?

User Principal Name

Aktueller Name für das einloggen. Z.B. [Administrator@example.com](mailto:Administrator@example.com)
