---
aliases:
  - Multi-Stage-Build
  - Multistage
  - mehrstufiger Build
tags:
  - glossar
  - glossar/virtualisierung
en: Multi-Stage Build
de: Mehrstufiger Build
bereich: Virtualisierung
---

**Multi-Stage-Build** = *Multi-Stage Build*
**Deutsch:** Mehrstufiger Build

## Kurz
Dockerfile mit mehreren `FROM`-Stufen. Bauwerkzeuge bleiben in der ersten Stufe, ins fertige Image kommt nur das Ergebnis.

## Details
- Kleinere Images, weniger Angriffsfläche
- Übernahme mit `COPY --from=<stufe>`
- Typisch für .NET, Java, Go, Node

## Beispiel
Maschine: **EXA-DOCKER01**
```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish -c Release -o /app

FROM mcr.microsoft.com/dotnet/aspnet:8.0
COPY --from=build /app /app
ENTRYPOINT ["dotnet", "/app/MeineApp.dll"]
```

## Prüfungsfrage
Welchen Vorteil hat ein Multi-Stage-Build für die Sicherheit?

> [!success]- Lösung
> Compiler und Bauwerkzeuge sind im Produktiv-Image nicht enthalten → weniger Angriffsfläche.

## Siehe auch
[[Dockerfile]] · [[Image]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
