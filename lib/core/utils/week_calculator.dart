import '../../data/workout_plan.dart';
import '../../data/models/training_day.dart';

class WeekCalculator {
  /// Ermittelt den aktuell relevanten Trainingstag für den Nutzer
  /// unter Berücksichtigung der Historie (welcher Tag war der letzte?)
  static TrainingDay getNextActiveDay(List<String> completedIds) {
    if (completedIds.isEmpty) return kWorkoutPlan.first;
    
    // Finde den ersten Trainingstag im Plan, dessen ID noch _nicht_
    // in der Liste der abgeschlossenen IDs steht.
    for (var day in kWorkoutPlan) {
      if (!completedIds.contains(day.id)) {
        return day;
      }
    }
    
    // Falls kompletter Plan absolviert ist, gib den letzten Tag zurück.
    // In V2 könnte hier ein Neustart-Dialog erfolgen.
    return kWorkoutPlan.last;
  }

  /// Gibt den Status eines bestimmten Tags zurück
  static bool isDayCompleted(String dayId, List<String> completedIds) {
    return completedIds.contains(dayId);
  }
}
