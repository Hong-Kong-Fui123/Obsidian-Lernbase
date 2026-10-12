---
aliases:
  - Dockerfile
  - Docker-Datei
tags:
  - glossar
  - glossar/virtualisierung
en: Dockerfile
de: Bauanleitung für ein Image
bereich: Virtualisierung
---

**Dockerfile** = *Dockerfile*
**Deutsch:** Bauanleitung für ein Image

## Kurz
Textdatei mit Anweisungen, aus denen `docker build` ein Image erzeugt.

## Details
- Wichtige Anweisungen: `FROM`, `COPY`, `RUN`, `ENV`, `EXPOSE`, `USER`, `CMD`/`ENTRYPOINT`
- `RUN` läuft beim Bauen, `CMD` beim Start
- `.dockerignore` schließt Dateien aus dem [[Build-Kontext]] aus

## Beispiel
Maschine: **EXA-DOCKER01**
```dockerfile
FROM nginx:1.27-alpine
COPY site/ /usr/share/nginx/html/
EXPOSE 80
```

## Prüfungsfrage
Was ist der Unterschied zwischen `RUN` und `CMD`?

> [!success]- Lösung
> `RUN` wird beim Bauen ausgeführt und erzeugt einen Layer, `CMD` legt den Startbefehl des Containers fest.

## Siehe auch
[[Image-Layer]] · [[Build-Kontext]] · [[Multi-Stage-Build]] · [[CMD-ENTRYPOINT]] · [[00_Docker-Uebersicht]] · [[00_Glossar-Index]]
