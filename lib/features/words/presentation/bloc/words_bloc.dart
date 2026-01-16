import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/services/app_settings.dart';
import '../../../../core/services/settings_local_data_source.dart';
import '../../../../core/services/tts_service.dart';
import '../../domain/entities/word.dart';
import '../../domain/usecases/add_word.dart';
import '../../domain/usecases/get_saved_word_ids.dart';
import '../../domain/usecases/get_words.dart';
import '../../domain/usecases/set_word_saved.dart';

part 'words_event.dart';
part 'words_state.dart';

class WordsBloc extends Bloc<WordsEvent, WordsState> {
  final GetWords getWords;
  final GetSavedWordIds getSavedWordIds;
  final SetWordSaved setWordSaved;
  final AddWord addWord;
  final TtsService tts;
  final SettingsLocalDataSource settingsLocal;

  List<Word> _originalWords = const [];

  WordsBloc({
    required this.getWords,
    required this.getSavedWordIds,
    required this.setWordSaved,
    required this.addWord,
    required this.tts,
    required this.settingsLocal,
  }) : super(const WordsState.initial()) {
    on<WordsRequested>(_onWordsRequested);
    on<WordsSavedIdsRequested>(_onSavedIdsRequested);
    on<WordSavedToggled>(_onSavedToggled);
    on<WordsShowEnToggled>(_onShowEnAllToggled);
    on<WordsShowArToggled>(_onShowArAllToggled);
    on<WordShowEnToggled>(_onShowEnOneToggled);
    on<WordShowArToggled>(_onShowArOneToggled);
    on<SpeakWordRequested>(_onSpeakWordRequested);
    on<SpeakListRequested>(_onSpeakListRequested);
    on<WordsShuffleRequested>(_onShuffleRequested);
    on<WordsResetOrderRequested>(_onResetOrderRequested);
    on<WordAdded>(_onWordAdded);
    on<SpeakPauseRequested>(_onSpeakPauseRequested);
    on<SpeakResumeRequested>(_onSpeakResumeRequested);
    on<SpeakStopRequested>(_onSpeakStopRequested);
  }

  Future<void> _onWordsRequested(
    WordsRequested event,
    Emitter<WordsState> emit,
  ) async {
    emit(state.copyWith(status: WordsStatus.loading, message: null));
    try {
      final words = await getWords();
      _originalWords = words;
      final savedIds = await getSavedWordIds();
      emit(
        state.copyWith(
          status: WordsStatus.loaded,
          words: words,
          savedIds: savedIds,
          isShuffled: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: WordsStatus.failure, message: e.toString()));
    }
  }

  Future<void> _onSavedIdsRequested(
    WordsSavedIdsRequested event,
    Emitter<WordsState> emit,
  ) async {
    try {
      final savedIds = await getSavedWordIds();
      emit(state.copyWith(savedIds: savedIds));
    } catch (_) {
      // ignore
    }
  }

  Future<void> _onSavedToggled(
    WordSavedToggled event,
    Emitter<WordsState> emit,
  ) async {
    try {
      await setWordSaved(wordId: event.wordId, saved: event.saved);
      final next = state.savedIds.toSet();
      if (event.saved) {
        next.add(event.wordId);
      } else {
        next.remove(event.wordId);
      }
      emit(
        state.copyWith(
          savedIds: next,
          message: event.saved ? 'Saved' : 'Unsaved',
        ),
      );
    } catch (e) {
      emit(state.copyWith(message: 'Failed: ${e.toString()}'));
    }
  }

  void _onShowEnAllToggled(WordsShowEnToggled event, Emitter<WordsState> emit) {
    emit(state.copyWith(showEn: event.show));
  }

  void _onShowArAllToggled(WordsShowArToggled event, Emitter<WordsState> emit) {
    emit(state.copyWith(showAr: event.show));
  }

  void _onShowEnOneToggled(WordShowEnToggled event, Emitter<WordsState> emit) {
    final map = Map<String, bool>.from(state.showEnById);
    map[event.wordId] = event.show;
    emit(state.copyWith(showEnById: map));
  }

  void _onShowArOneToggled(WordShowArToggled event, Emitter<WordsState> emit) {
    final map = Map<String, bool>.from(state.showArById);
    map[event.wordId] = event.show;
    emit(state.copyWith(showArById: map));
  }

  Future<AppSettings> _settings() => settingsLocal.read();

  SpeechLang _speechLangForApp(AppLanguage appLang, SpeechLang fallback) {
    return switch (appLang) {
      AppLanguage.en => SpeechLang.en,
      AppLanguage.ar => SpeechLang.ar,
      AppLanguage.system => fallback,
    };
  }

