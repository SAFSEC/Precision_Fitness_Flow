# Entwicklungshistorie – Precision Fitness & Flow

Dieses Dokument archiviert die abgeschlossenen Entwicklungsphasen und den Prozess hinter der Erstellung von Version 1.0.

---

## Entwicklungsstand (V1.0 + Bugfix-Session abgeschlossen)
```
Stand: 28. März 2026
Abgeschlossene Phasen: 1, 2, 3, 4, 5, 6, 6.5, 7, 8, 9, 9.1, 9.2, 9.3 (5-Tage-Plan)
Offene Phasen: 10 (Motivation), 11 (Smarte Steuerung), 12 (V2 Roadmap)
```

---

## 1. Abgeschlossene Phasen (V1)

**Phase 1 – Fundament**
1. `pubspec.yaml` mit allen Dependencies
2. `lib/core/constants/` – Farben, Durations
3. `lib/data/models/` – alle Dart-Klassen (Exercise, WorkoutSession, TimerState)
4. `lib/data/workout_plan.dart` – vollständiger 3-Wochen-Plan als Dart-Konstante
5. Hive-Adapter generieren (`build_runner`)

**Phase 2 – Timer-Service (Chronos)**
6. `lib/core/services/timer_service.dart` – Timer-Logik (work/rest/transition)
7. `lib/core/services/audio_service.dart` – Sound-Signale
8. Unit-Tests: `timer_service_test.dart`
9. Manuelle Überprüfung: Timer-Sequenz 30/20 läuft korrekt durch

**Phase 3 – Navigation + App-Shell**
10. `lib/app.dart` – GoRouter + Theme
11. `lib/main.dart` – Hive-Init + Riverpod-Scope
12. Leere Placeholder-Pages für alle Routen
13. Test: App startet, Navigation funktioniert im Browser und Emulator

**Phase 4 – Home + Plan**
14. `home_page.dart` + `home_controller.dart`
15. `plan_overview_page.dart` + `day_detail_page.dart`
16. `week_progress_bar.dart`
17. Test: Heutiger Tag wird korrekt angezeigt, Plan-Übersicht zeigt alle 21 Tage

**Phase 5 – Workout-Screen (Kernfeature)**
18. `chronos_timer_widget.dart` – kreisförmiger Countdown-Ring
19. `hiit_view.dart` – Timer-gesteuerter HIIT-Ablauf
20. `strength_view.dart` – satzbasierter Kraft-Ablauf
21. `workout_controller.dart` – verbindet Timer-Service mit UI
22. `safety_hint_banner.dart` – Gelenkschutz-Hinweis
23. `workout_complete_page.dart` – Abschluss + Hive-Speicherung
24. Test: Vollständige HIIT-Einheit (4 Runden) läuft fehlerfrei durch

**Phase 6 – Übungsbibliothek + Historie**
25. `exercise_list_page.dart` + `exercise_detail_page.dart`
26. `history_page.dart` – Hive-Abfrage
27. `history_service.dart` + `history_repository.dart`
28. Test: Session wird gespeichert, in Historie angezeigt, persistiert nach Neustart

**Phase 6.5 – Übungs-Illustrationen**
- 6 minimalistische Illustrationen generiert und in `assets/images/` eingebunden.
- Model `Exercise` um `imageAssetPath` erweitert.
- Bilder in `ExerciseListPage`, `ExerciseDetailPage`, `HiitView` und `StrengthView` integriert.

**Phase 7 – Web-Build + GitHub**
29. Web-Build testen: `flutter build web --release`
30. GitHub Actions konfigurieren (build.yml + deploy_web.yml)
31. README.md schreiben (EN + DE)
32. GitHub Pages testen: App läuft im Browser ohne lokalen Server

**Phase 8 – UX Polish & "Lebendigkeit"**
33. Wakelock Integration (`wakelock_plus`) im WorkoutController.
34. Haptisches Feedback (`vibration`) via neuem HapticService.
35. Voice Cues (`flutter_tts`) via neuem VoiceService, integriert in TimerService.

