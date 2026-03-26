import 'package:flutter_test/flutter_test.dart';
import 'package:precision_fitness_flow/core/utils/week_calculator.dart';
import 'package:precision_fitness_flow/data/workout_plan.dart';


void main() {
  test('Next Active Day empty history -> returns day 1 Option A', () {
    final activeDay = WeekCalculator.getNextActiveDay([], kProgramHybrid);
    expect(activeDay.id, 'mon_opt_a');
  });

  test('Next Active Day partial history -> returns correct day', () {
    final activeDay = WeekCalculator.getNextActiveDay(['mon_opt_a', 'tue_opt_b'], kProgramHybrid);
    expect(activeDay.id, 'wed_opt_a');
  });

  test('Next Active Day skips intermediate uncompleted days -> returns correct day', () {
    // Falls Nutzer z.B. Tag 1 übersprungen hat und nur Tag 2 gemacht hat:
    final activeDay = WeekCalculator.getNextActiveDay(['tue_opt_b'], kProgramHybrid);
    expect(activeDay.id, 'mon_opt_a'); // Bleibt mon_opt_a weil erster im Plan
  });

  test('Skips Option B if Option A of same logical day is completed', () {
    final activeDay = WeekCalculator.getNextActiveDay(['mon_opt_a'], kProgramHybrid);
    expect(activeDay.id, 'tue_opt_a'); // Es sollte 'mon_opt_b' überspringen und zu Dienstag springen
  });
}
