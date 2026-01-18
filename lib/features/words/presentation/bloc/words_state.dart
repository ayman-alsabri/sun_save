part of 'words_bloc.dart';

enum WordsStatus { initial, loading, loaded, failure }

enum SpeakingStatus { idle, playing, paused }

enum SpeakingMode { none, unsavedList, savedList, single }

enum WordsMessageKey {
  saved,
  unsaved,
  nothingToSpeak,
  nothingToSpeakBothHidden,
  ttsFailed,
  failed,
  loadFailed,
}

class WordsMessage extends Equatable {
  final WordsMessageKey key;
  final Map<String, Object?> args;

  const WordsMessage(this.key, {this.args = const {}});

  @override
  List<Object?> get props => [key, args];
}

class WordsState extends Equatable {
  final WordsStatus status;
  final List<Word> words;
  final Set<String> savedIds;
  final bool showEn;
  final bool showAr;
  final Map<String, bool> showEnById;
  final Map<String, bool> showArById;
  final String? speakingWordId;
  final bool isShuffled;
  final SpeakingStatus speakingStatus;
  final SpeakingMode speakingMode;
  final int speakingItemIndex;
  final int speakingItemTotal;
  final WordsMessage? message;

  const WordsState({
    required this.status,
    required this.words,
    required this.savedIds,
    required this.showEn,
    required this.showAr,
    required this.showEnById,
    required this.showArById,
    required this.speakingWordId,
    required this.isShuffled,
    required this.speakingStatus,
    required this.speakingMode,
    required this.speakingItemIndex,
    required this.speakingItemTotal,
    this.message,
  });

  const WordsState.initial()
    : this(
        status: WordsStatus.initial,
        words: const [],
        savedIds: const {},
        showEn: true,
        showAr: true,
        showEnById: const {},
        showArById: const {},
        speakingWordId: null,
        isShuffled: false,
        speakingStatus: SpeakingStatus.idle,
        speakingMode: SpeakingMode.none,
        speakingItemIndex: -1,
        speakingItemTotal: 0,
      );

  WordsState copyWith({
    WordsStatus? status,
    List<Word>? words,
    Set<String>? savedIds,
    bool? showEn,
    bool? showAr,
    Map<String, bool>? showEnById,
    Map<String, bool>? showArById,
    String? speakingWordId,
    bool? isShuffled,
    SpeakingStatus? speakingStatus,
    SpeakingMode? speakingMode,
    int? speakingItemIndex,
    int? speakingItemTotal,
    WordsMessage? message,
  }) {
    return WordsState(
      status: status ?? this.status,
      words: words ?? this.words,
      savedIds: savedIds ?? this.savedIds,
      showEn: showEn ?? this.showEn,
      showAr: showAr ?? this.showAr,
      showEnById: showEnById ?? this.showEnById,
      showArById: showArById ?? this.showArById,
      speakingWordId: speakingWordId,
      isShuffled: isShuffled ?? this.isShuffled,
      speakingStatus: speakingStatus ?? this.speakingStatus,
      speakingMode: speakingMode ?? this.speakingMode,
      speakingItemIndex: speakingItemIndex ?? this.speakingItemIndex,
      speakingItemTotal: speakingItemTotal ?? this.speakingItemTotal,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    words,
    savedIds,
    showEn,
    showAr,
    showEnById,
    showArById,
    speakingWordId,
    isShuffled,
    speakingStatus,
    speakingMode,
    speakingItemIndex,
    speakingItemTotal,
    message,
  ];
}
