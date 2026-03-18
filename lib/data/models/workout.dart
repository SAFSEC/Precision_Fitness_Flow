import 'exercise.dart';

class Workout {
  final String id;
  final String name;
  final List<Exercise> exercises;
  final int sets;
  final int repetitions;
  final int restSeconds;

  const Workout({
    required this.id,
    required this.name,
    required this.exercises,
    required this.sets,
    required this.repetitions,
    required this.restSeconds,
  });
}
