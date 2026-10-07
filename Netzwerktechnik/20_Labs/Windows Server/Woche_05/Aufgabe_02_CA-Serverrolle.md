# 🔧 Aufgabe 02: CA-Serverrolle installieren und konfigurieren

**Modul:** 2 – Zertifikate & [[PKI]]  
**Woche:** 05 (Dienstag)  
**Dauer:** 60 Minuten  
**Schwierigkeit:** ⭐⭐ Fortgeschrittene  
**Maschinen:** EXA-DC01, EXA-SUB-CA01, EXA-CA01  

---

## 🎯 Lernziel dieser Aufgabe

Nach dieser Aufgabe kannst du:
- ✅ Standalone Root [[CA]] (offline) installieren (EXA-SUB-CA01)
- ✅ Enterprise Subordinate CA (online) installieren (EXA-CA01)
- ✅ CA-Hierarchie aufbauen (Root signiert Sub)
- ✅ Zertifikate im Certificate Manager (certmgr.msc) inspizieren
- ✅ PowerShell zur CA-Verwaltung einsetzen
- ✅ Snapshot erstellen (Backup-Punkt)

---

## ✅ Checkliste (zum Abhaken)

### **Vorbereitung**
- [ ] VMs hochgefahren: EXA-DC01, EXA-SUB-CA01, EXA-CA01
- [ ] Snapshot erstellt: `Snapshot_Woche05_Start`
- [ ] Netzwerk getestet: `ping exa-dc01.example.com`

### **Schritt 1: Root CA (EXA-SUB-CA01) installieren**
- [ ] [[AD CS]] Rolle installiert
- [ ] Standalone Root CA konfiguriert
- [ ] CA-Zertifikat exportiert (für Sub-CA)
- [ ] Snapshot: `Snapshot_Woche05_RootCA-Ready`

### **Schritt 2: Enterprise CA (EXA-CA01) installieren**
- [ ] [[AD]] CS Rolle installiert
- [ ] Enterprise Subordinate CA konfiguriert
- [ ] Certificate Request signiert von Root
- [ ] Zertifikat importiert
- [ ] CA läuft und vertraut auf Root
- [ ] Snapshot: `Snapshot_Woche05_CA-Ready`

### **Validierung**
- [ ] `certmgr.msc` → Root-Zertifikat in "Trusted Root..."
- [ ] `certutil.exe -CAInfo` → CA läuft korrekt
- [ ] Trust-Chain validiert mit PowerShell
- [ ] Beide Snapshots erstellt ✅

---

## 📚 Wissens-Schnellauffrischung

**Aus Aufgabe 01 (nötig zum Verstehen):**

```
ROOT CA (Standalone, Offline)
├─ Selbstsigniert (Subject = Issuer)
├─ Höchste Ebene der Hierarchie
├─ Private-Key darf NICHT raus
└─ Lädt nach Initial-Setup OFFLINE

SUBORDINATE CA (Enterprise, Online)
├─ Signiert von Root (Subject ≠ Issuer)
├─ Stellt Zertifikate für Server/Clients aus
├─ In Active Directory integriert
└─ Bleibt ONLINE
```

---

## 🔧 SCHRITT 1: Root CA (EXA-SUB-CA01) installieren

### **Schritt 1.1: VM vorbereiten (EXA-SUB-CA01)**

**Auf EXA-SUB-CA01 (HyperV Console):**

1. **Windows Server 2022 hochfahren**
   ```powershell
   # VM braucht ~5 Minuten zum Starten
   # Warten bis Desktop sichtbar
   ```

2. **Netzwerk überprüfen**
   ```powershell
   # PowerShell Admin öffnen (Win+X → A)
   ipconfig
   
   # SOLLTE SEIN:
   # IPv4-Adresse: 192.168.1.211
   # Gateway: 192.168.1.1
   # DNS: 192.168.1.200 (EXA-DC01)
   
   # TESTEN:
   ping exa-dc01.example.com
   # SOLLTE ANTWORTEN (4 packets)
   ```

