import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:precision_fitness_flow/core/services/audio_service.dart';
import 'package:precision_fitness_flow/core/services/haptic_service.dart';
import 'package:precision_fitness_flow/core/services/voice_service.dart';
import 'package:precision_fitness_flow/core/services/timer_service.dart';
import 'package:precision_fitness_flow/data/models/exercise.dart';
import 'package:precision_fitness_flow/data/models/timer_state.dart';
import 'package:precision_fitness_flow/data/models/workout_step.dart';
import 'package:precision_fitness_flow/core/constants/app_durations.dart';

class MockAudioService extends Mock implements AudioService {}
class MockHapticService extends Mock implements HapticService {}
class MockVoiceService extends Mock implements VoiceService {}

void main() {
  late TimerService timerService;
  late MockAudioService mockAudioService;
  late MockHapticService mockHapticService;
  late MockVoiceService mockVoiceService;

    final testSteps = [
      const WorkoutStep(
        durationSeconds: 30,
        restSeconds: 20,
        exercise: Exercise(
          id: 'e1',
          name: 'Exercise 1',
          nameEn: 'E1',
          type: ExerciseType.hiit,
          focus: [],
          executionHint: '',
          isPlyometric: false,
        ),
      ),
      const WorkoutStep(
        durationSeconds: 30,
        restSeconds: 20,
        exercise: Exercise(
          id: 'e2',
          name: 'Exercise 2',
          nameEn: 'E2',
          type: ExerciseType.hiit,
          focus: [],
          executionHint: '',
          isPlyometric: false,
        ),
      ),
    ];

  setUp(() {
    mockAudioService = MockAudioService();
    mockHapticService = MockHapticService();
    mockVoiceService = MockVoiceService();

    when(() => mockAudioService.playWork()).thenAnswer((_) async {});
    when(() => mockAudioService.playRest()).thenAnswer((_) async {});
    when(() => mockAudioService.playTransition()).thenAnswer((_) async {});
    when(() => mockAudioService.playTick()).thenAnswer((_) async {});
    when(() => mockAudioService.playComplete()).thenAnswer((_) async {});
    
    when(() => mockHapticService.vibrate()).thenAnswer((_) async {});
    when(() => mockVoiceService.speak(any())).thenAnswer((_) async {});

    timerService = TimerService(mockAudioService, mockHapticService, mockVoiceService);
  });

  tearDown(() {
    timerService.dispose();
  });

  test('Initial state is idle', () {
    expect(timerService.state.phase, TimerPhase.idle);
    expect(timerService.state.isRunning, false);
  });

  test('HIIT timer sequence (Work -> Rest -> Work -> Clean Transition/Complete)', () {
    timerService.startHiit(testSteps, 2); // 2 rounds
    
    // Initial phase is Transition
    expect(timerService.state.phase, TimerPhase.transition);
    expect(timerService.state.remainingSeconds, kTransitionSeconds);
    expect(timerService.state.currentRound, 1);
    expect(timerService.state.nextExercise?.id, 'e1');
    
    // Skip Transition -> Work (e1)
    timerService.skipPhase();
    expect(timerService.state.phase, TimerPhase.work);
    expect(timerService.state.remainingSeconds, kHiitWorkSeconds);
    expect(timerService.state.currentExercise?.id, 'e1');
    expect(timerService.state.nextExercise?.id, 'e2');
    verify(() => mockAudioService.playWork()).called(1);
    
    // Skip Work -> Rest
    timerService.skipPhase();
    expect(timerService.state.phase, TimerPhase.rest);
    expect(timerService.state.remainingSeconds, kHiitRestSeconds);
    expect(timerService.state.currentExercise, null); // pause
    expect(timerService.state.nextExercise?.id, 'e2');
    verify(() => mockAudioService.playRest()).called(1);
    
    // Skip Rest -> Work (e2)
    timerService.skipPhase();
    expect(timerService.state.phase, TimerPhase.work);
    expect(timerService.state.remainingSeconds, kHiitWorkSeconds);
    expect(timerService.state.currentExercise?.id, 'e2');
    
    // Skip e2 Work -> Transition (end of round 1)
    timerService.skipPhase();
    expect(timerService.state.phase, TimerPhase.transition);
    expect(timerService.state.remainingSeconds, kHiitTransSeconds);
    expect(timerService.state.currentRound, 2);
    expect(timerService.state.nextExercise?.id, 'e1');
    // transition played at start and between rounds -> 2 times
    verify(() => mockAudioService.playTransition()).called(2);

    // Skip Transition -> Work (e1, round 2)
    timerService.skipPhase();
    expect(timerService.state.phase, TimerPhase.work);
    
    // Skip Work -> Rest
    timerService.skipPhase();
    expect(timerService.state.phase, TimerPhase.rest);

    // Skip Rest -> Work (e2, round 2)
    timerService.skipPhase();
    expect(timerService.state.phase, TimerPhase.work);

    // Skip Work (e2) -> RoundCompleted! (end of round 2, user chooses Beenden or Neustart)
    timerService.skipPhase();
    expect(timerService.state.phase, TimerPhase.roundCompleted);
    verify(() => mockAudioService.playComplete()).called(1);
  });

  test('Strength timer sequence (Rest -> Idle)', () {
    timerService.startStrengthRest(60, 1, 3);
    
    expect(timerService.state.phase, TimerPhase.rest);
    expect(timerService.state.remainingSeconds, 60);
    expect(timerService.state.isRunning, true);
    
    // End rest
    timerService.skipPhase();
    expect(timerService.state.phase, TimerPhase.idle);
    expect(timerService.state.isRunning, false);
    verify(() => mockAudioService.playWork()).called(1); // should signal work (next set)
  });
}
