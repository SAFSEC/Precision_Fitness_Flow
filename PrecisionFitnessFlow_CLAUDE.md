# CLAUDE.md – Precision Fitness & Flow
## Project Guidelines & Context

Dieses Dokument dient als zentrale Wissensbasis für die Weiterentwicklung der App. Es enthält verbindliche Architektur-Entscheidungen, Design-Regeln und Coding-Standards.

---

## 1. Produkt-Vision

**Precision Fitness & Flow** ist eine kostenlose, werbefreie und datenschutzfreundliche Fitness-App für Eigengewichtstraining.

- **Ziel**: Strukturierter 3-Wochen-Trainingsplan (Kraft & HIIT).
- **Philosophie**: Kein Account, keine Cloud, kein Internet nötig. Alles läuft lokal.
- **Plattformen**: Web (PWA), Android, iOS via Flutter.
- **Lizanz**: MIT (Open Source).

---

## 2. Tech Stack (verbindlich)

- **Framework**: Flutter (Dart)
- **State Management**: Riverpod (Notifier/Provider)
- **Lokale DB**: Hive (Box-basiert, NoSQL)
- **Navigation**: GoRouter
- **Audio**: audioplayers (^5.x)
- **Linting**: flutter_lints
- **CI/CD**: GitHub Actions (Build & Test)

---

## 3. Architektur & State Management

- **Trennung der Belange**: Geschäftslogik liegt in den Controllern/Services, nicht in den Widgets.
- **Timer-Service**: Isoliert in `lib/core/services/timer_service.dart`. Widgets konsumieren den Status über Riverpod.
- **Datenmodell**: Alle Modelle sind in `lib/data/models/` zentralisiert. Hive-Adapter werden per `build_runner` generiert.
- **Trainingsplan**: Der komplette Plan ist als statische Konstante in `lib/data/workout_plan.dart` hinterlegt.

---

## 4. UI-Design-Regeln (Dark-Mode-First)

**Farben (`lib/core/constants/app_colors.dart`):**
- Hintergrund: GitHub Dark Style (`#0D1117`)
- Akzent: Orange-Rot (`#F78166`)
- Phasen: Grün (Work), Blau (Rest), Gelb (Transition)

**Layout:**
- Max. Content-Breite auf Web/Tablet: 480px.
- Chronos-Timer: Kreisförmiger Countdown-Ring (ca. 65% Breite).
- Keine externen Fonts (System-Fonts verwenden zwecks Offline-Fähigkeit).

---

## 5. Coding-Regeln

- **Null-Safety**: Konsequent nutzen.
- **State**: Kein `setState` für komplexe Logik (→ Riverpod).
- **Einheitlichkeit**: Keine hardcodierten Farben/Strings/Durations in Widgets (→ Konstanten nutzen).
- **Dateigröße**: Komponenten max. 150 Zeilen, sonst aufteilen.
- **Verantwortlichkeit**: Jede Datei hat genau eine Aufgabe (Single Responsibility).
- **Audio**: Immer in `try-catch` Blöcke fassen.

---

## 6. Datenschutz

- **Privacy by Design**: Keine Erhebung personenbezogener Daten.
- **Kein Tracking**: Keine Telemetrie oder Analytics.
- **Lokal**: Alle Daten verbleiben auf dem Gerät.

---

## 7. Weiterentwicklung (V2-Roadmap)

Zukünftige Erweiterungen sollten folgende Punkte beachten:
- Internationalisierung vorbereitet (DE/EN).
- Optionale Cloud-Sync (nur verschlüsselt, nur Opt-in).
- Adaptives Training (Nutzer-Feedback einbeziehen).

*Details zur Historie und den initialen Build-Phasen finden sich in `DEV_LOG.md`.*

---
*Precision Fitness & Flow – CLAUDE.md v1.1 – Q1 2026*
