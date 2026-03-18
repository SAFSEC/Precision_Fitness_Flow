import 'exercise.dart';

class TrainingDay {
  final int week;
  final int dayOfWeek;
  final String type; // 'strengthA', 'strengthB', 'hiit', 'rest'
  final List<Exercise> exercises;

  const TrainingDay({
    required this.week,
    required this.dayOfWeek,
    required this.type,
    required this.exercises,
  });

  String get id => 'w${week}d$dayOfWeek';
}