3. **Hostname überprüfen**
   ```powershell
   hostname
   # SOLLTE SEIN: EXA-SUB-CA01
   ```

---

### **Schritt 1.2: AD CS Rolle installieren (Standalone CA)**

**Auf EXA-SUB-CA01 – PowerShell Admin:**

```powershell
# SCHRITT 1: AD CS Feature installieren
Add-WindowsFeature Adcs-Cert-Authority -IncludeManagementTools

# Warte auf Completion (ca. 2 Minuten)
# Output sollte "Success = True" zeigen
```

**Erwartetes Output:**
```
FeatureResult : Success
RestartNeeded : No
```

---

### **Schritt 1.3: Root CA konfigurieren (mit GUI)**

**Auf EXA-SUB-CA01 – Server Manager öffnen:**

```
1. Server Manager öffnen (Falls nicht offen)
2. Oben rechts: "Notifications" (Flag-Icon)
3. Gelblich Banner: "Configure Active Directory Certificate Services"
   → Klick auf "Configure Active Directory..."
```

**Wizard öffnet sich: "AD CS Configuration"**

```
[SCHRITT 1]
Select credential to use for configuration:
├─ Auswahl: "Use existing account" (default)
└─ Account sollte: Administrator (aktuell) sein
→ NEXT

[SCHRITT 2]
Select role service to configure:
├─ ✅ Certification Authority (CHECKMARK setzen)
└─ Alle anderen: NICHT checken
→ NEXT

[SCHRITT 3]
Specify the type of the CA:
├─ Auswahl: "Standalone CA" (WICHTIG – nicht Enterprise!)
└─ Sub-type: "Root CA"
→ NEXT

[SCHRITT 4]
Create a new private key:
├─ Auswahl: "Create a new private key"
├─ Encryption: RSA
├─ Key Length: 2048 bits
└─ Hash algorithm: SHA256
→ NEXT

[SCHRITT 5]
Configure CA name:
├─ Common Name (CN): Example.com Root CA
├─ Distinguished Name Suffix (DN):
│  DC=example,DC=com
└─ ODER: Lass vorausgefüllt (sollte auto-generiert sein)
→ NEXT

[SCHRITT 6]
Validity Period:
├─ Years: 10 (oder 5 je nach Wunsch)
└─ Root CAs sollten lange gültig sein
→ NEXT

[SCHRITT 7]
Review Settings:
├─ Überprüfe: CN=Example.com Root CA
├─ Type: Standalone Root CA
└─ Key Length: 2048, SHA256
→ CONFIGURE

# Warte 2-5 Minuten während konfiguriert wird...
# Success-Dialog sollte erscheinen
```

---

### **Schritt 1.4: Root CA überprüfen**

**Auf EXA-SUB-CA01 – PowerShell Admin:**

```powershell
# Überprüfe CA Status
Get-ChildItem Cert:\LocalMachine\CA

# Sollte etwa zeigen:
# Thumbprint              Subject
# ──────────────────────  ─────────────────────
# ABC123...               CN=Example.com Root CA

# Überprüfe ob zertifiziert
certutil.exe -CAInfo

# Output sollte enthalten:
# CN=Example.com Root CA
# Status: Online
```

---

### **Schritt 1.5: Root-Zertifikat exportieren (für Sub-CA)**

**Auf EXA-SUB-CA01 – PowerShell Admin:**

```powershell
# Root CA Zertifikat in Datei exportieren
# Diese Datei braucht Sub-CA später zum Signieren

$RootCert = Get-ChildItem Cert:\LocalMachine\CA | Where-Object {$_.Subject -like "*Root*"}
Export-Certificate -Cert $RootCert -FilePath "C:\RootCA.crt" -Type CERT

# Überprüfe Export
dir C:\RootCA.crt

# Output sollte zeigen:
# -a---- Date    Time 1234 C:\RootCA.crt
```

---

### **Schritt 1.6: Root CA OFFLINE nehmen**

**Auf EXA-SUB-CA01 – HyperV Console:**

