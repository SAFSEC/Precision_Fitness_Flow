import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

final hapticServiceProvider = Provider<HapticService>((ref) => HapticService());

class HapticService {
  Future<void> vibrate() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator ?? false) {
      Vibration.vibrate(duration: 500);
    }
  }
}
