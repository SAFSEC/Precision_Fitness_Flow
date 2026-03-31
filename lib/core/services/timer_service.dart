import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/timer_state.dart';
import '../../data/models/workout_step.dart';
import '../constants/app_durations.dart';
import 'audio_service.dart';
import 'haptic_service.dart';
import 'voice_service.dart';

final timerServiceProvider = StateNotifierProvider<TimerService, TimerState>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  final hapticService = ref.watch(hapticServiceProvider);
  final voiceService = ref.watch(voiceServiceProvider);
  return TimerService(audioService, hapticService, voiceService);
});

class TimerService extends StateNotifier<TimerState> {
  final AudioService _audioService;
  final HapticService _hapticService;
  final VoiceService _voiceService;
  Timer? _timer;
  
  List<WorkoutStep> _steps = [];
  int _currentExerciseIndex = 0;
  bool _isHiit = true;

  TimerService(this._audioService, this._hapticService, this._voiceService)
      : super(const TimerState(
          phase: TimerPhase.idle,
          remainingSeconds: 0,
          currentRound: 1,
          totalRounds: 1,
          currentSetIndex: 1,
          totalSets: 1,
          isRunning: false,
        ));

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startHiit(List<WorkoutStep> steps, int totalRounds) {
    _timer?.cancel();
    _steps = steps;
    _currentExerciseIndex = 0;
    _isHiit = true;
    
    state = TimerState(
      phase: TimerPhase.transition, // Start with prep/transition
      remainingSeconds: kTransitionSeconds,
      currentRound: 1,
      totalRounds: totalRounds,
      currentSetIndex: 1,
      totalSets: 1,
      currentExercise: null,
      nextExercise: _steps.isNotEmpty ? _steps[0].exercise : null,
      isRunning: true,
    );
    
    _audioService.playTransition();
    if (_steps.isNotEmpty) {
      // Delay voice for a moment to ensure user is ready and engine is warm
      Future.delayed(const Duration(milliseconds: 500), () {
        _voiceService.speak("Training startet. ${_steps[0].exercise.name}");
      });
    }
    _startTimer();
  }

