---
tags: [az-802, klausur, loesung]
---
# AZ-802 Probeklausur 01 – Lösungen
↑ [[AZ-802 Klausur 01]]

| Nr | Lösung | Thema |
|---|---|---|
| 1 | b – Seize, alter DC nie wieder online | [[FSMO]] |
| 2 | a + c | [[Vertrauensstellung]] |
| 3 | Password Replication Policy des RODC (Allowed-Gruppe) | [[RODC]] |
| 4 | b – gMSA | [[gMSA]] |
| 5 | Domain Local → ii · Global → iii · Universal → i | [[AGDLP]] |
| 6 | Standortverknüpfung (Zeitplan) | [[KCC]] |
| 7 | Lokal → Standort → Domäne → OU (LSDOU) | [[GPO]] |
| 8 | b – RBKCD auf Ziel SRV03 | [[Double-Hop]] |
| 9 | Rollenfunktionsdatei `.psrc` | [[JEA]] |
| 10 | b – ausgehend 443 | [[Azure Arc]] |
| 11 | PowerShell Direct (`-VMName`) mit Gast-Anmeldedaten | [[PowerShell Direct]] |
| 12 | a + c | – |
| 13 | Zertifikat, HTTPS 443 | [[Hyper-V-Replikat]] |
| 14 | Verfügbarkeitszonen (≥ 2 VMs in versch. Zonen) | – |
| 15 | Azure Bastion, Subnetz `AzureBastionSubnet` | [[Azure Bastion]] |
| 16 | Bedingte Weiterleitung contoso.com + allg. Weiterleitung/Stammhinweise | [[Bedingte Weiterleitung]] |
| 17 | Hot Standby | [[DHCP-Failover]] |
| 18 | Azure DNS Private Resolver, **ausgehender** Endpunkt + Weiterleitungsregelsatz | [[Azure DNS Private Resolver]] |
| 19 | Lesen | – |
| 20 | Azure File Sync mit Cloud-Tiering | [[Cloud-Tiering]] |
| 21 | Drei-Wege-Spiegel, 5 Datenträger | – |
| 22 | SMB über QUIC, UDP 443 | [[SMB über QUIC]] |
| 23 | NTFS | [[ReFS]] |
| 24 | FGPP/PSO; nein, nur Benutzer + globale Gruppen | [[FGPP]] |
| 25 | Windows LAPS | [[Windows LAPS]] |
| 26 | kein NTLM, kein RC4/DES, keine Delegierung, TGT 4 h, keine zwischengespeicherte Anmeldung | [[Protected Users]] |
| 27 | `Get-ADObject -Filter … -IncludeDeletedObjects \| Restore-ADObject` | [[AD-Papierkorb]] |
| 28 | `Test-ComputerSecureChannel -Repair -Credential …` | [[Secure Channel]] |
| 29 | Zeitabweichung, max. 5 Min | – |
| 30 | Azure Monitor Agent + Datensammlungsregel (DCR) → Log Analytics | [[DCR]] |

## Auswertung
| Punkte | Bewertung | Nächster Schritt |
|---|---|---|
| ≥ 34 | prüfungsreif | Microsoft-Übungsbewertung |
| 28–33 | bestanden | schwache Bereiche wiederholen |
| < 28 | nicht bestanden | Themen-Notiz + Lab erneut |

Fehler je Bereich eintragen:
| Bereich | Fehler | Wiederholt am |
|---|---|---|
| 01 AD DS | | |
| 02 Hybrid | | |
| 03 VM | | |
| 04 Netzwerk | | |
| 05 Speicher | | |
| 06 Sicherheit | | |
| 07 Troubleshooting | | |
