import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;

final voiceServiceProvider = Provider<VoiceService>((ref) => VoiceService());

class VoiceService {
  final FlutterTts _flutterTts = FlutterTts();
  final Completer<void> _initCompleter = Completer<void>();
  bool _isReady = false;

  VoiceService() {
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      if (Platform.isIOS) {
        await _flutterTts.setSharedInstance(true);
      }
      
      await _flutterTts.setLanguage("de-DE");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      
      _isReady = true;
      _initCompleter.complete();
    } catch (e) {
      print('TTS Initialization Error: $e');
      if (!_initCompleter.isCompleted) {
        _initCompleter.completeError(e);
      }
    }
  }

  Future<void> speak(String text) async {
    try {
      // Wait for initialization if it's still in progress
      if (!_isReady) {
        await _initCompleter.future.timeout(
          const Duration(seconds: 2),
          onTimeout: () => _isReady ? null : throw TimeoutException('TTS Init Timeout'),
        );
      }
      
      if (!_isReady) return;
      await _flutterTts.speak(text);
    } catch (e) {
      print('TTS Speak Error: $e');
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
