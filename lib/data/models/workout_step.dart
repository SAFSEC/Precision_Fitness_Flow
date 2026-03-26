import 'exercise.dart';

class WorkoutStep {
  final Exercise exercise;
  final int? sets; // Anzahl der Sätze (z.B. 3)
  final int? reps; // Für Wiederholungszahlen (z.B. 15)
  final int? durationSeconds; // Für zeitbasierte Übungen (z.B. 30s oder isometrisches Halten)
  final int? restSeconds; // Spezifische Pause nach der Übung (überschreibt Konstanten)

  const WorkoutStep({
    required this.exercise,
    this.sets,
    this.reps,
    this.durationSeconds,
    this.restSeconds,
  });
}
