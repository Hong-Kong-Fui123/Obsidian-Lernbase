# 📝 Klausur: Zertifikate & PKI (120 Minuten)

**Modul:** 2 – Zertifikate & [[PKI]]  
**Woche:** 05 (Samstag-Sonntag)  
**Dauer:** 120 Minuten  
**Schwierigkeit:** ⭐⭐⭐ Prüfungslevel  
**Szenario:** Du bist neuer IT-Admin bei "TechCorp"

---

## 🎯 Szenario

Du wurdest gerade als **IT-Administrator** bei der Firma **TechCorp GmbH** eingestellt. Das Unternehmen hat:
- 50 Mitarbeiter
- Windows-basierte Infrastruktur
- Bestehende Domain: `techcorp.local`
- Bisherige [[CA]]-Infrastruktur: **KEINE** (Selbstsignierte Zertifikate überall)

**Dein Task:** Eine produktive PKI aufbauen.

---

## 📋 AUFGABEN (120 Min gesamt)

### **AUFGABE 1: PKI-Planung & Dokumentation (40 Min)**

**Situation:**
Der Geschäftsführer fragt: *"Wir brauchen sichere Zertifikate. Wie machst du das? Was brauchst du?"*

**Deine Aufgaben:**

1. **Zeichne die CA-Hierarchie für TechCorp** (zeichnen auf Papier/Paint/Obsidian)
   - Wie heißt die Root CA?
   - Wie heißt die Subordinate CA?
   - Welche Server/Clients brauchen Zertifikate?

2. **Schreibe einen kurzen Plan (max. 1 Seite):**
   ```
   TECHCORP PKI-INFRASTRUKTUR
   
   Hierarchie:
   - Root CA: [Name]
   - Subordinate CA: [Name]
   
   Sicherheitsmassnahmen:
   - Root CA [online/offline]? Begründung: ...
   - Sub CA [online/offline]? Begründung: ...
   
   Server die Zertifikate brauchen:
   - Web Server (IIS)
   - Mail Server
   - RDP Gateway
   - [weitere...]
   
   Timeline:
   - Tag 1: [Schritt]
   - Tag 2: [Schritt]
   - ...
   ```

3. **Sicherheits-Fragen beantworten:**
   - a) Was passiert wenn Root gehackt wird?
   - b) Was passiert wenn Sub gehackt wird?
   - c) Wie verhindert man das?

---

### **AUFGABE 2: CA-Infrastruktur aufbauen (40 Min)**

**Du hast jetzt Zugriff auf:**
- EXA-DC01 (Domain Controller)
- EXA-SUB-CA01 (für Root CA)
- EXA-CA01 (für Sub CA)

**Praktische Aufgaben:**

1. **Root CA installieren (auf EXA-SUB-CA01):**
   - [ ] [[AD CS]] Rolle installiert?
   - [ ] Standalone CA?
   - [ ] Root CA?
   - [ ] Zertifikat exportiert für Sub-CA?
   - [ ] Snapshot erstellt?

2. **Enterprise Sub-CA installieren (auf EXA-CA01):**
   - [ ] In Domain beigetreten (techcorp.local)?
   - [ ] [[AD]] CS Rolle installiert?
   - [ ] Enterprise CA?
   - [ ] Subordinate CA?
   - [ ] [[CSR]] signiert von Root?
   - [ ] Zertifikat importiert?
   - [ ] CA läuft?

3. **Validierung (PowerShell):**
   ```powershell
   # Schreib die Commands auf, die du ausführst:
   
   # Test 1: Sub-CA Zertifikat anzeigen
   [COMMAND]: ________________
   [RESULT]: CN=Example... Issuer=CN=Root...
   
   # Test 2: CA Service läuft?
   [COMMAND]: ________________
   [RESULT]: Status Running
   
   # Test 3: Vertrauen-Kette validieren?
   [COMMAND]: ________________
   [RESULT]: Trust chain valid
   ```

---

### **AUFGABE 3: Troubleshooting-Szenario (40 Min)**

**Problem:** Ein Mitarbeiter meldet:

> "Wir haben einen neuen Webserver (EXA-WEB01). Ich habe ein Zertifikat von der neuen Enterprise-CA installiert. Aber der Browser sagt: *'Untrusted Certificate Authority'* – warum?"

**Deine Aufgaben (Fehlersuche):**

1. **Diagnose durchführen:**
   - [ ] Zertifikat Details überprüfen (certmgr.msc)
   - [ ] Trust-Chain überprüfen
   - [ ] Root-Zertifikat in Browser Trust Store?

2. **Mögliche Fehlerquellen identifizieren:**
   ```
   FEHLER A: Root-Zertifikat nicht im Browser
   └─ Lösung: _________________
   
   FEHLER B: Zertifikat falsch signiert
   └─ Lösung: _________________
   
   FEHLER C: Sub-CA nicht im Zertifikat-Chain
   └─ Lösung: _________________
   
   WELCHER FEHLER IST WAHRSCHEINLICH? WARUM?
   ```

