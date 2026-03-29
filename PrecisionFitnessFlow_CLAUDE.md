# CLAUDE.md – Precision Fitness & Flow
## Product Requirements Document v1.0
## Open Source | GitHub | Web + Android + iOS

Lies dieses Dokument vollständig bevor du eine einzige Zeile Code schreibst.
Stelle keine Fragen – alle Entscheidungen sind hier getroffen.

---

## Entwicklungsstand
```
Stand: 29. März 2026
Abgeschlossene Phasen: 1, 2, 3, 4, 5, 6, 6.5, 7, 8, 9, 9.1, 9.2, 9.3 (5-Tage-Plan), 9.4 (Audio-Bugfix & 5s Countdown)
Offene Phasen: 10, 11, 12
Bekannte Probleme: –
Nächster Schritt: Phase 10 – Motivation & Progress Tracking
Privacy-Stack: nicht aktiv (keine personenbezogenen Daten)

Neuerungen (Phase 9.3 / 9.4):
- 5-Tage-Trainingsplan: Umstellung auf 3x Kraft, 2x HIIT, 2x Regeneration.
- Audio-Fix (Phase 9.4): Robuste TTS-Initialisierung und neuer 5-Sekunden-Sprach-Countdown für Belastung und Pausen.
- Premium Assets: 6 neue hochqualitative Illustrationen für Übungsvarianten.
- Neue Übungen: Diamant-Liegestütze, Schräge Liegestütze, Sprungkniebeugen, Puls-Kniebeugen, Gehende Ausfallschritte, Hampelmänner.
- HIIT-Struktur: 3 wählbare Optionen (A, B, C) für maximale Flexibilität.
```


## Phase 0 – Klarheit (bereits entschieden)

```
1. WAS: Strukturierte No-Equipment-Fitness-App mit 3-Wochen-Plan,
   HIIT-Timer und geführten Trainingseinheiten. Keine Registrierung,
   keine Cloud, keine KI-API. Alles läuft lokal auf dem Gerät.

2. FÜR WEN: Jedermann – keine Anmeldung, kein Konto, sofort nutzbar.

3. WO: Web (PWA) + Android + iOS via Flutter. Ein Codebase für alle Plattformen.

4. BETRIEBSKOSTEN: 0 € – keine API, kein Backend, kein Hosting nötig.
   Distribution: Web (GitHub Pages / Netlify), App Stores optional.

5. HARTE GRENZEN:
   - Keine Nutzerdaten erfassen (kein Name, keine E-Mail, kein Account)
   - Keine Telemetrie, kein Analytics, kein Tracking
   - Keine externe API (kein LLM, kein Backend)
   - Kein Cloud-Sync – Trainingshistorie nur lokal auf dem Gerät
   - Open Source: MIT-Lizenz, vollständig auf GitHub

6. ERFOLG: Der HIIT-Timer läuft korrekt mit 30/20-Taktung,
   zeigt die aktuelle Übung an und signalisiert akustisch den Phasenwechsel.
```

---

## 1. Produkt-Vision

**Precision Fitness & Flow** ist eine kostenlose, werbefreie, datenschutzfreundliche
Fitness-App für strukturiertes Körpergewichtstraining ohne Equipment.

Die App führt Nutzer durch einen **Hybrid-Wochenplan** mit täglich geführten
Einheiten (wählbar als Precision Flow oder Military Task) – entweder als satzbasiertes Krafttraining oder als zeitbasiertes HIIT.
Ein präziser **Chronos-Timer** steuert Belastung, Pause und Übungsübergänge mit
akustischen Signalen.

**Kein Account. Keine Daten. Kein Internet nötig.**

- **Plattformen:** Web (PWA), Android, iOS
- **Framework:** Flutter (Dart) – ein Codebase für alle Plattformen
- **Nutzer:** Unbegrenzt, anonym, keine Rollen
- **Distribution:** GitHub (Open Source, MIT), GitHub Pages (Web), App Stores (optional V2)
- **Betriebskosten:** 0 €

---

## 2. Tech Stack (verbindlich)

