part of 'words_bloc.dart';

enum WordsStatus { initial, loading, loaded, failure }

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
  final String? message;

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
    String? message,
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
    message,
  ];
}
