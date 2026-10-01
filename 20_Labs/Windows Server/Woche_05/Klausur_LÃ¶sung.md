# ✅ Klausur-Lösung: Woche 05 Zertifikate & PKI

---

## 📝 AUFGABE 1: PKI-Planung (40 Min) – BEISPIEL-LÖSUNG

### **Hierarchie-Zeichnung (TechCorp)**

```
TECHCORP PKI HIERARCHIE

┌──────────────────────────────────────┐
│   ROOT CA (Offline)                  │
│   CN=TechCorp Root CA                │
│   - Selbstsigniert                   │
│   - Gültig: 10 Jahre                 │
│   - Storage: Tresor / HSM             │
└────────────────┬─────────────────────┘
                 │
                 │ signiert
                 ▼
┌──────────────────────────────────────┐
│   SUBORDINATE CA (Online)            │
│   CN=TechCorp Enterprise CA          │
│   - Enterprise CA mit AD              │
│   - Gültig: 5 Jahre                  │
│   - Läuft auf: SERVER-CA01           │
└────────────────┬─────────────────────┘
                 │
        ┌────────┼────────┐
        │        │        │
        ▼        ▼        ▼
    SERVER   CLIENT    CODE-SIGN
    CERTS    CERTS     CERTS
    (IIS,    (RDP,     (App)
     Mail,   SmartCard)
     RDP)
```

### **Kurz-Plan (TechCorp PKI)**

```
TECHCORP PKI-INFRASTRUKTUR

1. HIERARCHIE
   - Root CA (Offline): CN=TechCorp Root CA
     └─ Gültig 10 Jahre, RSA 2048, SHA256
   - Sub CA (Online): CN=TechCorp Enterprise CA
     └─ Gültig 5 Jahre, in AD integriert

2. SICHERHEITS-MASSNAHMEN
   - Root CA OFFLINE
     └─ Schutz vor Hacking
     └─ Isolation auf separater VM
     └─ Nur bei Sub-Zertifizierung online
   
   - Sub CA ONLINE (aber gehärtet)
     └─ Firewall Rules (nur CSR/Ausstellung)
     └─ Minimum Privileges (Service Account)
     └─ CRL aktualisiert täglich
   
   - Certificate Revocation:
     └─ CRL Distribution Point (CDP)
     └─ Browser cached CRL (~24h)
     └─ OCSP für Real-Time Check

3. SERVER DIE ZERTIFIKATE BRAUCHEN
   - IIS Web Server (HTTPS)
   - Mail Server (SMTP/IMAP TLS)
   - RDP Gateway (TLS Binding)
   - VPN Server
   - Drucker (IPP)

4. TIMELINE
   - Tag 1: Root-CA Installation + exportieren
   - Tag 2: Sub-CA Installation + CSR signieren
   - Tag 3: Auto-Enroll via GPO konfigurieren
   - Tag 4: Server-Zertifikate ausstellen + binden
   - Tag 5: Testing + Rollout
```

### **Sicherheits-Fragen: Antworten**

**Q: Was passiert wenn Root gehackt wird?**

A: Desaster!
- Attacker kann Fake-Root-Zertifikate ausstellen
- Browser vertraut automatisch (Root in Trust Store)
- Attacker kann JEDES Zertifikat fälschen
- Workaround: Browser müssen Root aus Trust Store entfernen (global koordiniert)
- Lösung: Darum Root OFFLINE halten!

**Q: Was passiert wenn Sub gehackt wird?**

A: Limitierter Schaden:
- Attacker kann nur Zertifikate von Sub-CA ausstellen
- Browser validiert: Sub signiert diesen Fake → Issuer = Sub
- Browser prüft: Ist Sub selbst noch vertrauenswürdig? ([[CRL]]-Check)
- Sub-CA wird widerrufen → Root signiert neue Sub-CA
- ~24h Ausfall für Zertifikat-Ausstellung

**Q: Wie verhindert man das?**

A: Multi-Layer Security:
- Root [[CA]] komplett offline (kein Netzwerk)
- Root CA auf separater Hardware ([[HSM]] oder virtuell isoliert)
- Sub CA gehärtet: Firewall, minimale Berechtigungen
- Monitoring: CA-Logs überwachen
- Backup: Root-Private-Key verschlüsselt lagern
- CRL/[[OCSP]]: Revocation zeitnah

---

## 🔧 AUFGABE 2: CA-Installation (40 Min) – MUSTER-DURCHFÜHRUNG

### **Root CA (EXA-SUB-CA01) installieren**

**Schritte die du gemacht hast (Checkliste):**

