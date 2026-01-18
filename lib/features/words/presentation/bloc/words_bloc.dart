import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/app_settings.dart';
import '../../../../core/services/notifications_service.dart';
import '../../../../core/services/settings_local_data_source.dart';
import '../../../../core/services/tts_service.dart';
import '../../domain/entities/word.dart';
import '../../domain/usecases/add_word.dart';
import '../../domain/usecases/delete_word.dart';
import '../../domain/usecases/get_saved_word_ids.dart';
import '../../domain/usecases/get_words.dart';
import '../../domain/usecases/set_word_saved.dart';
import '../../domain/usecases/update_word.dart';

part 'words_event.dart';
part 'words_state.dart';

class WordsBloc extends Bloc<WordsEvent, WordsState> {
  final GetWords getWords;
  final GetSavedWordIds getSavedWordIds;
  final SetWordSaved setWordSaved;
  final AddWord addWord;
  final UpdateWord updateWord;
  final DeleteWord deleteWord;
  final TtsService tts;
  final SettingsLocalDataSource settingsLocal;
  final NotificationsService notifications;

  List<Word> _originalWords = const [];

  WordsBloc({
    required this.getWords,
    required this.getSavedWordIds,
    required this.setWordSaved,
    required this.addWord,
    required this.updateWord,
    required this.deleteWord,
    required this.tts,
    required this.settingsLocal,
    required this.notifications,
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
    on<WordUpdated>(_onWordUpdated);
    on<WordDeleted>(_onWordDeleted);
    on<SpeakPauseRequested>(_onSpeakPauseRequested);
    on<SpeakResumeRequested>(_onSpeakResumeRequested);
    on<SpeakStopRequested>(_onSpeakStopRequested);
  }

  Future<void> _onWordsRequested(
    WordsRequested event,
    Emitter<WordsState> emit,
  ) async {
    emit(state.copyWith(status: WordsStatus.loading));
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
          message: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: WordsStatus.failure,
          message: WordsMessage(
            WordsMessageKey.loadFailed,
            args: {'error': e.toString()},
          ),
        ),
      );
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
          message: WordsMessage(
            event.saved ? WordsMessageKey.saved : WordsMessageKey.unsaved,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          message: WordsMessage(
            WordsMessageKey.failed,
            args: {'error': e.toString()},
          ),
        ),
      );
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

  // NOTE: Auto-rescheduling notifications from the bloc would require l10n.
  // Scheduling is currently handled from Settings where AppLocalizations exists.

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
      items.add((text: word.en, lang: SpeechLang.en));
    }
    if (showAr) {
      items.add((text: word.ar, lang: SpeechLang.ar));
    }

    if (items.isEmpty) {
      emit(
        state.copyWith(
          message: const WordsMessage(WordsMessageKey.nothingToSpeakBothHidden),
        ),
      );
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
          message: null,
        ),
      );

      await tts.speakSequence(items, iterations: settings.ttsIterations);
    } catch (e) {
      emit(
        state.copyWith(
          message: WordsMessage(
            WordsMessageKey.ttsFailed,
            args: {'error': e.toString()},
          ),
        ),
      );
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
      emit(
        state.copyWith(
          message: const WordsMessage(WordsMessageKey.nothingToSpeak),
        ),
      );
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
        message: null,
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
          items.add((text: word.en, lang: SpeechLang.en));
        }
        if (showAr) {
          items.add((text: word.ar, lang: SpeechLang.ar));
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
      emit(
        state.copyWith(
          message: WordsMessage(
            WordsMessageKey.ttsFailed,
            args: {'error': e.toString()},
          ),
        ),
      );
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
      // ignore (platform may not support resume)
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
          message: null,
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
    final newWord = Word(id: const Uuid().v4(), en: event.en, ar: event.ar);
    try {
      await addWord(newWord);
      final newWords = [newWord, ...state.words];
      _originalWords = [newWord, ..._originalWords];
      emit(state.copyWith(words: newWords));
    } catch (e) {
      // Error handling TODO
    }
  }

  Future<void> _onWordUpdated(
    WordUpdated event,
    Emitter<WordsState> emit,
  ) async {
    try {
      await updateWord(event.word);
      final newWords = state.words.map((w) {
        return w.id == event.word.id ? event.word : w;
      }).toList();

      _originalWords = _originalWords.map((w) {
        return w.id == event.word.id ? event.word : w;
      }).toList();

      emit(state.copyWith(words: newWords));
    } catch (e) {
      // Error handling TODO
    }
  }

  Future<void> _onWordDeleted(
    WordDeleted event,
    Emitter<WordsState> emit,
  ) async {
    try {
      await deleteWord(event.wordId);
      final newWords = state.words.where((w) => w.id != event.wordId).toList();
      _originalWords = _originalWords
          .where((w) => w.id != event.wordId)
          .toList();

      // Also ensure savedIds doesn't keep a deleted id.
      final nextSaved = state.savedIds.toSet()..remove(event.wordId);
      emit(state.copyWith(words: newWords, savedIds: nextSaved));
    } catch (e) {
      // Error handling TODO
    }
  }
}
