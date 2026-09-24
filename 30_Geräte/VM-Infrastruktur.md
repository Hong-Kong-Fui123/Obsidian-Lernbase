# 🖥️ VM-Infrastruktur – Dein erweitertes Homelab

**Host:** HyperV Desktop (30 Cores, 64 GB DDR4, 1 TB SSD)  
**Netzwerk:** privat1 (192.168.1.0/24)  
**Domäne:** example.com  

---

## 📊 VMs nach Rolle

### 🔷 INFRASTRUCTURE LAYER

#### **EXA-DC01** (Primary Domain Controller)
| Parameter          | Wert                                          |
| ------------------ | --------------------------------------------- |
| **OS**             | Windows Server 2022                           |
| **Cores**          | 2                                             |
| **RAM**            | 2 GB                                          |
| **Disk**           | 50 GB (C:\ OS + AD DB)                        |
| **IP**             | 192.168.1.200/24                              |
| **DNS**            | 127.0.0.1 (self)                              |
| **DHCP**           | Nutzt local gateway                           |
| **Rollen**         | AD DS, DNS, Cert. Authority (vertraut Sub-CA) |
| **Besonderheiten** | Offline-Zugriff auf Root-CA möglich           |

**Startup:** `DC01 immer zuerst starten` → AD + DNS müssen erreichbar sein

---

#### **EXA-DC02** (Secondary Domain Controller – optional)
| Parameter | Wert |
|-----------|------|
| **OS** | Windows Server 2022 |
| **Cores** | 2 |
| **RAM** | 2 GB |
| **Disk** | 50 GB |
| **IP** | 192.168.1.201/24 |
| **Rollen** | AD DS Replica (optional für Woche 08) |
| **Status** | ⏳ Wird ab Woche 07 verwendet |

---

#### **EXA-SUB-CA01** (Root CA – Offline)
| Parameter | Wert |
|-----------|------|
| **OS** | Windows Server 2022 |
| **Cores** | 2 |
| **RAM** | 2 GB |
| **Disk** | 50 GB |
| **IP** | 192.168.1.211/24 (aber normalerweise **offline**) |
| **Rollen** | Standalone Root CA (offline) |
| **Besonderheiten** | **Wird nach Installation offline genommen** |
| **Verwendung** | Zertifiziert nur Sub-CA (EXA-CA01) |
| **Netzwerk-Kabel** | ENTFERNEN nach CA-Zertifikat erstellt |

**Wichtig:** Diese VM nach Installation vom Netzwerk trennen → Sicherheit!

---

#### **EXA-CA01** (Subordinate / Enterprise CA – Online)
| Parameter | Wert |
|-----------|------|
| **OS** | Windows Server 2022 |
| **Cores** | 2 |
| **RAM** | 2 GB |
| **Disk** | 50 GB |
| **IP** | 192.168.1.210/24 |
| **Rollen** | Enterprise CA (online, vertraut auf Root) |
| **AD-Integration** | Ja (Domain-joined) |
| **Besonderheiten** | Auto-Enrollment, Cert-Ausrollung via GPO |
| **Verwendung** | Stellt Zertifikate aus für Server + Clients |

**Startup-Abhängigkeit:** DC01 muss laufen (AD-Vertrauen)

---

### 🟦 APPLICATION SERVERS

#### **EXA-WEB01** (IIS + TLS/HTTPS)
| Parameter | Wert |
|-----------|------|
| **OS** | Windows Server 2022 |
| **Cores** | 2 |
| **RAM** | 2 GB |
| **Disk** | 50 GB (+ E:\ für Website-Daten) |
| **IP** | 192.168.1.220/24 |
| **Rollen** | IIS Web Server |
| **Sonstiges** | Server-Zertifikat von CA01 (https binding) |
| **Verwendung** | Ab Woche 06 → Zertifikat-Bindung üben |
| **Test-URL** | https://exa-web01.example.com (mit eigenem Cert) |

---

#### **EXA-DB01** (SQL Server / Datenspeicher)
| Parameter | Wert |
|-----------|------|
| **OS** | Windows Server 2022 |
| **Cores** | 2 |
| **RAM** | 2 GB |
| **Disk** | 50 GB |
| **IP** | 192.168.1.221/24 |
| **Rollen** | SQL Server 2022 (Express) |
| **Verwendung** | Ab Modul 3 → Zertifikat für DB-Verbindungen |
| **Status** | ⏳ Noch nicht relevant |

---

### 🔵 CLIENTS

#### **EXA-CL01** (Windows 11 – Test Client)
| Parameter | Wert |
|-----------|------|
| **OS** | Windows 11 Pro |
| **Cores** | 2 |
| **RAM** | 4 GB |
| **Disk** | 50 GB |
| **IP** | DHCP / 192.168.1.100 (statisch empfohlen) |
| **AD-Mitglied** | Ja (example.com) |
| **Rollen** | Test-Client für Zertifikat-Deployment |
| **Verwendung** | Zertifikate akzeptieren/verweigern testen |

---

#### **EXA-CL02** (Windows 10 – Legacy Client)
| Parameter | Wert |
|-----------|------|
| **OS** | Windows 10 21H2 |
| **Cores** | 2 |
| **RAM** | 4 GB |
| **Disk** | 50 GB |
| **IP** | DHCP / 192.168.1.101 (statisch empfohlen) |
| **AD-Mitglied** | Ja (example.com) |
| **Rollen** | Legacy-Kompatibilität testen |
| **Verwendung** | Alte Zertifikat-Standards prüfen |