- ✅ [[VM]] EXA-SUB-CA01 gestartet
- ✅ Netzwerk getestet: `ping exa-dc01.example.com`
- ✅ [[AD CS]] Feature installiert: `Add-WindowsFeature Adcs-Cert-Authority`
- ✅ Wizard: Serverrole → Certification Authority (checkmark)
- ✅ Wizard: Type → **Standalone CA** (nicht Enterprise!)
- ✅ Wizard: Sub-type → **Root CA**
- ✅ Wizard: Encryption → [[RSA]], 2048-bit, SHA256
- ✅ Wizard: CA Name → CN=Example.com Root CA
- ✅ Wizard: Validity → 10 Jahre
- ✅ Root-Zertifikat exportiert: `Export-Certificate -Cert $RootCert -FilePath "C:\RootCA.crt"`
- ✅ Snapshot erstellt: `Checkpoint-VM -Name "EXA-SUB-CA01" -SnapshotName "Woche05_RootCA-Ready"`
- ✅ VM offline genommen (Netzwerk-Adapter deaktiviert)

### **Enterprise Sub-CA (EXA-CA01) installieren**

**Schritte die du gemacht hast:**

- ✅ VM EXA-CA01 gestartet
- ✅ Domain beigetreten: `Add-Computer -DomainName example.com -Restart`
- ✅ Netzwerk getestet: `ping exa-dc01.example.com`
- ✅ [[AD]] CS Feature installiert: `Add-WindowsFeature Adcs-Cert-Authority`
- ✅ Wizard: Role → Certification Authority (checkmark)
- ✅ Wizard: Type → **Enterprise CA** (WICHTIG!)
- ✅ Wizard: Sub-type → **Subordinate CA**
- ✅ Wizard: Encryption → RSA 2048, SHA256
- ✅ Wizard: CA Name → CN=Example.com Enterprise CA
- ✅ Wizard: Validity → 5 Jahre
- ✅ Wizard: Root-Zertifikat angeben → C:\RootCA.crt
- ✅ [[CSR]] von Root signieren lassen (CSR kopieren → Root online → signieren → zurück)
- ✅ Signiertes Zertifikat importieren: `Import-Certificate -FilePath "C:\SubCA.crt" -CertStoreLocation Cert:\LocalMachine\My`
- ✅ Wizard abschließen
- ✅ Snapshot erstellt: `Checkpoint-VM -Name "EXA-CA01" -SnapshotName "Woche05_CA-Ready"`

### **Validierungs-Tests (PowerShell)**

**Test 1: Sub-CA Zertifikat anzeigen**
```powershell
# COMMAND:
Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -like "*Enterprise*"}

# RESULT:
Thumbprint              Subject
───────────────────     ──────────────────────────────────
ABC123DEF456...         CN=Example.com Enterprise CA

# ERGEBNIS: ✅ Zertifikat vorhanden mit korrektem Subject
```

**Test 2: CA Service läuft?**
```powershell
# COMMAND:
Get-Service -Name "CertSvc"

# RESULT:
Status   Name      DisplayName
───────  ────      ───────────
Running  CertSvc   Active Directory Certificate Services

# ERGEBNIS: ✅ Service läuft
```

**Test 3: Vertrauen-Kette validieren**
```powershell
# COMMAND:
$Cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -like "*Enterprise*"}
$Cert | Select-Object Subject, Issuer

# RESULT:
Subject: CN=Example.com Enterprise CA
Issuer:  CN=Example.com Root CA

# ERGEBNIS: ✅ Sub-CA ist von Root signiert (Issuer = Root)
```

**Test 4: CA Info-Bericht**
```powershell
# COMMAND:
certutil.exe -CAInfo

# RESULT (Auszug):
Config: example.com\Example.com Enterprise CA
Database location: C:\Windows\System32\CertLog
CA Status: Online
CA Certificate Expiration: 01.01.2030

# ERGEBNIS: ✅ CA läuft und ist konfiguriert
```

---

## 🔍 AUFGABE 3: Troubleshooting (40 Min) – LÖSUNGSWEG

### **Problem-Analyse**

Browser sagt: **"Untrusted Certificate Authority"** für exa-web01.example.com

**Das bedeutet:** Browser kennt/vertraut der CA nicht, die das Zertifikat ausgestellt hat.

### **Fehlerquellen (Diagnose-Reihenfolge)**

**FEHLER A: Root-Zertifikat nicht im Browser Trust Store** (70% Wahrscheinlichkeit)