```
Framework:        Flutter (Dart) – Cross-Platform Web + Android + iOS
State Management: Riverpod (null-safe, testbar, kein BuildContext-Chaos)
Lokale DB:        Hive (NoSQL, Flutter-nativ, schnell, kein SQL-Overhead)
Timer:            dart:async – isolierter Timer-Service, kein setState-Spam
Hardware & UX:    wakelock_plus, vibration, flutter_tts (Phase 8 Features)
Audio:            audioplayers (^5.x) – lokale Sound-Assets, kein Netz nötig
Navigation:       GoRouter (deklarativ, deep-link-fähig für PWA)
Tests:            flutter_test + mocktail
Linting:          flutter_lints (very_good_analysis optional)
Build Web:        flutter build web --release (→ GitHub Pages / Netlify)
Build Android:    flutter build apk / appbundle
Build iOS:        flutter build ipa
CI/CD:            GitHub Actions (build + test automatisch bei Push)
```

---

## 3. Projektstruktur

```
precision_fitness_flow/
├── CLAUDE.md                          ← dieses Dokument
├── README.md                          ← GitHub-Dokumentation (EN)
├── LICENSE                            ← MIT
├── pubspec.yaml
├── analysis_options.yaml
├── .github/
│   └── workflows/
│       ├── build.yml                  ← Flutter build + test (alle Plattformen)
│       └── deploy_web.yml             ← GitHub Pages Deploy bei Push auf main
│
├── lib/
│   ├── main.dart                      ← App-Einstieg, Hive-Init, Riverpod-Scope
│   ├── app.dart                       ← MaterialApp + GoRouter + Theme
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart        ← Alle Farben (kein Hardcoding im Widget)
│   │   │   ├── app_text_styles.dart
│   │   │   └── app_durations.dart     ← Timer-Konstanten (30s, 20s, etc.)
│   │   ├── router/
│   │   │   └── app_router.dart        ← GoRouter-Konfiguration
│   │   ├── services/
│   │   │   ├── timer_service.dart     ← Chronos-Timer (isoliert, Riverpod-Provider)
│   │   │   ├── audio_service.dart     ← Sound-Signale (work / rest / transition)
│   │   │   ├── haptic_service.dart    ← Vibrations-Feedback bei Timer-Wechsel
│   │   │   ├── voice_service.dart     ← Text-to-Speech Coach (Ansagen)
│   │   │   └── history_service.dart   ← Hive-Zugriff für Trainingshistorie
│   │   └── utils/
│   │       ├── duration_formatter.dart ← "00:30" Formatierung
│   │       └── week_calculator.dart    ← Aktuelle Woche + Tag berechnen
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── exercise.dart          ← Übungsmodell (Name, Fokus, Typ, Hinweise)
│   │   │   ├── workout.dart           ← Trainingseinheit (Typ, Sets/Intervalle)
│   │   │   ├── training_day.dart      ← Ein Tag im 3-Wochen-Plan
│   │   │   ├── workout_session.dart   ← Absolvierte Einheit (Hive-Objekt)
│   │   │   └── timer_state.dart       ← Enum: work / rest / transition / idle
│   │   ├── repositories/
│   │   │   └── history_repository.dart ← Abstraktionsschicht über Hive
│   │   └── workout_plan.dart          ← Kompletter 3-Wochen-Plan als Dart-Konstante
│   │
│   ├── features/
│   │   ├── home/
│   │   │   ├── home_page.dart         ← Startseite: heutiger Tag + Wochenübersicht
│   │   │   └── home_controller.dart   ← Riverpod-Provider für Home-Logik
│   │   ├── plan/
│   │   │   ├── plan_overview_page.dart ← Alle 21 Tage als Übersicht
│   │   │   └── day_detail_page.dart    ← Detailansicht eines Trainingstags
│   │   ├── workout/
│   │   │   ├── workout_page.dart       ← Haupt-Training-Screen (Timer + Übung)
│   │   │   ├── workout_controller.dart ← Riverpod: Timer-State + Schritt-Logik
│   │   │   ├── strength_view.dart      ← View für Kraft-Tage (satzbasiert)
│   │   │   ├── hiit_view.dart          ← View für HIIT-Tage (zeitbasiert)
│   │   │   └── workout_complete_page.dart ← Abschluss-Screen nach Training
│   │   ├── exercises/
│   │   │   ├── exercise_list_page.dart ← Übungsbibliothek (alle 6 Übungen)
│   │   │   └── exercise_detail_page.dart ← Ausführungshinweise + Gelenkschutz
│   │   └── history/
│   │       └── history_page.dart       ← Absolvierte Einheiten (lokal)
│   │
│   └── widgets/
│       ├── chronos_timer_widget.dart   ← Großer Countdown-Ring
│       ├── phase_indicator.dart        ← Work / Rest / Transition Badge
│       ├── exercise_card.dart          ← Übungskarte mit Fokus-Muskel
│       ├── set_counter.dart            ← Satz-Zähler für Kraft-Tage
│       ├── safety_hint_banner.dart     ← Gelenkschutz-Hinweis (plyometrisch)
│       └── week_progress_bar.dart      ← Fortschritt in der aktuellen Woche
│
├── assets/
│   ├── audio/
│   │   ├── beep_work.mp3              ← Signal: Belastungsphase startet
│   │   ├── beep_rest.mp3              ← Signal: Pause startet
│   │   └── beep_transition.mp3        ← Signal: Übungswechsel
│   └── images/
│       └── (optional: Übungssilhouetten SVG)
│
└── test/
    ├── unit/
    │   ├── timer_service_test.dart
    │   ├── workout_plan_test.dart
    │   └── week_calculator_test.dart
    └── widget/
        ├── chronos_timer_widget_test.dart
        └── hiit_view_test.dart
```

