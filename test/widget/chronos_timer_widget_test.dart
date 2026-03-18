import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:precision_fitness_flow/data/models/timer_state.dart';
import 'package:precision_fitness_flow/widgets/chronos_timer_widget.dart';

void main() {
  testWidgets('ChronosTimerWidget displays correct formatted time', (tester) async {
    const state = TimerState(
      phase: TimerPhase.work,
      remainingSeconds: 30,
      currentRound: 1,
      totalRounds: 4,
      currentSetIndex: 1,
      totalSets: 1,
      isRunning: true,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ChronosTimerWidget(
            timerState: state,
            maxSeconds: 30,
          ),
        ),
      ),
    );

    expect(find.text('00:30'), findsOneWidget);
  });
}
