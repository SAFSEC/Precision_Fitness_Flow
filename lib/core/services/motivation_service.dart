import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/workout_session.dart';
import '../providers/active_program_provider.dart';
import 'history_service.dart';

class MotivationStats {
  final int currentStreak;
  final int totalCompleted;
  final int hiitCompleted;
  final int strengthCompleted;
  final Map<DateTime, bool> activeDays;

  MotivationStats({
    required this.currentStreak,
    required this.totalCompleted,
    required this.hiitCompleted,
    required this.strengthCompleted,
    required this.activeDays,
  });
}

final motivationStatsProvider = Provider<MotivationStats>((ref) {
  final history = ref.watch(historyListProvider);
  final activeProgram = ref.watch(activeProgramProvider);
  
  // Create a quick lookup for workout types
  final typeLookup = <String, String>{};
  for (final day in activeProgram.days) {
    typeLookup[day.id] = day.type;
  }

  // Sort by date descending (newest first)
  final sortedHistory = List<WorkoutSession>.from(history)
    ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

  final activeDays = <DateTime, bool>{};
  int totalCompleted = 0;
  int hiitCompleted = 0;
  int strengthCompleted = 0;

  for (final session in sortedHistory) {
    if (session.completed) {
      totalCompleted++;
      
      final type = typeLookup[session.workoutId];
      if (type == 'hiit') {
        hiitCompleted++;
      } else if (type != null && type.contains('strength')) {
        strengthCompleted++;
      }

      // Normalize to Date only (Midnight)
      final dateOnly = DateTime(
        session.completedAt.year,
        session.completedAt.month,
        session.completedAt.day,
      );
      activeDays[dateOnly] = true;
    }
  }

  // Calculate Streak
  int streak = 0;
  if (activeDays.isNotEmpty) {
    final now = DateTime.now();
    DateTime checkDate = DateTime(now.year, now.month, now.day);
    
    // If no workout today, check if there was one yesterday to continue the streak
    if (!activeDays.containsKey(checkDate)) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    // While there's a workout on the checkDate, increment streak and go back one day
    while (activeDays.containsKey(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }
  }

  return MotivationStats(
    currentStreak: streak,
    totalCompleted: totalCompleted,
    hiitCompleted: hiitCompleted,
    strengthCompleted: strengthCompleted,
    activeDays: activeDays,
  );
});
