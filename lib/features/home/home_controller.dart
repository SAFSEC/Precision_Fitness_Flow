import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/training_day.dart';
import '../../core/utils/week_calculator.dart';
import '../../core/services/history_service.dart';

import '../../core/providers/active_program_provider.dart';
import '../../data/models/workout_program.dart';

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>((ref) {
  final historyRepo = ref.watch(historyRepositoryProvider);
  final activeProgram = ref.watch(activeProgramProvider);
  return HomeController(historyRepo, activeProgram);
});

class HomeState {
  final TrainingDay activeDay;
  final List<String> completedIds;
  final int currentWeek;

  const HomeState({
    required this.activeDay,
    required this.completedIds,
    required this.currentWeek,
  });

  HomeState copyWith({
    TrainingDay? activeDay,
    List<String>? completedIds,
    int? currentWeek,
  }) {
    return HomeState(
      activeDay: activeDay ?? this.activeDay,
      completedIds: completedIds ?? this.completedIds,
      currentWeek: currentWeek ?? this.currentWeek,
    );
  }
}

class HomeController extends StateNotifier<HomeState> {
  final _historyRepo;
  final WorkoutProgram _activeProgram;

  HomeController(this._historyRepo, this._activeProgram) : super(_initialState(_historyRepo, _activeProgram)) {
    // Falls sich im Hintergrund etwas an der History ändert,
    // könnten wir hier Listener anhängen oder eine refresh-Methode anbieten.
  }

  static HomeState _initialState(historyRepo, WorkoutProgram program) {
    final completedIds = historyRepo.getCompletedWorkoutIds();
    final activeDay = WeekCalculator.getNextActiveDay(completedIds, program);
    return HomeState(
      activeDay: activeDay,
      completedIds: completedIds,
      currentWeek: activeDay.week,
    );
  }

  void refreshData() {
    final completedIds = _historyRepo.getCompletedWorkoutIds();
    final activeDay = WeekCalculator.getNextActiveDay(completedIds, _activeProgram);
    state = state.copyWith(
      activeDay: activeDay,
      completedIds: completedIds,
      currentWeek: activeDay.week,
    );
  }
}
