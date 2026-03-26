# 🌊 Precision Fitness & Flow

![Build Status](https://github.com/USERNAME/precision-fitness-flow/actions/workflows/build.yml/badge.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)

> **[🇺🇸 English Version here / Englische Version hier](README.md)**

Eine vollständig offline lauffähige, datenschutzfreundliche Bodyweight-Trainings-App, entwickelt mit Flutter. Ganz ohne benötigtes Equipment.

**Precision Fitness & Flow** führt dich durch einen flexiblen Hybrid-Wochenplan (Precision Flow & Military Task). Er kombiniert gezieltes Krafttraining (Sätze) mit intensiv geführten HIIT-Einheiten (High-Intensity Interval Training). Eine Kernkomponente der App ist der detaillierte Chronos-Timer, der dich visuell und akustisch durch Belastungs- und Erholungsphasen steuert. Das alles geschieht komplett lokal – ohne Nutzerkonten, ohne Cloud-Sync und ohne Tracking.

## ✨ Kernfunktionen
- **Flexibler Hybrid-Wochenplan**: Wähle jeden Tag spontan zwischen Precision Flow (Technik) oder Military Task (Leistung).
- **Chronos-Timer**: Ein präziser Countdown-Ring, der dir exakt visualisiert, wann geboostet und wann pausiert wird.
- **Dynamisches Trainings-Erlebnis**: Sprachansagen als virtueller Coach (TTS), haptisches Vibrations-Feedback bei Pausen-/Übungswechsel und automatischer Wakelock, damit das Display an bleibt.
- **Absoluter Datenschutz**: Es werden keinerlei persönliche Daten gesammelt. Deine Trainings-Historie bleibt ohne Umwege rein auf deinem Endgerät.
- **6 Kernübungen**: Geführt mit minimalistischen Vector-Illustrationen (Liegestütze, Kniebeugen, Ausfallschritte, Mountain Climbers, Hampelmänner, Burpees).
- **Integrierter Gelenkschutz**: Direkte Warnhinweise insbesondere bei plyometrischen (sprungbasierten) Übungen.

## 🛠 Tech Stack
- **Framework**: [Flutter](https://flutter.dev/) (Dart) (Ein Codebase für Web, Android, iOS)
- **Lokale Datenbank**: [Hive](https://docs.hivedb.dev/) (Hochperformantes lokales Key-Value Storage)
- **Zustandsverwaltung**: [Riverpod](https://riverpod.dev/) (Deklarativ, skalierbar und Null-Safe)
- **Routing**: [GoRouter](https://pub.dev/packages/go_router)
- **Audio**: Lokale Sound-Assets über `audioplayers`

## 🚀 Installation & Kompilierung

Du kannst das Projekt mit Flutter mühelos für Android, iOS und als Web-App kompilieren.

### 1. Voraussetzungen
- Flutter SDK `^3.16.0` 
- Dart SDK `^3.0.0` 

### 2. Projekt starten
Repository klonen und Abhängigkeiten installieren:
```bash
git clone https://github.com/USERNAME/precision-fitness-flow.git
cd precision-fitness-flow
flutter pub get
```

### 3. Hive-Adapter generieren
Die lokale Hive-Datenbank benötigt für ihre schnellen Typ-Adapter den Build Runner:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. App starten
Zum Ausführen im Webbrowser (für eine schnelle Dev-Ansicht):
```bash
flutter run -d chrome
```

Um einen produktionsreifen Web-Release (mit Tree-Shaking und Caching-Optimierungen) zu erzeugen, wechsle ins Terminal:
```bash
flutter build web --release
```

## 🔒 Datenschutz-Hinweis
Precision Fitness & Flow erhebt **keinerlei personenbezogene Daten**. Es ist und bleibt kein Benutzerkonto erforderlich. Alle erstellten Trainingsdaten (z. B. Abschlusszeiten) werden ausschließlich lokal auf deinem Gerät gespeichert. Die Applikation baut während der Ausführung keinerlei Netzwerkverbindungen zu Servern auf.

> **💡 Hinweis zur Web-Version (GitHub Pages):**
> Auch wenn du die App im Browser nutzt, werden deine Fortschritte und Statistiken sicher in der lokalen Datenbank des Browsers (IndexedDB) gespeichert. Solange du deine Browserdaten nicht manuell löschst oder im Inkognito-Modus surfst, bleiben deine Trainingsdaten dauerhaft über Sitzungen hinweg erhalten!

## ⚖️ Lizenz
Dieses Projekt ist Open Source und steht unter der **MIT-Lizenz**. Du darfst den Code frei verwenden, anpassen und unter Beibehaltung der Lizenzbedingungen eigene Projekte aufbauen.