---

## 4. Trainingsplan – vollständige Datenstruktur

### 4.1 Übungsdatenbank (Erweitert)

```dart
// lib/data/models/exercise.dart

enum ExerciseType { strength, metabolic, hiit }
enum MuscleGroup { chest, shoulders, triceps, lowerBody, core, fullBody }

// Auszug der Kernübungen + Varianten:
const pushUps        = Exercise(id: 'push_ups', name: 'Liegestütze (Basis)', ...);
const inclinePushUps = Exercise(id: 'push_ups_incline', name: 'Schräge Liegestütze', ...);
const diamondPushUps = Exercise(id: 'push_ups_diamond', name: 'Diamant-Liegestütze', ...);
const squats         = Exercise(id: 'squats', name: 'Kniebeugen', ...);
const jumpingSquats  = Exercise(id: 'squats_jumping', name: 'Sprungkniebeugen', ...);
const pulsingSquats  = Exercise(id: 'squats_pulsing', name: 'Puls-Kniebeugen', ...);
const lunges         = Exercise(id: 'lunges', name: 'Ausfallschritte', ...);
const walkingLunges  = Exercise(id: 'lunges_walking', name: 'Gehende Ausfallschritte', ...);
const burpees        = Exercise(id: 'burpees', name: 'Burpees', ...);
const jumpingJacks   = Exercise(id: 'jumping_jacks', name: 'Hampelmänner', ...);
```

### 4.2 Trainingsstruktur: 5-Tage-Hybrid-Plan

**Wochenstruktur (3x Kraft, 2x HIIT, 2x Regeneration):**

```
Mo  → Krafttraining (Option A: Basis / Option B: Advanced)
Di  → HIIT (3 Optionen: A, B oder C wählbar)
Mi  → Krafttraining (Option A: Fokus / Option B: Muskelreiz)
Do  → HIIT (3 Optionen: A, B oder C wählbar)
Fr  → Krafttraining (Option A: Ausführung / Option B: Belastung)
Sa  → Regeneration (Stretching / Ruhe)
So  → Regeneration
```

**HIIT-Logik (Dienstag / Donnerstag):**
- **Option A (PFF - Core & Endurance)**: 4 Runden, 30s Work / 20s Rest.
- **Option B (MT - Power)**: 5 Runden, 30s Burpees / 20s Jumping Squats, 10s Rest.
- **Option C (Elite - Intensity Booster)**: 4 Runden, 3x 30s Work (Diamond/Pulse/Lunge), 15s Rest.

