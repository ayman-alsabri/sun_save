import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

enum SpeechLang { en, ar }

typedef SpeechProgress = void Function(int currentIndex, int total);

typedef SpeechStart = void Function();
typedef SpeechDone = void Function();

typedef SpeechError = void Function(Object error);

typedef SpeechStateChanged = void Function(bool isPlaying);

class TtsService {
  final FlutterTts _tts;

  // Internal state for flow control
  bool _isStopped = false;
  bool _isPaused = false;
  Completer<void>? _resumeSignal;

  // State to track current speech context
  String? currentText;
  SpeechLang? currentLang;

  TtsService(this._tts);

  Future<void> stop() async {
    _isStopped = true;
    _isPaused = false;
    _unlockResume();
    await _tts.stop();
  }

  Future<void> pause() async {
    _isPaused = true;
    if (_resumeSignal == null || _resumeSignal!.isCompleted) {
      _resumeSignal = Completer<void>();
    }
    // We stop the actual audio because most engines don't support
    // mid-sentence resume reliably without the specific resume method.
    await _tts.stop();
  }

  Future<void> resume() async {
    if (_isPaused) {
      _isPaused = false;
      _unlockResume();
      // We don't call _tts.resume() here. The loop logic handles
      // restarting the current item.
    }
  }

  void _unlockResume() {
    if (_resumeSignal != null && !_resumeSignal!.isCompleted) {
      _resumeSignal!.complete();
      _resumeSignal = null;
    }
  }

  Future<void> _setupAwaitCompletion() async {
    await _tts.awaitSpeakCompletion(true);
  }

  Future<void> speak(String text, {SpeechLang lang = SpeechLang.en}) async {
    if (text.trim().isEmpty) return;
    currentText = text;
    currentLang = lang;
    await _setupAwaitCompletion();

    switch (lang) {
      case SpeechLang.en:
        await _tts.setLanguage('en-US');
        break;
      case SpeechLang.ar:
        await _tts.setLanguage('ar');
        break;
    }

    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.speak(text);
  }

  Future<void> speakSequence(
    List<({String text, SpeechLang lang})> items, {
    int iterations = 1,
    SpeechProgress? onProgress,
    SpeechStart? onStart,
    SpeechDone? onDone,
    SpeechError? onError,
  }) async {
    // 1. Reset state
    await stop();
    _isStopped = false;
    _isPaused = false;
    _resumeSignal = null;

    await _setupAwaitCompletion();

    final total = items.length;
    if (total == 0) return;

    Completer<void>? completion;

    // 2. Setup Handlers
    _tts.setCompletionHandler(() {
      completion?.complete();
    });
    _tts.setCancelHandler(() {
      completion?.complete();
    });
    _tts.setErrorHandler((msg) {
      completion?.completeError(Exception(msg));
    });

    try {
      onStart?.call();
      final iters = iterations.clamp(1, 10);

      for (var iter = 0; iter < iters; iter++) {
        if (_isStopped) break;

        for (var i = 0; i < items.length; i++) {
          if (_isStopped) break;

          // PAUSE CHECK (Before speaking)
          if (_isPaused) {
            await _resumeSignal?.future;
            if (_isStopped) break;
          }

          onProgress?.call(i, total);
          final item = items[i];

          completion = Completer<void>();

          await speak(item.text, lang: item.lang);

          // Wait for utterance to finish (or be stopped by pause)
          await completion.future;

          // PAUSE CHECK (After speaking/interruption)
          // If we are paused here, it means stop() was called mid-speech.
          // We decrement i so that when we resume, we retry the SAME item.
          if (_isPaused) {
            i--;
          }
        }
      }

      if (!_isStopped) {
        onDone?.call();
      }
    } catch (e) {
      onError?.call(e);
      rethrow;
    }
  }
}
