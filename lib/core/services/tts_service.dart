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

  TtsService(this._tts);

  Future<void> stop() => _tts.stop();

  Future<void> pause() => _tts.pause();

  Future<void> resume() async {
    // continueHandler is only supported on some platforms.
    final handler = _tts.continueHandler;
    if (handler != null) {
      handler();
    }
  }

  Future<void> _setupAwaitCompletion() async {
    await _tts.awaitSpeakCompletion(true);
  }

  Future<void> speak(String text, {SpeechLang lang = SpeechLang.en}) async {
    if (text.trim().isEmpty) return;

    await _setupAwaitCompletion();

    // Best-effort language selection.
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

  /// Speaks items sequentially and reliably awaits each utterance.
  Future<void> speakSequence(
    List<({String text, SpeechLang lang})> items, {
    int iterations = 1,
    SpeechProgress? onProgress,
    SpeechStart? onStart,
    SpeechDone? onDone,
    SpeechError? onError,
  }) async {
    await stop();

    // Some platforms need setAwaitSpeakCompletion before speaking.
    await _setupAwaitCompletion();

    final total = items.length;
    if (total == 0) return;

    // Use a completion completer to ensure we really wait for each item.
    Completer<void>? completion;
    _tts.setCompletionHandler(() {
      completion?.complete();
      completion = null;
    });
    _tts.setCancelHandler(() {
      completion?.complete();
      completion = null;
    });
    _tts.setErrorHandler((msg) {
      completion?.completeError(Exception(msg));
      completion = null;
    });

    try {
      onStart?.call();
      final iters = iterations.clamp(1, 10);

      for (var iter = 0; iter < iters; iter++) {
        for (var i = 0; i < items.length; i++) {
          onProgress?.call(i, total);
          final item = items[i];

          completion = Completer<void>();
          await speak(item.text, lang: item.lang);
          await completion!.future;
        }
      }

      onDone?.call();
    } catch (e) {
      onError?.call(e);
      rethrow;
    }
  }
}
