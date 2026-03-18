import 'package:flutter_test/flutter_test.dart';
import 'package:precision_fitness_flow/core/utils/week_calculator.dart';


void main() {
  test('Next Active Day empty history -> returns day 1', () {
    final activeDay = WeekCalculator.getNextActiveDay([]);
    expect(activeDay.id, 'w1d1');
  });

  test('Next Active Day partial history -> returns correct day', () {
    final activeDay = WeekCalculator.getNextActiveDay(['w1d1', 'w1d2']);
    expect(activeDay.id, 'w1d3');
  });

  test('Next Active Day skips intermediate uncompleted days -> returns correct day', () {
    // Falls Nutzer z.B. Tag 1 übersprungen hat und nur Tag 2 gemacht hat:
    final activeDay = WeekCalculator.getNextActiveDay(['w1d2']);
    expect(activeDay.id, 'w1d1'); // Bleibt w1d1 weil erster im Plan
  });
}
