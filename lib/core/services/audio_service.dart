import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioService();
});

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  AudioService() {
    // AudioPlayer setup if necessary
  }

  Future<void> _playSound(String fileName) async {
    try {
      // audioplayers ^5.x uses AssetSource for local assets
      await _player.play(AssetSource('audio/$fileName'));
    } catch (e) {
      // Audio-Service: immer try-catch, kein App-Crash bei fehlendem Audio
      print('Audio playback error: $e');
    }
  }

  Future<void> playWork() => _playSound('beep_work.mp3');
  Future<void> playRest() => _playSound('beep_rest.mp3');
  Future<void> playTransition() => _playSound('beep_transition.mp3');
  Future<void> playTick() => _playSound('beep_work.mp3');
  
  Future<void> playComplete() async {
    try {
      await _player.play(AssetSource('audio/beep_work.mp3'));
      await Future.delayed(const Duration(milliseconds: 400));
      await _player.play(AssetSource('audio/beep_rest.mp3'));
      await Future.delayed(const Duration(milliseconds: 400));
      await _player.play(AssetSource('audio/beep_transition.mp3'));
    } catch (e) {
      print('Audio playback error during complete: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}