---

## 🌐 Netzwerk-Konfiguration

### **Netzwerk: privat1**
```
Netzwerk:       192.168.1.0/24
Broadcast:      192.168.1.255
Gateway:        192.168.1.1 (HyperV-Host)
DNS:            192.168.1.200 (EXA-DC01)
DHCP:           Gateway (HyperV)
```

### **IP-Verteilung**
```
192.168.1.1-50      Reserviert (Gateway, DHCP)
192.168.1.100-101   Clients (CL01, CL02)
192.168.1.200-201   Domain Controller (DC01, DC02)
192.168.1.210-211   CA-Server (CA01, SUB-CA01)
192.168.1.220-221   App-Server (WEB01, DB01)
192.168.1.250-254   Weitere Maschinen (Zukunft)
```

---

## 🔧 Firewall-Einstellungen (alle VMs)

### **Standard aktiviert (alle Windows Firewall Rules)**

| Regel | ICMPv4 | ICMPv6 | Zweck |
|------|--------|--------|-------|
| Datei- & Druck | ✅ Ja | ✅ Ja | Ping funktioniert |
| Überwachung VM | ✅ Ja | ✅ Ja | HyperV-Health checks |

### **Zusätzlich (pro Dienst öffnen)**

#### **EXA-DC01**
- Port 53 (DNS)
- Port 88 (Kerberos)
- Port 389 (LDAP)
- Port 636 (LDAPS)
- Port 135, 139, 445 (SMB/File Share)

#### **EXA-CA01**
- Port 135 (RPC)
- Port 445 (SMB – CSR download)

#### **EXA-WEB01**
- Port 80 (HTTP)
- Port 443 (HTTPS/TLS)

---

## 📊 Ressourcen-Planung

### **RAM-Auslastung**
```
Windows Server 2022 base:      ~400-500 MB (mit AD/DNS/CA)
Client OS (W11/W10):           ~800-1000 MB

Kalkulation pro VM (idle):
├─ DC01 (AD + DNS):            ~1.2 GB
├─ CA01 (Enterprise-CA):        ~1.0 GB
├─ SUB-CA01 (Root-CA):          ~0.8 GB
├─ WEB01 (IIS):                 ~1.0 GB
├─ DB01 (SQL):                  ~1.5 GB
├─ DC02 (standby):              ~1.2 GB
├─ CL01 (W11):                  ~2.0 GB
└─ CL02 (W10):                  ~2.0 GB
────────────────────────────────────────
   SUMME:                       ~12 GB (idle)
```

**Unter Last (Aufgaben):** 20-25 GB  
**Du hast:** 64 GB → **plenty of headroom** ✅

### **Disk-Auslastung**
```
8 × 50 GB = 400 GB (Betriebssysteme + Daten)
Du hast: 1 TB = 1000 GB

Reserve: ~600 GB (für Snapshots, Backup)
```

---

## 🔌 Startup-Reihenfolge

1. **EXA-DC01** starten (2 Min warten)
   - DNS + AD müssen online sein
   
2. **EXA-SUB-CA01** starten (später offline gehen)
   
3. **EXA-CA01** starten
   - Vertraut auf DC01 für AD-Integration
   
4. **Clients starten** (CL01, CL02)
   - Policies müssen von DC01 abrufbar sein
   
5. **App-Server** (WEB01, DB01) optional

**Pro-Tipp:** Script mit HyperV PowerShell → Auto-Startup

---

## 📸 Snapshot-Strategie

### **Checkpoint-Punkte (pro Woche)**

**Vor Aufgabe 01:**
- `Snapshot_Woche05_Start` – Alles läuft, keine Konfiguration

**Nach Aufgabe 01:**
- `Snapshot_Woche05_PKI-Theory` – Nur theoretische Vorbereitungen

**Nach Aufgabe 02:**
- `Snapshot_Woche05_CA-Ready` – Root + Enterprise-CA installiert

**Nach Aufgabe-Klausur:**
- `Snapshot_Woche05_Complete` – Alles durchgearbeitet

---

## 🛠️ VM-Verwaltung Befehle (HyperV PowerShell)

### **Alle VMs starten**
```powershell
# Auf HyperV-Host (PowerShell Admin)
Get-VM | Where-Object {$_.State -eq 'Off'} | Start-VM
```

### **Snapshot erstellen (EXA-DC01)**
```powershell
# Auf HyperV-Host
Checkpoint-VM -Name "EXA-DC01" -SnapshotName "Woche05_CA-Ready"
```

### **Zu Snapshot zurückgehen**
```powershell
# Auf HyperV-Host
Restore-VMSnapshot -VM (Get-VM "EXA-DC01") -Name "Woche05_CA-Ready"
```

### **VM herunterfahren (sauber)**
```powershell
# Auf der jeweiligen VM
shutdown /s /t 30
```

---

## 🔗 Verwandte Seiten
- [[_MOC_Wochenplan]] – Aufgaben-Übersicht
- [[Snapshot-States]] – Startzustände
- [[Firewall-Regeln]] – Detailed Firewall Config

---

**Deine Lab-Umgebung ist bereit.** 🚀  
Starte mit: [[_MOC_Wochenplan]]