3. **Lösung implementieren:**
   - Schreib auf, wie du das beheben würdest
   - Welcher PowerShell-Command wäre nötig?
   - Welche [[GUI]]-Schritte?

4. **Zertifikat validieren:**
   ```powershell
   # Schreib hier den PowerShell-Command:
   # Um zu überprüfen, dass der Browser jetzt vertraut
   
   [COMMAND]: _________________
   [ERWARTETES RESULT]: Trust chain valid ✅
   ```

---

## 📊 Bewertungs-Kriterien

| Kriterium | Max Points | Dein Score |
|-----------|-----------|-----------|
| **AUFGABE 1** | 40 | / 40 |
| - PKI-Hierarchie korrekt | 15 | / 15 |
| - Plan nachvollziehbar | 15 | / 15 |
| - Sicherheits-Antworten | 10 | / 10 |
| **AUFGABE 2** | 40 | / 40 |
| - Root CA korrekt installiert | 15 | / 15 |
| - Sub-CA korrekt installiert | 15 | / 15 |
| - Validierungs-Tests bestanden | 10 | / 10 |
| **AUFGABE 3** | 20 | / 20 |
| - Fehler identifiziert | 10 | / 20 |
| - Lösung nachvollziehbar | 10 | / 10 |
| **GESAMT** | 100 | / 100 |

**Bestanden:** ≥ 60 Punkte  
**Gut:** ≥ 80 Punkte  
**Sehr Gut:** ≥ 90 Punkte

---

## ⏱️ Zeitplan

| Zeit | Aufgabe | Status |
|------|---------|--------|
| 0:00 - 0:05 | Aufgabe lesen | 📖 |
| 0:05 - 0:45 | **AUFGABE 1** | 🎯 (40 Min) |
| 0:45 - 1:25 | **AUFGABE 2** | 🔧 (40 Min) |
| 1:25 - 2:05 | **AUFGABE 3** | 🔍 (40 Min) |
| 2:05 - 2:10 | Abgabe + Review | ✅ |

---

## 📝 Abgabe-Format

**Erstelle eine Datei: `Klausur_Lösung.md` in Obsidian**

```markdown
# Klausur-Lösung: Woche 05

## AUFGABE 1: PKI-Planung

### Hierarchie-Zeichnung:
[Hier deine Zeichnung oder Text-Diagramm]

### Plan:
[Dein geschriebener Plan]

### Sicherheits-Fragen:
- a) Root gehackt: ...
- b) Sub gehackt: ...
- c) Prävention: ...

## AUFGABE 2: CA-Installation

### Root CA Schritte:
[Aufgelistet was du gemacht hast]

### Sub-CA Schritte:
[Aufgelistet was du gemacht hast]

### Validierungs-Ergebnisse:
[Test 1 Result]
[Test 2 Result]
[Test 3 Result]

## AUFGABE 3: Troubleshooting

### Fehleranalyse:
[Deine Diagnose]

### Fehlerquellen:
[Mögliche Fehler mit Lösungen]

### Implementierung:
[Deine Lösungsschritte]
```

---

## 💡 Tipps

- ✅ Nutze deine Notizen von Aufgabe 01 + 02
- ✅ Lese die Fehlerquellen mehrfach
- ✅ Schreib PowerShell-Commands auf
- ⚠️ Zeit managen – 40 Min pro Aufgabe
- 🔧 Bei Aufgabe 2: Nutze Snapshots (zurücksetzen, wenn Fehler)

---

## 🔗 Resourcen

- [[Aufgabe_01_PKI-Grundlagen]] – Theorie-Fundament
- [[Woche_05/Aufgabe_02_CA-Serverrolle]] – Praktische Schritte
- [[Lösung_01_PKI-Grundlagen]] – Falls unsicher bei Konzepten
- Lösung_02_CA-Serverrolle *(⏳ noch nicht erstellt)* – Falls unsicher bei Schritten
- [[PKI und Zertifikatdienste]] – Theorie kompakt
- Prüfungsfragen: [[AD-CS_20_Pruefungsfragen.pdf#page=1|AD CS 20]] · [[AD-CS_20_Pruefungsfragen.pdf#page=8|Lösungen]]

---

## ✅ Fertig?

Nach dieser Klausur:
- ✅ Du verstehst PKI-Hierarchie praktisch
- ✅ Du kannst Root + Sub-CA aufbauen
- ✅ Du kannst Fehler in der Infrastruktur beheben
- ✅ Du bist bereit für **Woche 06: Zertifikat-Ausrollung**

---

**Viel Erfolg! Schaff's!** 🎓