  void startStrengthRest(int restSeconds, int currentSet, int totalSets) {
    _timer?.cancel();
    _isHiit = false;
    
    state = state.copyWith(
      phase: TimerPhase.rest,
      remainingSeconds: restSeconds,
      currentSetIndex: currentSet,
      totalSets: totalSets,
      isRunning: true,
      clearCurrentExercise: true,
      clearNextExercise: true,
    );
    
    _startTimer();
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void resume() {
    if (!state.isRunning && state.phase != TimerPhase.idle && state.phase != TimerPhase.completed) {
      state = state.copyWith(isRunning: true);
      _startTimer();
    }
  }

  void completeWorkout() {
    _timer?.cancel();
    _audioService.playComplete();
    state = state.copyWith(
      phase: TimerPhase.completed,
      remainingSeconds: 0,
      isRunning: false,
      clearCurrentExercise: true,
      clearNextExercise: true,
    );
  }

  void cancel() {
    _timer?.cancel();
    _voiceService.stop();
    state = const TimerState(
      phase: TimerPhase.idle,
      remainingSeconds: 0,
      currentRound: 1,
      totalRounds: 1,
      currentSetIndex: 1,
      totalSets: 1,
      isRunning: false,
    );
  }

  void restartRound() {
    _timer?.cancel();
    _currentExerciseIndex = 0;
    state = TimerState(
      phase: TimerPhase.transition,
      remainingSeconds: kTransitionSeconds,
      currentRound: 1,
      totalRounds: state.totalRounds,
      currentSetIndex: 1,
      totalSets: 1,
      currentExercise: null,
      nextExercise: _steps.isNotEmpty ? _steps[0].exercise : null,
      isRunning: true,
    );
    _audioService.playTransition();
    if (_steps.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _voiceService.speak("Neue Runde. ${_steps[0].exercise.name}");
      });
    }
    _startTimer();
  }

  void skipPhase() {
    if (state.isRunning && state.phase != TimerPhase.roundCompleted) {
      _handlePhaseEnd();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        final newRemaining = state.remainingSeconds - 1;
        
        if (newRemaining == 10 && _isHiit && state.phase == TimerPhase.work) {
           _voiceService.speak("Noch 10 Sekunden");
        }
        
        if (newRemaining == 5 && 
            (state.phase == TimerPhase.work || state.phase == TimerPhase.rest || state.phase == TimerPhase.transition)) {
           _voiceService.speak("Noch 5 Sekunden");
        }
        
        if (newRemaining > 0 && newRemaining <= 5) {
           _audioService.playTick();
        }
        
        state = state.copyWith(remainingSeconds: newRemaining);
      } else {
        _handlePhaseEnd();
      }
    });
  }

  void _handlePhaseEnd() {
    if (!_isHiit) {
      // Strength rest ended
      _timer?.cancel();
      _hapticService.vibrate();
      _audioService.playWork(); // Signal to start next set
      state = state.copyWith(
        phase: TimerPhase.idle,
        remainingSeconds: 0,
        isRunning: false,
      );
      return;
    }

    if (_steps.isEmpty) return; // Fail safe

    // HIIT Logic
    switch (state.phase) {
      case TimerPhase.transition: // Transition -> Work
        _hapticService.vibrate();
        _audioService.playWork();
        state = state.copyWith(
          phase: TimerPhase.work,
          remainingSeconds: _steps[_currentExerciseIndex].durationSeconds ?? kHiitWorkSeconds,
          currentExercise: _steps[_currentExerciseIndex].exercise,
          nextExercise: _currentExerciseIndex < _steps.length - 1 ? _steps[_currentExerciseIndex + 1].exercise : _steps[0].exercise,
        );
        break;
      case TimerPhase.work: // Work -> Rest or Sequence Transition or Complete
        bool isLastExerciseInRound = _currentExerciseIndex == _steps.length - 1;
        bool isLastRound = state.currentRound == state.totalRounds;

        if (isLastExerciseInRound && isLastRound) {
          // Runde beendet – Nutzer wählt Beenden oder Neustart
          _timer?.cancel();
          _hapticService.vibrate();
          _audioService.playComplete();
          _voiceService.speak("Runde abgeschlossen. Super Arbeit!");
          state = state.copyWith(
            phase: TimerPhase.roundCompleted,
            remainingSeconds: 0,
            isRunning: false,
            clearCurrentExercise: true,
            clearNextExercise: true,
          );
          return;
        } else if (isLastExerciseInRound) {
          // Runde beendet -> Transition
          _hapticService.vibrate();
          _audioService.playTransition();
          _voiceService.speak("Runde beendet. Nächste Übung: ${_steps[0].exercise.name}");
          _currentExerciseIndex = 0; 
          state = state.copyWith(
            phase: TimerPhase.transition,
            remainingSeconds: kHiitTransSeconds, 
            currentRound: state.currentRound + 1,
            clearCurrentExercise: true, 
            nextExercise: _steps[0].exercise,
          );
        } else {
          // Nächste Übung -> Rest
          _hapticService.vibrate();
          _audioService.playRest();
          _voiceService.speak("Pause. Nächste Übung: ${_steps[_currentExerciseIndex + 1].exercise.name}");
          _currentExerciseIndex++;
          state = state.copyWith(
            phase: TimerPhase.rest,
            remainingSeconds: _steps[_currentExerciseIndex - 1].restSeconds ?? kHiitRestSeconds,
            clearCurrentExercise: true, 
            nextExercise: _steps[_currentExerciseIndex].exercise,
          );
        }
        break;
      case TimerPhase.rest: // Rest -> Work
        _hapticService.vibrate();
        _audioService.playWork();
        state = state.copyWith(
          phase: TimerPhase.work,
          remainingSeconds: _steps[_currentExerciseIndex].durationSeconds ?? kHiitWorkSeconds,
          currentExercise: _steps[_currentExerciseIndex].exercise,
          nextExercise: _currentExerciseIndex < _steps.length - 1 ? _steps[_currentExerciseIndex + 1].exercise : _steps[0].exercise,
        );
        break;
      case TimerPhase.idle:
      case TimerPhase.completed:
        _timer?.cancel();
        break;
    }
  }
}