```
⚠️ WICHTIG: Ab jetzt ist diese VM OFFLINE!

1. Herunterfahren (sauber):
   → shutdown /s /t 60
   
2. In HyperV: 
   → VM EXA-SUB-CA01 ausschalten
   
3. NETZWERK-KABEL TRENNEN (Simulation):
   → HyperV Manager → Settings EXA-SUB-CA01
   → Network Adapter
   → Nicht verbunden (NOT CONNECTED)
   
⚠️ Hinweis: Root CA braucht jetzt nur noch bei der
   Sub-CA Zertifizierung online zu gehen!
```

**Snapshot erstellen:**
```powershell
# AUF HOST (HyperV PowerShell Admin):
Checkpoint-VM -Name "EXA-SUB-CA01" -SnapshotName "Woche05_RootCA-Ready"

# Überprüfe Snapshot
Get-VMSnapshot -VMName "EXA-SUB-CA01"
```

---

## 🔧 SCHRITT 2: Enterprise Subordinate CA (EXA-CA01) installieren

### **Schritt 2.1: VM vorbereiten (EXA-CA01)**

**Auf EXA-CA01 (HyperV Console):**

1. **Windows Server 2022 hochfahren**
   ```powershell
   # Warten bis Desktop sichtbar (~5 Min)
   ```

2. **AD Domain beitreten (falls nicht schon)**
   ```powershell
   # PowerShell Admin
   Add-Computer -DomainName example.com -Restart
   
   # Login mit Administrator Credentials
   # VM startet neu
   ```

3. **Netzwerk + Namensprüfung**
   ```powershell
   hostname    # SOLLTE: EXA-CA01
   ipconfig    # SOLLTE: 192.168.1.210
   ping exa-dc01.example.com  # SOLLTE ANTWORTEN
   ```

---

### **Schritt 2.2: AD CS Rolle installieren (Enterprise CA)**

**Auf EXA-CA01 – PowerShell Admin:**

```powershell
# Installiere AD CS Feature
Add-WindowsFeature Adcs-Cert-Authority -IncludeManagementTools

# Warte ~2 Minuten auf "Success = True"
```

---

### **Schritt 2.3: Enterprise CA konfigurieren (mit GUI)**

**Auf EXA-CA01 – Server Manager:**

```
1. Server Manager öffnen
2. Notifications → Configure Active Directory Certificate Services
3. Wizard "AD CS Configuration" öffnet sich:
```

**Wizard-Schritte:**

```
[SCHRITT 1]
Select credential:
├─ "Use existing account" (Administrator)
→ NEXT

[SCHRITT 2]
Select role service:
├─ ✅ Certification Authority (CHECKMARK)
└─ Andere: nicht checken
→ NEXT

[SCHRITT 3]
Specify the type of the CA:
├─ Auswahl: "Enterprise CA" (WICHTIG!)
├─ Sub-type: "Subordinate CA" (WICHTIG!)
└─ (NICHT "Root CA"!)
→ NEXT

[SCHRITT 4]
Create a new private key OR use existing:
├─ Auswahl: "Create a new private key"
├─ Encryption: RSA
├─ Key Length: 2048 bits
└─ Hash: SHA256
→ NEXT

[SCHRITT 5]
Configure CA name:
├─ Common Name: Example.com Enterprise CA
└─ Distinguished Name: CN=Example.com Enterprise CA,DC=example,DC=com
→ NEXT

[SCHRITT 6]
Validity Period:
├─ Years: 5 (Sub-CAs können kürzer sein als Root)
→ NEXT

[SCHRITT 7]
Review settings:
├─ Typ: Enterprise Subordinate CA
└─ NEXT → wird Root-Zertifikat abfragen
```

**Wichtig: Der Wizard wartet jetzt auf Zertifikat von Root!**

---

### **Schritt 2.4: Certificate Signing Request (CSR) erstellen**

**Nachdem Wizard wartet (EXA-CA01):**

Der Wizard zeigt:
```
"Specify a parent CA to submit request to"
├─ Option 1: "Parent CA computer name"
│  └─ Falls Root-CA online wäre → Direct connection
│
└─ Option 2: "Use existing CA certificate file"
   └─ Wir nutzen unsere exportierte RootCA.crt!
```

