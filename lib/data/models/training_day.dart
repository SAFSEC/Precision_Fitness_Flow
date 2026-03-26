import 'workout_step.dart';

class TrainingDay {
  final String id; // e.g., 'w1d1a'
  final int week;
  final int? dayOfWeek; // 1 = Montag, ..., 7 = Sonntag
  final String title;
  final String type; // 'strength', 'hiit', 'rest'
  final String? optionLabel; // 'A', 'B'
  final List<WorkoutStep> steps;

  const TrainingDay({
    required this.id,
    required this.week,
    this.dayOfWeek,
    required this.title,
    required this.type,
    this.optionLabel,
    required this.steps,
  });
}
