import '../../data/models/training_day.dart';
import '../../data/models/workout_program.dart';

class WeekCalculator {
  static TrainingDay getNextActiveDay(List<String> completedIds, WorkoutProgram program) {
    if (program.days.isEmpty) throw Exception("Program has no days");

    for (final day in program.days) {
      if (completedIds.contains(day.id)) continue;

      if (day.dayOfWeek != null) {
        final siblingCompleted = program.days.any((sibling) => 
            sibling.week == day.week && 
            sibling.dayOfWeek == day.dayOfWeek && 
            sibling.id != day.id && 
            completedIds.contains(sibling.id));
            
        if (siblingCompleted) {
          continue;
        }
      }

      return day;
    }
    
    return program.days.first;
  }

  static bool isDayCompleted(String dayId, List<String> completedIds) {
    return completedIds.contains(dayId);
  }

  static double calculateProgress(List<String> completedIds, WorkoutProgram program) {
    if (program.days.isEmpty) return 0.0;
    
    final uniqueLogicalDays = program.days.map((d) => '${d.week}_${d.dayOfWeek}').toSet().length;
    if (uniqueLogicalDays == 0) return 0.0;

    int completedLogicalDays = 0;
    final Set<String> countedLogicalDays = {};
    
    for (final d in program.days) {
        if (completedIds.contains(d.id)) {
            final logicalKey = '${d.week}_${d.dayOfWeek}';
            if (!countedLogicalDays.contains(logicalKey)) {
                completedLogicalDays++;
                countedLogicalDays.add(logicalKey);
            }
        }
    }
    
    return (completedLogicalDays / uniqueLogicalDays).clamp(0.0, 1.0);
  }
}
