---
tags: [glossar, docker]
aliases: [Layer, Schicht]
---
# Image-Layer

**Kurz:** Schreibgeschützte Schicht eines Images; jede Dockerfile-Anweisung wie RUN/COPY erzeugt eine.

- Layer werden gecacht und zwischen Images geteilt
- Änderung eines Layers baut alle folgenden neu
- Anzeigen: `docker history <image>`

**Siehe auch:** [[Image]] · [[Dockerfile]] · [[00_Docker-Uebersicht]]
