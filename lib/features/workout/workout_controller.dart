import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/timer_service.dart';
import '../../data/models/training_day.dart';
import '../../data/models/workout_session.dart';

// Provides the active workout controller
final workoutControllerProvider = StateNotifierProvider.family<WorkoutController, bool, TrainingDay>((ref, trainingDay) {
  final timerService = ref.read(timerServiceProvider.notifier);
  // We just return a boolean state for "isFinished" 
  return WorkoutController(timerService, trainingDay);
});

class WorkoutController extends StateNotifier<bool> {
  final TimerService _timerService;
  final TrainingDay _trainingDay;

  WorkoutController(this._timerService, this._trainingDay) : super(false);

  void startWorkout() {
    if (_trainingDay.type == 'hiit') {
      // Logic for HIIT: usually 4 rounds in week 1, 5 in week 2, 6 in week 3
      int rounds = 4;
      if (_trainingDay.week == 2) rounds = 5;
      if (_trainingDay.week == 3) rounds = 6;
      
      _timerService.startHiit(_trainingDay.exercises, rounds);
    } else {
      // Logic for Strength: Start with idle/first exercise
      // No active timer to start immediately for strength, it's set-based
      _timerService.cancel();
    }
  }

  void pauseWorkout() {
    _timerService.pause();
  }

  void resumeWorkout() {
    _timerService.resume();
  }

  void cancelWorkout() {
    _timerService.cancel();
    state = true; // Mark as finished/cancelled to navigate away
  }
  
  void startStrengthRest(int restSeconds, int currentSet, int totalSets) {
    _timerService.startStrengthRest(restSeconds, currentSet, totalSets);
  }

  void skipPhase() {
    _timerService.skipPhase();
  }
}
