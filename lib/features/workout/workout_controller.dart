import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../core/services/timer_service.dart';
import '../../data/models/training_day.dart';

// Provides the active workout controller
final workoutControllerProvider = StateNotifierProvider.family<WorkoutController, bool, TrainingDay>((ref, trainingDay) {
  final timerService = ref.read(timerServiceProvider.notifier);
  return WorkoutController(timerService, trainingDay);
});

class WorkoutController extends StateNotifier<bool> {
  final TimerService _timerService;
  final TrainingDay _trainingDay;

  WorkoutController(this._timerService, this._trainingDay) : super(false);

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void startWorkout() {
    WakelockPlus.enable();
    if (_trainingDay.type == 'hiit') {
      // 1 Runde – Nutzer wählt danach Beenden oder Neustart
      _timerService.startHiit(_trainingDay.steps, 1);
    } else {
      // Logic for Strength: Start with idle/first exercise
      // No active timer to start immediately for strength, it's set-based
      _timerService.cancel();
    }
  }

  void pauseWorkout() {
    WakelockPlus.disable();
    _timerService.pause();
  }

  void resumeWorkout() {
    WakelockPlus.enable();
    _timerService.resume();
  }

  void cancelWorkout() {
    WakelockPlus.disable();
    _timerService.cancel();
    state = true; // Mark as finished/cancelled to navigate away
  }
  
  void completeWorkout() {
    _timerService.completeWorkout();
  }
  
  void startStrengthRest(int restSeconds, int currentSet, int totalSets) {
    WakelockPlus.enable();
    _timerService.startStrengthRest(restSeconds, currentSet, totalSets);
  }

  void skipPhase() {
    _timerService.skipPhase();
  }

  void restartRound() {
    _timerService.restartRound();
  }
}
