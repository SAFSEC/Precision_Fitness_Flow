import 'exercise.dart';

enum TimerPhase { idle, work, rest, transition, completed }

class TimerState {
  final TimerPhase phase;
  final int remainingSeconds;
  final int currentRound;
  final int totalRounds;
  final int currentSetIndex;
  final int totalSets;
  final Exercise? currentExercise;
  final Exercise? nextExercise;
  final bool isRunning;

  const TimerState({
    required this.phase,
    required this.remainingSeconds,
    required this.currentRound,
    required this.totalRounds,
    required this.currentSetIndex,
    required this.totalSets,
    this.currentExercise,
    this.nextExercise,
    required this.isRunning,
  });

  TimerState copyWith({
    TimerPhase? phase,
    int? remainingSeconds,
    int? currentRound,
    int? totalRounds,
    int? currentSetIndex,
    int? totalSets,
    Exercise? currentExercise,
    Exercise? nextExercise,
    bool? isRunning,
    bool clearCurrentExercise = false,
    bool clearNextExercise = false,
  }) {
    return TimerState(
      phase: phase ?? this.phase,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      currentRound: currentRound ?? this.currentRound,
      totalRounds: totalRounds ?? this.totalRounds,
      currentSetIndex: currentSetIndex ?? this.currentSetIndex,
      totalSets: totalSets ?? this.totalSets,
      currentExercise: clearCurrentExercise ? null : (currentExercise ?? this.currentExercise),
      nextExercise: clearNextExercise ? null : (nextExercise ?? this.nextExercise),
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