### 4.3 Datenmodell (Hive)

```dart
// lib/data/models/workout_session.dart
// @HiveType für lokale Persistenz

@HiveType(typeId: 0)
class WorkoutSession extends HiveObject {
  @HiveField(0) late String workoutId;       // Referenz auf Training-Tag-ID
  @HiveField(1) late DateTime completedAt;   // Abschlusszeitpunkt
  @HiveField(2) late int durationSeconds;    // Gesamtdauer in Sekunden
  @HiveField(3) late bool completed;         // Vollständig oder abgebrochen
  @HiveField(4) late int week;               // 1, 2 oder 3
  @HiveField(5) late int dayOfWeek;          // 1–7
}

// Keine personenbezogenen Felder. Keine Nutzer-ID. Keine Gerätekennungen.
```

---

## 5. Chronos-Timer – vollständige Logik

### 5.1 Timer-Zustände

```dart
// lib/data/models/timer_state.dart

enum TimerPhase { idle, work, rest, transition, completed }

class TimerState {
  final TimerPhase phase;
  final int remainingSeconds;     // Countdown
  final int currentRound;         // Aktuelle Runde (HIIT)
  final int totalRounds;          // Gesamtrunden
  final int currentSetIndex;      // Aktueller Satz (Kraft)
  final int totalSets;
  final Exercise? currentExercise;
  final Exercise? nextExercise;   // Vorschau nächste Übung
  final bool isRunning;
}
```

### 5.2 Timer-Konstanten

```dart
// lib/core/constants/app_durations.dart

const kHiitWorkSeconds     = 30;   // Belastungsphase
const kHiitRestSeconds     = 20;   // Pause zwischen Intervallen
const kHiitTransSeconds    = 30;   // Pause zwischen Runden
const kStrengthRestSeconds = 60;   // Satzpause Kraft (Woche 1–2)
const kStrengthRestWeek3   = 45;   // Satzpause Kraft (Woche 3)
const kTransitionSeconds   = 5;    // Übungswechsel-Vorbereitungszeit
```

| Ereignis | Sound-Datei / Voice | Verhalten |
|---|---|---|
| Work beginnt | `beep_work.mp3` + Name | "Training startet. [Name]" oder Signalton |
| Rest beginnt | `beep_rest.mp3` + Name | "Pause. Nächste Übung: [Name]" |
| Transition | `beep_transition.mp3` | Drei kurze Töne (Rundenwechsel) |
| Letzten 10/5 Sek. | Sprachansage | "Noch 10 Sekunden" / "Noch 5 Sekunden" |
| Letzten 3 Sek. | `beep_work.mp3` (3×) | Countdown-Ticks |
| Training fertig | Alle drei kurz | Abschluss-Signal |

---

## 6. Features (V1 – MVP)

### 6.1 Home-Screen

```
[Heutiger Trainingstag]          ← Woche X / Tag Y
  Typ: HIIT / Kraft A / Kraft B / Regeneration
  Übungsvorschau (kompakt)
  [Training starten] Button

[Wochenfortschritt]              ← 5 Tage, abgehakt wenn absolviert
  Mo ✓  Di ✓  Mi –  Do –  Fr –

[Zum vollständigen Plan]         ← Link zu Plan-Übersicht
```

### 6.2 Plan-Übersicht (21 Tage)

- Alle 21 Tage als Liste
- Status: offen / absolviert / heute
- Antippen → Detailansicht des Tages

### 6.3 Workout-Screen (Kern der App)

**Kraft-Modus (satzbasiert):**
```
Übungsname + Muskelgruppe
Satz X von 3 | Wiederholungen: 12–15
[Satz absolviert] Button
Pause-Timer läuft herunter (60 Sek.)
Nächste Übung (Vorschau)
Gelenkschutz-Hinweis wenn plyometrisch
```

