import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/timer_state.dart';
import '../../data/models/exercise.dart';
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
  
  List<Exercise> _exercises = [];
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

  void startHiit(List<Exercise> exercises, int totalRounds) {
    _timer?.cancel();
    _exercises = exercises;
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
      nextExercise: _exercises.isNotEmpty ? _exercises[0] : null,
      isRunning: true,
    );
    
    _audioService.playTransition();
    _voiceService.speak("Training startet. ${_exercises[0].name}");
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

  void cancel() {
    _timer?.cancel();
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

  void skipPhase() {
    if (state.isRunning) {
      _handlePhaseEnd();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        final newRemaining = state.remainingSeconds - 1;
        
        if (newRemaining == 10 && _isHiit && state.phase != TimerPhase.transition) {
           _voiceService.speak("Noch 10 Sekunden");
        }
        
        if (newRemaining > 0 && newRemaining <= 3) {
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

    // HIIT Logic
    switch (state.phase) {
      case TimerPhase.transition: // Transition -> Work
        _hapticService.vibrate();
        _audioService.playWork();
        state = state.copyWith(
          phase: TimerPhase.work,
          remainingSeconds: kHiitWorkSeconds,
          currentExercise: _exercises[_currentExerciseIndex],
          nextExercise: _currentExerciseIndex < _exercises.length - 1 ? _exercises[_currentExerciseIndex + 1] : (_exercises.isNotEmpty ? _exercises[0] : null),
        );
        break;
      case TimerPhase.work: // Work -> Rest or Sequence Transition or Complete
        bool isLastExerciseInRound = _currentExerciseIndex == _exercises.length - 1;
        bool isLastRound = state.currentRound == state.totalRounds;

        if (isLastExerciseInRound && isLastRound) {
          // Training beendet
           _timer?.cancel();
           _audioService.playComplete();
           state = state.copyWith(
             phase: TimerPhase.completed,
             remainingSeconds: 0,
             isRunning: false,
             clearCurrentExercise: true,
             clearNextExercise: true,
           );
        } else if (isLastExerciseInRound) {
          // Runde beendet -> Transition
          _hapticService.vibrate();
          _audioService.playTransition();
          _voiceService.speak("Runde beendet. Nächste Übung: ${_exercises[0].name}");
          _currentExerciseIndex = 0; 
          state = state.copyWith(
            phase: TimerPhase.transition,
            remainingSeconds: kHiitTransSeconds, 
            currentRound: state.currentRound + 1,
            clearCurrentExercise: true, 
            nextExercise: _exercises[0],
          );
        } else {
          // Nächste Übung -> Rest
          _hapticService.vibrate();
          _audioService.playRest();
          _voiceService.speak("Pause. Nächste Übung: ${_exercises[_currentExerciseIndex + 1].name}");
          _currentExerciseIndex++;
          state = state.copyWith(
            phase: TimerPhase.rest,
            remainingSeconds: kHiitRestSeconds,
            clearCurrentExercise: true, 
            nextExercise: _exercises[_currentExerciseIndex],
          );
        }
        break;
      case TimerPhase.rest: // Rest -> Work
        _hapticService.vibrate();
        _audioService.playWork();
        state = state.copyWith(
          phase: TimerPhase.work,
          remainingSeconds: kHiitWorkSeconds,
          currentExercise: _exercises[_currentExerciseIndex],
          nextExercise: _currentExerciseIndex < _exercises.length - 1 ? _exercises[_currentExerciseIndex + 1] : (_exercises.isNotEmpty ? _exercises[0] : null),
        );
        break;
      case TimerPhase.idle:
      case TimerPhase.completed:
        _timer?.cancel();
        break;
    }
  }
}