**Phase 9 & 9.1 – Multi-Plan Architektur & Hybrid Focus**
36. Datenmodelle `WorkoutStep` (mit Metadaten) und `WorkoutProgram` implementiert.
37. UI (StrengthView, Timer) refactored, um metadatengesteuert zu arbeiten.
38. Mehrere Pläne (Home-Auswahl via Bottom-Sheet) mit lokaler Hive-Persistenz aktiviert.
39. Starren 3-Wochen-Plan durch einen rotierenden 7-Tage **Hybrid-Plan (A/B Optionen)** ersetzt.
40. Tests, UI-Gruppierung und WeekCalculator Logik angepasst, damit User sich täglich zwischen "Precision Flow" und "Military Task" entscheiden können.

**Phase 9.3 – 5-Tage Muskelaufbau & HIIT (28. März 2026)**
46. **Feature: 5-Tage-Hybrid-Plan**: Komplette Neustrukturierung des Trainingsplans auf einen 5-Tage-Zyklus (3x Kraft, 2x HIIT, 2x Regeneration).
47. **Feature: HIIT-Flexibilität**: Erweiterung der HIIT-Tage auf 3 wählbare Optionen (A: Core, B: Power, C: Elite) zur besseren Individualisierung.
48. **Visuals: Premium Assets**: Generierung und Integration von 6 hochqualitativen Illustrationen für Übungsvarianten (Diamant-Liegestütze, Schräge Liegestütze, Sprungkniebeugen, Puls-Kniebeugen, Gehende Ausfallschritte, Hampelmänner).
49. **Übungen**: Erweiterung der Übungsdatenbank auf 18 Varianten inkl. spezifischer Ausführungshinweise für die neuen Kraft-Progressionsstufen.

**Phase 9.4 – Audio-Refinement (29. März 2026)**
50. **Bugfix: TTS-Initialisierung**: `VoiceService` robustifiziert. Verwendet nun einen `Completer`, um sicherzustellen, dass die Sprach-Engine bereit ist, bevor die erste Ansage ("Training startet") erfolgt. Verhindert verlorene Audio-Queues bei schnellem Workout-Start.
51. **Feature: 5-Sekunden-Ansage**: Sprach-Countdown bei noch 5 verbleibenden Sekunden in Belastungs-, Pausen- und Übergangsphasen hinzugefügt ("Noch 5 Sekunden").
52. **iOS-Audio-Session**: `setSharedInstance(true)` für bessere iOS-Integration aktiviert.
53. **Voice-Stop**: Sofortiger Stopp aller Sprachausgaben beim Abbrechen oder Schließen eines Workouts.

**Phase 10 – Motivation & Progress Tracking (29. März 2026)**
54. **Feature: Workout-Heatmap**: Implementierung eines GitHub-Style Aktivitäts-Rasters in der `HistoryPage`. Zeigt die letzten 16 Wochen an (horizontal scrollbar am Handy).
55. **Feature: Streak-System**: Automatischer Zähler für aufeinanderfolgende Trainingstage zur Steigerung der Beständigkeit.
56. **Feature: Erfolgs-Badges (Tiers)**: Medaillen-System mit permanenten Abzeichen in Bronze, Silber und Gold. Kategorien: Streak, HIIT-Anzahl, Kraft-Anzahl und Gesamt-Workouts.
57. **Technik**: Einführung von `MotivationService` (Logik), `BadgeService` (Persistenz via Hive) und neuen UI-Widgets (`StreakCard`, `WorkoutHeatmapWidget`, `BadgeItem`).

---

## 2. Historischer Starter-Prompt (Cursor / Claude Code)

Beim Start der Entwicklung von V1 wurde folgender Prompt verwendet:

```
Lies zuerst vollständig die CLAUDE.md in diesem Verzeichnis.
Stelle keine Fragen – alle Entscheidungen sind dort getroffen.

Phase 1-9 sind abgeschlossen.
Nächster Schritt: Phase 10 (Motivation & Progress Tracking).
Startpunkt für die nächste Sitzung: Erstelle Konzepte für Heatmap und Streak-System in Erweiterung.md.
```

---
*V1 archiviert am 18. März 2026. Phase 8 (V2 Start) abgeschlossen im März 2026.*