**HIIT-Modus (zeitbasiert):**
```
Großer Countdown-Ring (Chronos)
Phase-Badge: WORK / REST / TRANSITION
Aktuelle Übung + Ausführungshinweis
Runde X von 4/5/6
Nächste Übung (Vorschau)
[Pause] [Abbrechen] Buttons
```

### 6.4 Übungsbibliothek

- Alle 6 Übungen als Karten
- Antippen → Detailansicht mit Ausführungshinweis
- Gelenkschutz-Hinweis bei plyometrischen Übungen (farblich hervorgehoben)

### 6.5 Historie (lokal)

- Liste aller absolvierten Einheiten
- Datum, Typ, Dauer, vollständig/abgebrochen
- Nur auf dem Gerät gespeichert – kein Sync

### 6.6 Regenerations-Tag-Screen

- Kein Timer
- Text: Empfehlungen für Stretching / Tai Chi
- Optional: Einfache Atemübung als Text-Anleitung

---

## 7. UI-Design-Regeln

**Farbschema (Dark-Mode-First):**

```dart
// lib/core/constants/app_colors.dart

const kColorBackground    = Color(0xFF0D1117);  // Fast Schwarz (GitHub Dark)
const kColorSurface       = Color(0xFF161B22);  // Karten-Hintergrund
const kColorWork          = Color(0xFF238636);  // Grün – Belastungsphase
const kColorRest          = Color(0xFF1F6FEB);  // Blau – Ruhephase
const kColorTransition    = Color(0xFFE3B341);  // Gelb – Übergang
const kColorAccent        = Color(0xFFF78166);  // Rot-Orange – Akzent, CTA
const kColorText          = Color(0xFFE6EDF3);  // Heller Text
const kColorTextMuted     = Color(0xFF8B949E);  // Gedämpfter Text
const kColorSafetyHint    = Color(0xFFFF7B72);  // Gelenkschutz-Hinweis
```

**Layout-Regeln:**
- Kein BottomNavigationBar mit mehr als 4 Items
- WorkoutScreen: Vollbild, kein AppBar während Timer läuft
- Chronos-Timer: kreisförmiger Countdown-Ring, Durchmesser = 65% der Bildschirmbreite
- Kein Material-You / kein Cupertino-Design – eigenes minimales Design
- Schrift: System-Font (kein Google Fonts Dependency für Offline-Fähigkeit)
- Padding: 16px Standard, 24px bei Haupt-Content-Bereichen

**Responsive (Web + Mobil):**
- Mobil: Single-Column, alles scrollbar
- Web/Tablet ab 768px: zentrierter Content-Container max. 480px Breite

---

## 8. API-Routen / Navigation (GoRouter)

```dart
// Keine REST-API – rein lokale App

// GoRouter-Routen:
/                          ← Home (heutiger Tag)
/plan                      ← 3-Wochen-Übersicht
/plan/:dayId               ← Detail eines Trainingstags
/workout/:dayId            ← Aktive Trainingseinheit
/workout/:dayId/complete   ← Abschluss-Screen
/exercises                 ← Übungsbibliothek
/exercises/:exerciseId     ← Übungsdetail
/history                   ← Trainingshistorie
```

---

## 9. Keine Prompt-Templates (keine KI-API)

Diese App verwendet keine LLM-Anbindung.
Alle Inhalte (Trainingsplan, Übungshinweise, Texte) sind als Dart-Konstanten
in `lib/data/workout_plan.dart` hinterlegt und benötigen keine externe API.

---

## 10. Datenschutz

**Kein DSGVO-Stack erforderlich.**

```
- Keine personenbezogenen Daten werden erhoben
- Keine Nutzerkonten, keine E-Mails, keine Namen
- Keine externen APIs, kein Netzwerkverkehr im Betrieb
- Lokale Trainingshistorie verbleibt ausschließlich auf dem Gerät (Hive)
- Keine Gerätekennungen, kein Fingerprinting, kein Analytics
- Open Source: vollständiger Code einsehbar auf GitHub (MIT-Lizenz)
```

