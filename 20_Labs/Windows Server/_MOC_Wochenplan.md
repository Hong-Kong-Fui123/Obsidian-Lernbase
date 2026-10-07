# 📅 Wochenplan – Dein Lernfortschritt

**Status:** Modul 2 (Woche 05 startet JETZT)  
**Schulthema aktuell:** Zertifikate + [[GPO]]  
**Ziel:** Azure 802 vorbereitet + FiSi Server-Admin

---

## 📊 Modul-Übersicht

| Modul | Woche | Thema                       | Status          | Schulanbindung               |
| ----- | ----- | --------------------------- | --------------- | ---------------------------- |
| **1** | 01-04 | [[AD]] Grundlagen + Home-Ordner | ✅ Abgeschlossen | AD-Basics                    |
| **2** | 05-08 | Zertifikate & [[PKI]]           | 🔴 **JETZT**    | **Zertifikate (Schulthema)** |
| **3** | 09-12 | GPO Advanced + Security     | ⏳ Später        | GPO (parallel in Schule)     |

---

## 🎯 Modul 2: ZERTIFIKATE & PKI (Woche 05-08)

### **Woche 05 – PKI-Grundlagen & CA-Installation**

#### **Montag: Aufgabe 01** (60 Min) ⭐ Anfänger
📖 **[[Aufgabe_01_PKI-Grundlagen]]**

- PKI-Konzepte verstehen (asymmetrische Verschlüsselung)
- Certificate Authority Hierarchie
- Trust-Chain Modell
- Zertifikat-Komponenten (Subject, Issuer, Validity)

**Maschinen:** EXA-DC01 + EXA-SUB-CA01 (Theorie, keine Konfiguration)

---

#### **Dienstag: Aufgabe 02** (60 Min) ⭐⭐ Fortgeschrittene
📖 **[[Woche_05/Aufgabe_02_CA-Serverrolle]]**

- Serverrolle "Certification Authority" installieren
- Root [[CA]] (Offline) vs. Enterprise CA (Online)
- CA-Zertifikat erstellen
- Initial-Setup durchführen

**Maschinen:** 
- **EXA-SUB-CA01** (Offline Root CA bauen)
- **EXA-CA01** (Enterprise-CA für Ausrollung)

**Snapshot vorher:** `Snapshot_Clean` → `Snapshot_CA-Ready` (nachher)

---

#### **Mittwoch: Optional-Aufgabe** (60 Min) ⭐⭐
📖 **Aufgabe_03_CA-Troubleshooting** *(⏳ noch nicht erstellt)* (optional, wenn Zeit)

- Häufige CA-Fehler beheben
- Event Viewer analysieren
- CA-Zertifikat-Chain validieren

---

#### **Donnerstag: Wiederholung & Fehlersuche** (60 Min)
- Aufgabe 1 & 2 erneut durcharbeiten (ohne Notizen)
- Eigene Fehler dokumentieren → [[Fehlerlog Home-Lab]]
- Mit Lösungen abgleichen

---

#### **Freitag: Theorie-Recap** (45 Min) 🧠
📖 **Theorie-Zusammenfassung** *(⏳ noch nicht erstellt)* → bis dahin: [[PKI und Zertifikatdienste]]

