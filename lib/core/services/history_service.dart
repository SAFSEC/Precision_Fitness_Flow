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

final historyListProvider = Provider<List<WorkoutSession>>((ref) {
  final repository = ref.watch(historyRepositoryProvider);
  return repository.getAllSessions();
});
