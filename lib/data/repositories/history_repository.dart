import 'package:hive/hive.dart';
import '../models/workout_session.dart';

class HistoryRepository {
  final Box<WorkoutSession> _historyBox;

  HistoryRepository(this._historyBox);

  List<WorkoutSession> getAllSessions() {
    return _historyBox.values.toList()..sort((a, b) => b.completedAt.compareTo(a.completedAt));
  }

  List<String> getCompletedWorkoutIds() {
    return _historyBox.values
        .where((session) => session.completed)
        .map((session) => session.workoutId)
        .toList();
  }

  Future<void> saveSession(WorkoutSession session) async {
    await _historyBox.add(session);
  }
}
