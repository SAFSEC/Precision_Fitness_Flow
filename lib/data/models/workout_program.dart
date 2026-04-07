import 'training_day.dart';

class WorkoutProgram {
  final String id;
  final String title;
  final String description;
  final String category;
  final String? icon; // Optional icon for the selection menu
  final List<TrainingDay> days;

  const WorkoutProgram({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.icon,
    required this.days,
  });
}
