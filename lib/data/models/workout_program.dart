import 'training_day.dart';

class WorkoutProgram {
  final String id;
  final String title;
  final String description;
  final List<TrainingDay> days;

  const WorkoutProgram({
    required this.id,
    required this.title,
    required this.description,
    required this.days,
  });
}