  Future<void> _onSpeakWordRequested(
    SpeakWordRequested event,
    Emitter<WordsState> emit,
  ) async {
    final word = state.words.where((w) => w.id == event.wordId).firstOrNull;
    if (word == null) return;

    final settings = await _settings();

    final showEn = state.showEnById[word.id] ?? state.showEn;
    final showAr = state.showArById[word.id] ?? state.showAr;

    final items = <({String text, SpeechLang lang})>[];
    if (showEn) {
      items.add((
        text: word.en,
        lang: _speechLangForApp(settings.language, SpeechLang.en),
      ));
    }
    if (showAr) {
      items.add((
        text: word.ar,
        lang: _speechLangForApp(settings.language, SpeechLang.ar),
      ));
    }

    if (items.isEmpty) {
      emit(state.copyWith(message: 'Nothing to speak (both hidden)'));
      return;
    }

    try {
      emit(
        state.copyWith(
          speakingWordId: word.id,
          speakingStatus: SpeakingStatus.playing,
          speakingMode: SpeakingMode.single,
          speakingItemIndex: 0,
          speakingItemTotal: 1,
        ),
      );

      await tts.speakSequence(items, iterations: settings.ttsIterations);
    } catch (e) {
      emit(state.copyWith(message: 'TTS failed: ${e.toString()}'));
    } finally {
      emit(
        state.copyWith(
          speakingWordId: null,
          speakingStatus: SpeakingStatus.idle,
          speakingMode: SpeakingMode.none,
          speakingItemIndex: -1,
          speakingItemTotal: 0,
        ),
      );
    }
  }

  Future<void> _onSpeakListRequested(
    SpeakListRequested event,
    Emitter<WordsState> emit,
  ) async {
    final settings = await _settings();

    // Build the list of words in the requested tab.
    final listWords = <Word>[];
    for (final w in state.words) {
      final isSaved = state.savedIds.contains(w.id);
      if (event.savedOnly && !isSaved) continue;
      if (!event.savedOnly && isSaved) continue;
      listWords.add(w);
    }

    if (listWords.isEmpty) {
      emit(state.copyWith(message: 'Nothing to speak'));
      return;
    }

    emit(
      state.copyWith(
        speakingStatus: SpeakingStatus.playing,
        speakingMode: event.savedOnly
            ? SpeakingMode.savedList
            : SpeakingMode.unsavedList,
        speakingItemIndex: 0,
        speakingItemTotal: listWords.length,
        speakingWordId: listWords.first.id,
      ),
    );

    try {
      for (var wi = 0; wi < listWords.length; wi++) {
        // If user pressed stop, end immediately.
        if (state.speakingStatus == SpeakingStatus.idle) break;

        final word = listWords[wi];
        final showEn = state.showEnById[word.id] ?? state.showEn;
        final showAr = state.showArById[word.id] ?? state.showAr;

        final items = <({String text, SpeechLang lang})>[];
        if (showEn) {
          items.add((
            text: word.en,
            lang: _speechLangForApp(settings.language, SpeechLang.en),
          ));
        }
        if (showAr) {
          items.add((
            text: word.ar,
            lang: _speechLangForApp(settings.language, SpeechLang.ar),
          ));
        }

        if (items.isEmpty) continue;

        // Highlight remains on the same word while EN/AR are spoken.
        emit(
          state.copyWith(
            speakingWordId: word.id,
            speakingStatus: SpeakingStatus.playing,
            speakingItemIndex: wi,
            speakingItemTotal: listWords.length,
          ),
        );

        // Iterations apply per-word.
        await tts.speakSequence(items, iterations: settings.ttsIterations);
      }
    } catch (e) {
      emit(state.copyWith(message: 'TTS failed: ${e.toString()}'));
    } finally {
      emit(
        state.copyWith(
          speakingWordId: null,
          speakingStatus: SpeakingStatus.idle,
          speakingMode: SpeakingMode.none,
          speakingItemIndex: -1,
          speakingItemTotal: 0,
        ),
      );
    }
  }

  Future<void> _onSpeakPauseRequested(
    SpeakPauseRequested event,
    Emitter<WordsState> emit,
  ) async {
    try {
      await tts.pause();
      emit(state.copyWith(speakingStatus: SpeakingStatus.paused));
    } catch (_) {
      // ignore
    }
  }

  Future<void> _onSpeakResumeRequested(
    SpeakResumeRequested event,
    Emitter<WordsState> emit,
  ) async {
    try {
      await tts.resume();
      emit(state.copyWith(speakingStatus: SpeakingStatus.playing));
    } catch (_) {
      // ignore
    }
  }

  Future<void> _onSpeakStopRequested(
    SpeakStopRequested event,
    Emitter<WordsState> emit,
  ) async {
    try {
      await tts.stop();
    } finally {
      emit(
        state.copyWith(
          speakingWordId: null,
          speakingStatus: SpeakingStatus.idle,
          speakingMode: SpeakingMode.none,
          speakingItemIndex: -1,
          speakingItemTotal: 0,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await tts.stop();
    return super.close();
  }

  void _onShuffleRequested(
    WordsShuffleRequested event,
    Emitter<WordsState> emit,
  ) {
    if (state.words.isEmpty) return;
    final next = [...state.words];
    next.shuffle(Random());
    emit(state.copyWith(words: next, isShuffled: true));
  }

  void _onResetOrderRequested(
    WordsResetOrderRequested event,
    Emitter<WordsState> emit,
  ) {
    if (_originalWords.isEmpty) return;
    emit(state.copyWith(words: _originalWords, isShuffled: false));
  }

  Future<void> _onWordAdded(WordAdded event, Emitter<WordsState> emit) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final id = 'custom_$now';
      final word = Word(id: id, en: event.en.trim(), ar: event.ar.trim());

      await addWord(word);
      if (event.addToSaved) {
        await setWordSaved(wordId: id, saved: true);
      }

      final words = await getWords();
      _originalWords = words;
      final savedIds = await getSavedWordIds();
      emit(
        state.copyWith(words: words, savedIds: savedIds, message: 'Word added'),
      );
    } catch (e) {
      emit(state.copyWith(message: 'Add failed: ${e.toString()}'));
    }
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