**Privacy-Hinweis für README und App Stores:**
> "Precision Fitness & Flow collects no personal data. No account required.
> All training history is stored locally on your device only. No internet
> connection needed after installation."

---

## 11. GitHub-Konfiguration

**Repository-Struktur:**
```
Repository:  precision-fitness-flow (public)
Lizenz:      MIT
README:      Englisch (Haupt) + Deutsch (README.de.md)
Branch:      main (stable) + develop (aktive Entwicklung)
```

**GitHub Actions – `.github/workflows/build.yml`:**
```yaml
name: Build & Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test

  build_web:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build web --release
      - uses: actions/upload-artifact@v4
        with:
          name: web-build
          path: build/web/
```

**GitHub Actions – `.github/workflows/deploy_web.yml`:**
```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      pages: write
      id-token: write
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build web --release --base-href "/precision-fitness-flow/"
      - uses: actions/deploy-pages@v4
        with:
          path: build/web/
```

---

## 12. Coding-Regeln

- Dart mit null-safety – keine `!` ohne Begründung im Kommentar
- Keine `setState` in Workout-Logik – ausschließlich Riverpod StateNotifier
- Timer-Service als eigener Riverpod-Provider – kein direkter Timer in Widgets
- Audio-Service: immer try-catch, kein App-Crash bei fehlendem Audio
- Hive-Adapters generieren mit `build_runner` – kein manuelles Schreiben
- Keine hardcodierten Farben in Widgets – nur aus `app_colors.dart`
- Keine hardcodierten Durations – nur aus `app_durations.dart`
- Keine hardcodierten Strings in Widgets – nur aus `workout_plan.dart` oder Konstanten
- Komponenten maximal 150 Zeilen – bei mehr: aufteilen
- Jede Datei hat genau eine Verantwortlichkeit
- Tests für: timer_service, workout_plan-Logik, week_calculator

---

## 13. Starter-Reihenfolge für Cursor / Claude Code

**Phase 8 – UX Polish & "Lebendigkeit"**
33. Wakelock Integration (`wakelock_plus`) im WorkoutController.
34. Haptisches Feedback (`vibration`) via neuem HapticService.
35. Voice Cues (`flutter_tts`) via neuem VoiceService, integriert in TimerService.

**Phase 9.3 – 5-Tage Muskelaufbau & HIIT**
40. Umstellung des Hybrid-Plans auf ein 5-Tage-Schema (Mo-Fr) + Wochenende Fokus.
41. Integration von 6 neuen premium visual Assets für Übungsvarianten.
42. Erweiterung der HIIT-Logik auf 3 wählbare Optionen pro HIIT-Tag.

**Phase 10 – Motivation & Progress Tracking (In Vorbereitung)**
43. Konzepte für Heatmap und Streak-System entwerfen.

---

## 14. Cursor-Starter-Prompt

```
Lies zuerst vollständig die CLAUDE.md in diesem Verzeichnis.
Stelle keine Fragen – alle Entscheidungen sind dort getroffen.

Phase 1-9.1 sind abgeschlossen.
Nächster Schritt: Phase 10 (Motivation & Progress Tracking).

Startpunkt: Erstelle Konzepte für Heatmap und Streak-System basierend auf Erweiterung.md.
```

---

## 15. SaaS-Vorbereitung (nicht implementieren, aber beachten)

```
- Übungsplan-Daten als JSON-Datei auslagern → leicht austauschbar für V2 (Multilingual)
- Trainingsplan-Logik von UI trennen → V2 kann eigene Pläne unterstützen
- Audio-Service abstrakt halten → V2 kann Text-to-Speech-Cues ergänzen
- History-Repository abstrakt halten → V2 kann optionales Cloud-Sync ergänzen
  (nur wenn Nutzer aktiv zustimmt – Privacy by Default bleibt erhalten)
```

---

*Precision Fitness & Flow – CLAUDE.md v1.0 – Q2 2026*
*Open Source: MIT-Lizenz | GitHub: precision-fitness-flow*
*V2-Roadmap: Eigene Pläne, Multilingual (EN/DE), optionaler iCloud/Drive-Sync (Opt-In)*
