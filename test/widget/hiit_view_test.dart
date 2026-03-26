import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:precision_fitness_flow/core/services/audio_service.dart';
import 'package:precision_fitness_flow/data/workout_plan.dart';
import 'package:precision_fitness_flow/features/workout/hiit_view.dart';
import 'package:precision_fitness_flow/features/workout/workout_controller.dart';

class MockAudioService extends Mock implements AudioService {}

void main() {
  testWidgets('HiitView displays current round and runs through sequence', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;

    final mockAudioService = MockAudioService();
    when(() => mockAudioService.playTransition()).thenAnswer((_) async {});
    when(() => mockAudioService.playWork()).thenAnswer((_) async {});
    when(() => mockAudioService.playRest()).thenAnswer((_) async {});
    when(() => mockAudioService.playTick()).thenAnswer((_) async {});
    when(() => mockAudioService.playComplete()).thenAnswer((_) async {});

    final hiitDay = kProgramHybrid.days.firstWhere((day) => day.type == 'hiit');
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioServiceProvider.overrideWithValue(mockAudioService),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: SizedBox(
                   height: 1200, // force generous height to avoid overflow in test
                   child: HiitView(trainingDay: hiitDay),
                )
              ),
            ),
          ),
        ),
      ),
    );

    final context = tester.element(find.byType(HiitView));
    final container = ProviderScope.containerOf(context);
    
    container.read(workoutControllerProvider(hiitDay).notifier).startWorkout();
    
    await tester.pump();
    
    expect(find.text('Bereit machen!'), findsWidgets);
    expect(find.text('PREPARE'), findsOneWidget); 
    
    container.read(workoutControllerProvider(hiitDay).notifier).skipPhase();
    await tester.pump();
    
    expect(find.text(hiitDay.steps[0].exercise.name), findsWidgets);
    expect(find.text('WORK'), findsOneWidget); 

    // Add teardown to clear screen size
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });
}
