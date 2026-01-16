import 'package:flutter_tts/flutter_tts.dart';

enum SpeechLang { en, ar }

typedef SpeechProgress = void Function(int currentIndex, int total);

typedef SpeechStart = void Function();
typedef SpeechDone = void Function();

typedef SpeechError = void Function(Object error);

class TtsService {
  final FlutterTts _tts;

  TtsService(this._tts);

  Future<void> stop() => _tts.stop();

  Future<void> speak(String text, {SpeechLang lang = SpeechLang.en}) async {
    if (text.trim().isEmpty) return;

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

  /// Speaks items sequentially, with optional repeats and progress callbacks.
  Future<void> speakSequence(
    List<({String text, SpeechLang lang})> items, {
    int iterations = 1,
    SpeechProgress? onProgress,
    SpeechStart? onStart,
    SpeechDone? onDone,
    SpeechError? onError,
  }) async {
    // Stop anything already speaking.
    await stop();

    // Ensure we await completion between items.
    await _tts.awaitSpeakCompletion(true);

    final total = items.length;
    if (total == 0) return;

    try {
      onStart?.call();
      final iters = iterations.clamp(1, 10);
      for (var iter = 0; iter < iters; iter++) {
        for (var i = 0; i < items.length; i++) {
          onProgress?.call(i, total);
          final item = items[i];
          await speak(item.text, lang: item.lang);
        }
      }
      onDone?.call();
    } catch (e) {
      onError?.call(e);
      rethrow;
    }
  }
}