**Schritte:**

```
1. Klick "Browse..." (bei File option)
2. Navigiere zu C:\RootCA.crt (falls nicht auto-filled)
3. Öffne die Root-CA Zertifikat-Datei

# System erstellt CSR automatisch
# Output zeigt: "Certificate signing request created..."

→ NEXT
```

---

### **Schritt 2.5: CSR durch Root CA signieren lassen**

**Auf EXA-SUB-CA01 (Root CA – muss online gehen):**

```powershell
# Root CA wieder online nehmen

# 1. HyperV → EXA-SUB-CA01 Netzwerk verbinden
# 2. VM starten
# 3. Warten bis online

# PowerShell Admin auf EXA-SUB-CA01:
# CSR von Sub-CA braucht physisch kopiert zu werden

# Option A: Shared Folder (einfacher)
# Option B: Manueller Copy über Network
```

**[[CSR]] kopieren (Option A – Shared Folder):**

```powershell
# AUF EXA-DC01 (einfach zu bedienen):
# Shared Folder für Zertifikat-Austausch

# AUF EXA-CA01:
# CSR suchen
dir C:\Windows\System32\certsrv\*

# ODER über GUI:
# Certification Authority (certmgr.msc)
# → Requests Folder → finde den Request
```

**Signieren (Auf EXA-SUB-CA01):**

```powershell
# PowerShell Admin auf Root-CA Maschine:

# Öffne Certification Authority Console
# certmgr.msc oder:
# Administrative Tools → Certificate Authority

# Menü: Action → All Tasks → Issue Certificate
# Wähle den Request von EXA-CA01 aus
# → ISSUE

# Zertifikat wird signiert und ausgestellt
```

---

### **Schritt 2.6: Signiertes Zertifikat zurück zu Sub-CA kopieren**

```powershell
# AUF EXA-SUB-CA01:
# Exportiere das ausgestellte Zertifikat für EXA-CA01

# Öffne Certification Authority Console
# Issued Certificates → Finde Zertifikat für "Example.com Enterprise CA"
# → Rechtsklick → All Tasks → Export

# Speichern als: C:\SubCA.crt (oder SubCA.cer)
```

**Kopiere zurück zu EXA-CA01:**

```powershell
# Manuell über Shared Folder oder:
# copy \\exa-sub-ca01\c$\SubCA.crt C:\SubCA.crt
```

---

### **Schritt 2.7: Zertifikat in Sub-CA importieren**

**Auf EXA-CA01 – PowerShell Admin:**

```powershell
# Wizard sollte noch warten
# Oder: Certification Authority Wizard erneut öffnen

# Zertifikat importieren:
Import-Certificate -FilePath "C:\SubCA.crt" -CertStoreLocation Cert:\LocalMachine\My

# Prüfung:
Get-ChildItem Cert:\LocalMachine\My

# Sollte neue CA zeigen:
# Thumbprint              Subject
# ──────────────────────  ─────────────────────
# XYZ789...               CN=Example.com Enterprise CA
```

**Wizard abschließen:**

```
→ NEXT im Wizard
→ Certificate import sollte auto-erkannt werden
→ CONFIGURE

# Warte 2-5 Minuten
# Success-Meldung sollte erscheinen
```

---

## 🔍 Validierung: Funktioniert's?

### **Test 1: CA-Status überprüfen**

**Auf EXA-CA01 – PowerShell Admin:**

```powershell
# Zertifikat ansehen
Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -like "*Enterprise*"}

# SOLLTE ZEIGEN:
# Thumbprint              Subject
# ──────────────────────  ──────────────────────────────
# ABC123...               CN=Example.com Enterprise CA
```

---

### **Test 2: CA-Service läuft**

```powershell
# Prüfe ob CA-Service läuft
Get-Service -Name "CertSvc"

# SOLLTE ZEIGEN:
# Status   Name             DisplayName
# ──────   ────             ───────────
# Running  CertSvc          Active Directory Certificate Services
```

---

### **Test 3: Trust-Chain validieren**

