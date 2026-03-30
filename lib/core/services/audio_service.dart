import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioService();
});

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  
  // Pre-create sources for lower latency
  final AssetSource _workSource = AssetSource('audio/beep_work.wav');
  final AssetSource _restSource = AssetSource('audio/beep_rest.wav');
  final AssetSource _transitionSource = AssetSource('audio/beep_transition.wav');

  AudioService() {
    _init();
  }

  void _init() {
    // PlayerMode.lowLatency is optimized for short feedback sounds
    // and doesn't show up in system media controls.
    _player.setPlayerMode(PlayerMode.lowLatency);
  }

  Future<void> _playSound(Source source, String debugName) async {
    print('Audio: Playing $debugName');
    try {
      // audioplayers ^5.x: seek(zero) + play is often faster for repeated sounds
      // however play(source) is usually sufficient for lowLatency mode.
      await _player.stop(); // Ensue we start fresh
      await _player.play(source);
    } catch (e) {
      print('Audio: Playback error for $debugName: $e');
    }
  }

  Future<void> playWork() => _playSound(_workSource, 'beep_work.wav');
  Future<void> playRest() => _playSound(_restSource, 'beep_rest.wav');
  Future<void> playTransition() => _playSound(_transitionSource, 'beep_transition.wav');
  Future<void> playTick() => _playSound(_workSource, 'beep_work.wav');
  
  Future<void> playComplete() async {
    try {
      await _player.play(_workSource);
      await Future.delayed(const Duration(milliseconds: 400));
      await _player.play(_restSource);
      await Future.delayed(const Duration(milliseconds: 400));
      await _player.play(_transitionSource);
    } catch (e) {
      print('Audio playback error during complete: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}
