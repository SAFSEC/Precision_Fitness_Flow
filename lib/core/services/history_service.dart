import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../data/models/workout_session.dart';
import '../../data/repositories/history_repository.dart';

final historyBoxProvider = Provider<Box<WorkoutSession>>((ref) {
  return Hive.box<WorkoutSession>('history');
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final box = ref.watch(historyBoxProvider);
  return HistoryRepository(box);
});

final historyServiceProvider = StateNotifierProvider<HistoryService, List<WorkoutSession>>((ref) {
  final repository = ref.watch(historyRepositoryProvider);
  return HistoryService(repository);
});

class HistoryService extends StateNotifier<List<WorkoutSession>> {
  final HistoryRepository _repository;
  
  HistoryService(this._repository) : super(_repository.getAllSessions());

  Future<void> saveSession(WorkoutSession session) async {
    await _repository.saveSession(session);
    // Refresh the list immediately after saving
    state = _repository.getAllSessions();
  }

  void deleteSession(int index) {
    // Optional: implement if needed
  }
}

// Convenient provider for the history list itself
final historyListProvider = Provider<List<WorkoutSession>>((ref) {
  return ref.watch(historyServiceProvider);
});
