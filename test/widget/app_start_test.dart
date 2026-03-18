import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:precision_fitness_flow/app.dart';
import 'package:precision_fitness_flow/core/services/history_service.dart';
import 'package:precision_fitness_flow/data/repositories/history_repository.dart';
import 'package:precision_fitness_flow/data/models/workout_session.dart';

class FakeHistoryRepository implements HistoryRepository {
  @override
  List<WorkoutSession> getAllSessions() => [];

  @override
  List<String> getCompletedWorkoutIds() => [];

  @override
  Future<void> saveSession(WorkoutSession session) async {}
}

void main() {
  testWidgets('App starts and shows Home Page', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          historyRepositoryProvider.overrideWithValue(FakeHistoryRepository()),
        ],
        child: const PrecisionFitnessFlowApp(),
      ),
    );
    await tester.pumpAndSettle();
    
    expect(find.text('Dein heutiges Training'), findsOneWidget);
  });
}
