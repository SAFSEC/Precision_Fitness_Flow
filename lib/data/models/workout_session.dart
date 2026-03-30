import 'package:hive/hive.dart';
part 'workout_session.g.dart';

@HiveType(typeId: 0)
class WorkoutSession extends HiveObject {
  @HiveField(0)
  late String workoutId;
  @HiveField(1)
  late DateTime completedAt;
  @HiveField(2)
  late int durationSeconds;
  @HiveField(3)
  late bool completed;
  @HiveField(4)
  late int week;
  @HiveField(5)
  late int dayOfWeek;

  WorkoutSession({
    required this.workoutId,
    required this.completedAt,
    required this.durationSeconds,
    required this.completed,
    required this.week,
    required this.dayOfWeek,
  });

  // Empty constructor for Hive
  WorkoutSession.empty();
}
