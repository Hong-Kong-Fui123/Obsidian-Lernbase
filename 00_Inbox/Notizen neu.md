[[PowerShell Grundlagen]] [[Windows Server]]

PowerShell Befehl zum mounten einer Festplatte 
Get-Command -Noun vhd

### PowerShell Docker Container erstellen mit Portforwarding
docker run -it -p 8080:80 mcr.microsoft.com/windows/servercore:ltsc2022 powershell

### PowerShell Container mit Netzwerk erstellen
Netzwerk erstellen
docker network create -d transparent --subnet=192.168.1.0/24 --gateway=192.168.1.201 trans

Container mit dem Netzwerk erstellen
docker run -it --network=trans --ip=192.168.1.250 --dns=192.168.1.200 mcr.microsoft.com/windows/nanoserver:ltsc2022 cmd

### PowerShell Umgebungsvariablen anzeigen lassen
Get-Item env:



Was ist RFC?
Request for Comments

Was ist bgp ?
Border Gateway Protocol