**Auf EXA-CA01 – PowerShell Admin:**

```powershell
# Zertifikat Details ansehen
$Cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -like "*Enterprise*"}

# Issuer anzeigen (sollte Root CA sein)
$Cert | Select-Object Subject, Issuer

# OUTPUT SOLLTE SEIN:
# Subject: CN=Example.com Enterprise CA
# Issuer: CN=Example.com Root CA
```

**Wenn Issuer ≠ Root CA:**
- ❌ Zertifikat falsch signiert
- 🔧 Gehe zurück zu Schritt 2.6

---

### **Test 4: CA-Info Bericht**

```powershell
# Detaillierte CA-Informationen
certutil.exe -CAInfo

# SOLLTE ZEIGEN:
# Config: example.com\Example.com Enterprise CA
# Database location: C:\Windows\System32\CertLog
# CA Status: Online
# CA Certificate Expiration: [Datum 5 Jahre...]
```

---

## 📸 Snapshots erstellen

**Nach erfolgreich bestandenen Tests:**

**Auf HyperV Host (PowerShell Admin):**

```powershell
# Snapshot von Sub-CA (wenn nicht schon)
Checkpoint-VM -Name "EXA-SUB-CA01" -SnapshotName "Woche05_RootCA-Ready"

# Snapshot von Enterprise CA
Checkpoint-VM -Name "EXA-CA01" -SnapshotName "Woche05_CA-Ready"

# Überprüfen
Get-VMSnapshot -VMName "EXA-CA01"
Get-VMSnapshot -VMName "EXA-SUB-CA01"

# SOLLTE BEIDE Snapshots zeigen ✅
```

---

## ⚠️ Häufige Fehler & Lösungen

| Fehler | Lösung |
|--------|--------|
| **"Cannot find file C:\RootCA.crt"** | Root CA noch nicht exportiert (Schritt 1.5) oder auf falscher Maschine |
| **"Certificate Signing Request failed"** | Root CA ist offline → muss online gehen (Schritt 2.5) |
| **"CertSvc Service won't start"** | Active Directory Domäne nicht erreichbar → DC01 offline? Ping DC01 |
| **"Issuer ≠ Root CA"** | Falsches Zertifikat signiert → Schritt 2.6 wiederholen |
| **"Sub-CA noch nicht Enterprise-CA"** | Wizard-Auswahl war "Standalone" statt "Enterprise" → Rolle deinstallieren + neu |

---

## 🔗 Verwandte Inhalte

- Lösung_02_CA-Serverrolle *(⏳ noch nicht erstellt)*
- [[PKI und Zertifikatdienste]] (Theorie kompakt)
- [[VM-Infrastruktur]] (Lab Referenz)
- [[_MOC_Wochenplan]] (Wochenübersicht)
- [[Woche_05/Klausur_Zertifikate_120Min]] (Wochenende)

---

**Viel Erfolg beim Aufbau deiner PKI!** 🚀  
Das ist der Knackpunkt – ab hier geht's vorwärts!

## 📄 Unterlagen
- Schulübung: [[Uebung_Zertifizierungsstellen_installieren.pdf#page=1|CA installieren (Stamm + Sub-CA)]] · [[Uebung_Zertifizierungsstellen_installieren.pdf#page=2|Eigenständige CA + Webregistrierung]] · [[Uebung_Zertifizierungsstellen_installieren.pdf#page=3|CDP/AIA]]
- Folien: [[AD-Zertifikatdienste.pdf#page=16|CA installieren]] · [[AD-Zertifikatdienste.pdf#page=18|Zertifikatvorlagen]] · [[AD-Zertifikatdienste.pdf#page=21|Autoenrollment]]
- Buch 70-742: [[70-742_Server2016_Identitaet.pdf#page=297|Eigenständige CA]] · [[70-742_Server2016_Identitaet.pdf#page=306|Unternehmens-CA]] · [[70-742_Server2016_Identitaet.pdf#page=307|Offline-CA]] · [[70-742_Server2016_Identitaet.pdf#page=331|CA sichern]]
