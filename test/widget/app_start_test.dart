import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:precision_fitness_flow/app.dart';
import 'package:precision_fitness_flow/core/services/history_service.dart';
import 'package:precision_fitness_flow/data/repositories/history_repository.dart';
import 'package:precision_fitness_flow/data/models/workout_session.dart';
import 'package:precision_fitness_flow/core/providers/active_program_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';

class FakeHistoryRepository implements HistoryRepository {
  @override
  List<WorkoutSession> getAllSessions() => [];

  @override
  List<String> getCompletedWorkoutIds() => [];

  @override
  Future<void> saveSession(WorkoutSession session) async {}
}

class MockSettingsBox extends Mock implements Box<String> {}

void main() {
  testWidgets('App starts and shows Home Page', (tester) async {
    final mockSettingsBox = MockSettingsBox();
    when(() => mockSettingsBox.get('active_program_id')).thenReturn('hybrid_pp');
    when(() => mockSettingsBox.put(any(), any())).thenAnswer((_) async {});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyRepositoryProvider.overrideWithValue(FakeHistoryRepository()),
          settingsBoxProvider.overrideWithValue(mockSettingsBox),
        ],
        child: const PrecisionFitnessFlowApp(),
      ),
    );
    await tester.pumpAndSettle();
    
    expect(find.text('Wähle dein heutiges Training'), findsOneWidget);
  });
}