```
Symptom: 
- Browser zeigt "Untrusted CA"
- Aber: Zertifikat ist von korrekter CA signiert

Grund:
- Browser kennt die Root-CA nicht
- Root-Zertifikat ist nicht in "Trusted Root CAs" im Browser

Lösung:
1. Root-Zertifikat exportieren (von Root-CA oder irgendwoher)
2. Manuell zu Browser hinzufügen:
   - Chrome: Settings → Privacy → Manage Certificates
   - Firefox: Preferences → Certificates
   - Windows: certmgr.msc (Local Machine → Trusted Root)
3. Zertifikat importieren + als "Trust" markieren
4. Browser neu starten
5. Test: https://exa-web01.example.com → sollte grün sein ✅

PowerShell (um zu überprüfen, ob Root importiert):
certmgr.msc
→ Gehe zu: Certificates (Local Computer) → Trusted Root Certificate Authorities
→ Suche: "Example.com Root CA"
→ Falls nicht da: Manuell importieren!
```

**FEHLER B: Zertifikat falsch signiert** (20% Wahrscheinlichkeit)

```
Symptom:
- Zertifikat existiert
- Aber Issuer ≠ korrekter CA

Grund:
- Sub-CA wurde falsch konfiguriert
- ODER: CSR wurde von falscher CA signiert

Test:
certmgr.msc → das Web-Zertifikat anschauen
→ Double-Click → Details Tab
→ Issuer: sollte "CN=Example.com Enterprise CA" sein
→ Falls nicht: Falsches Zertifikat wurde gebunden

Lösung:
1. Neues CSR erstellen (auf EXA-WEB01)
2. Von korrekte Sub-CA signieren lassen (EXA-CA01)
3. Signiertes Zertifikat importieren
4. In IIS rebinden
```

**FEHLER C: Certificate Chain ist unvollständig** (10% Wahrscheinlichkeit)

```
Symptom:
- Browser kann Trust-Chain nicht validieren
- Selbst wenn Root bekannt ist

Grund:
- Intermediate CA Zertifikat fehlt
- Oder: Falscher Issuer in Chain

Test & Lösung:
PowerShell:
Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -like "*web*"}
$Cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($certfile)
$Cert.Verify()
→ Sollte True sein

Falls False:
- Sub-CA Zertifikat fehlt
- Importieren: 
  certutil.exe -addstore "AuthRoot" SubCA.crt
```

### **Wahrscheinlichste Lösung (Aufgabe 3)**

**Ist das Root-Zertifikat im Browser?**

```powershell
# Auf EXA-CA01 (oder irgendwoher):
# Root-Zertifikat holen und dem Browser zeigen

# SCHRITT 1: Root-CA Zertifikat exportieren (von Root-CA oder gespeichert)
dir C:\RootCA.crt

# SCHRITT 2: Zertifikat im Windows Import-Dialog hinzufügen
# certmgr.msc öffnen
# Trusted Root Cert. Auth. → Import → RootCA.crt wählen

# SCHRITT 3: Browser neuladen
# https://exa-web01.example.com → grüner Lock! ✅
```

### **Implementierungs-Schritte (für deine Lösung)**

1. **Diagnostiziere das Problem** (PowerShell + certmgr.msc)
   - Ist Root-Zertifikat im Trust Store?
   - Ist Issuer des Web-Zerts korrekt?
   - Ist Service läuft?

2. **Beherrsche die Fehlerquelle**
   - FEHLER A: Root zum Trust Store hinzufügen
   - FEHLER B: Zertifikat neu ausstellen
   - FEHLER C: Sub-CA Zertifikat hinzufügen

3. **Validiere die Lösung**
   ```powershell
   # PowerShell:
   $webcert = Get-Item Cert:\LocalMachine\WebHosting\*exa-web01*
   $webcert | Select-Object Subject, Issuer, Thumbprint
   
   # Issuer sollte sein: CN=Example.com Enterprise CA
   # Subject sollte sein: CN=exa-web01.example.com
   
   # Test im Browser:
   # https://exa-web01.example.com
   # Sollte GRÜNER LOCK anzeigen ✅
   ```

---

## 📊 Selbstbewertung

**Wie viele Punkte würdest du dir geben?**

| Aufgabe | Du (punkter) | Lösung (max) | Note |
|---------|------|--------|------|
| AUFGABE 1 | ? | 40 | ? |
| AUFGABE 2 | ? | 40 | ? |
| AUFGABE 3 | ? | 20 | ? |
| **TOTAL** | **?** | **100** | **?** |

**Bestanden:** ≥60 ✅
**Gut:** ≥80 ✅
**Sehr Gut:** ≥90 ✅✅

---

## 🚀 Nächste Woche (Woche 06)

**Wenn du diese Klausur bestanden hast** → Bereit für:

- ✅ Zertifikat-Ausrollung (Auto-Enroll via [[GPO]])
- ✅ Zertifikate in [[IIS]] binden ([[HTTPS]])
- ✅ Client-Zertifikate ([[RDP]], [[VPN]])
- ✅ Code-Signing Zertifikate

---

**Herzlichen Glückwunsch zur bestandenen Woche 05!** 🎓

[[_MOC_Wochenplan]] → nächste Woche starten