- Schulbuch-Kapitel lesen: [[70-742_Server2016_Identitaet.pdf#page=291|Andrew Warren, 70-742 Kap. 4 AD CS]] · Folien [[AD-Zertifikatdienste.pdf|Zertifikate]]
- Eigene Notizen erstellen
- Konzepte mit deinem Lab verbinden

---

#### **Samstag-Sonntag: Klausur** (120 Min) ⭐⭐⭐
📖 **[[Woche_05/Klausur_Zertifikate_120Min]]**

- **Szenario:** Du bist neuer Server Admin in der Firma "TechCorp"
- **Aufgaben:** 
  1. (40 Min) PKI planen + dokumentieren
  2. (40 Min) CA-Hierarchie aufbauen
  3. (40 Min) Troubleshooting-Szenario
- **Abgabemarkt:** Klausur-Lösung vergleichen

---

### **Woche 06 – Zertifikat-Ausrollung** (wird später erstellt)

#### **Inhalte (Preview):**
- [[CSR]] (Certificate Signing Request) erstellen
- Zertifikate ausstellen
- Zertifikat in [[IIS]] bindet → EXA-WEB01
- Client-Zertifikate ([[RDP]], [[VPN]])
- Auto-Enrollment via GPO

---

### **Woche 07 – CRL & Zertifikat-Verwaltung** (wird später erstellt)

- Certificate Revocation List ([[CRL]])
- [[OCSP]] (Online Certificate Status Protocol)
- Expired Certificates handling
- Zertifikat-Erneuerung

---

### **Woche 08 – Klausurphase & Projekt** (wird später erstellt)

- Großprojekt: "Produktive PKI für TechCorp"
- Alle Konzepte zusammenbringen
- Dokumentation + Präsentation

---

## 🏗️ VM-Snapshot-Zeitleiste

| Snapshot | Zustand | Verwendung |
|----------|---------|------------|
| `Clean` | Netzwerk läuft, keine Config | Jede Übung von vorne |
| `AD-Ready` | AD läuft, OUs/User da | Bevor CA-Setup startet |
| `CA-Ready` | CA installiert + zertifiziert | Bevor Cert-Ausrollung |
| `Prod` | Alles läuft (IIS, [[SQL]], Clients bound) | Letzte Wochen |

---

## 📊 Fortschritts-Tracker

```
Woche 05 (PKI-Grundlagen)
├─ [ ] Mo: Aufgabe 01 ✅ Geplant
├─ [ ] Di: Aufgabe 02 ✅ Geplant
├─ [ ] Mi: Optional    ⏳ Wenn Zeit
├─ [ ] Do: Wiederhol.  ⏳ Wenn nötig
├─ [ ] Fr: Theorie     ⏳ Schulbuch
└─ [ ] Sa-So: Klausur  ⏳ Wochenende

Woche 06 (Cert-Ausrollung)
├─ [ ] Mo: Aufgabe 03  ⏳ Nächste Woche
├─ [ ] ...

Woche 07 (CRL & Verwaltung)
├─ [ ] ...

Woche 08 (Projekt-Phase)
├─ [ ] ...
```

---

## 🔗 Schnelllinks zu Inhalten

### **Aufgaben dieser Woche**
- [[Aufgabe_01_PKI-Grundlagen]]
- [[Woche_05/Aufgabe_02_CA-Serverrolle]]
- [[Woche_05/Klausur_Zertifikate_120Min]]

### **Lösungen dieser Woche**
- [[Woche_05/Lösung_01_PKI-Grundlagen]]
- Lösung_02_CA-Serverrolle *(⏳ noch nicht erstellt)*
- [[Woche_05/Klausur_Lösung]]

### **Referenzen**
- [[VM-Infrastruktur]] (dein Lab)
- [[VM-Infrastruktur#📸 Snapshot-Strategie|Snapshot-Strategie]] (Startzustände)
- [[PDF-Index]] (Schulunterlagen)
- [[PKI und Zertifikatdienste]] (Theorie kompakt)
- [[Fehlerlog Home-Lab]] (deine Probleme)

---

## 💡 Tipps für diese Woche

1. **Snapshots machen** vor und nach jeder erfolgreichen Aufgabe
2. **Event Viewer öffnen** (EXA-CA01, EXA-SUB-CA01) → wird später wichtig
3. **PowerShell-Commands testen** als du sie liest → nicht nur lesen
4. **Schulbuch parallel lesen** → Theorie + Praxis verbinden
5. **Fehler aufschreiben** → helfen beim Verständnis

---

## 📞 Wenn was fehlt oder unklar

- **Fehler in Aufgaben?** → `Fehlerlog.md`
- **Verständnis-Problem?** → Frage an Claude (diesen Chat)
- **Zu schwer/leicht?** → Aufgaben anpassen (sagen!)

---

**Bereit? Dann starte mit:**  
👉 **[[Aufgabe_01_PKI-Grundlagen]]** (Montag, 60 Min)

Viel Erfolg! 🚀
