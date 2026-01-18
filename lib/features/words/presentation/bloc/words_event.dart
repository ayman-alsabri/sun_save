part of 'words_bloc.dart';

sealed class WordsEvent extends Equatable {
  const WordsEvent();

  @override
  List<Object?> get props => [];
}

class WordsRequested extends WordsEvent {
  const WordsRequested();
}

class WordsSavedIdsRequested extends WordsEvent {
  const WordsSavedIdsRequested();
}

class WordSavedToggled extends WordsEvent {
  final String wordId;
  final bool saved;
  const WordSavedToggled({required this.wordId, required this.saved});

  @override
  List<Object?> get props => [wordId, saved];
}

class WordsShowEnToggled extends WordsEvent {
  final bool show;
  const WordsShowEnToggled(this.show);

  @override
  List<Object?> get props => [show];
}

class WordsShowArToggled extends WordsEvent {
  final bool show;
  const WordsShowArToggled(this.show);

  @override
  List<Object?> get props => [show];
}

class WordShowEnToggled extends WordsEvent {
  final String wordId;
  final bool show;
  const WordShowEnToggled({required this.wordId, required this.show});

  @override
  List<Object?> get props => [wordId, show];
}

class WordShowArToggled extends WordsEvent {
  final String wordId;
  final bool show;
  const WordShowArToggled({required this.wordId, required this.show});

  @override
  List<Object?> get props => [wordId, show];
}

class SpeakWordRequested extends WordsEvent {
  final String wordId;
  const SpeakWordRequested(this.wordId);

  @override
  List<Object?> get props => [wordId];
}

class SpeakListRequested extends WordsEvent {
  final bool savedOnly;
  const SpeakListRequested({required this.savedOnly});

  @override
  List<Object?> get props => [savedOnly];
}

class WordsShuffleRequested extends WordsEvent {
  const WordsShuffleRequested();
}

class WordsResetOrderRequested extends WordsEvent {
  const WordsResetOrderRequested();
}

class WordAdded extends WordsEvent {
  final String en;
  final String ar;
  final bool addToSaved;
  const WordAdded({
    required this.en,
    required this.ar,
    required this.addToSaved,
  });

  @override
  List<Object?> get props => [en, ar, addToSaved];
}

class WordUpdated extends WordsEvent {
  final Word word;
  const WordUpdated(this.word);

  @override
  List<Object?> get props => [word];
}

class WordDeleted extends WordsEvent {
  final String wordId;
  const WordDeleted(this.wordId);

  @override
  List<Object?> get props => [wordId];
}

class SpeakPauseRequested extends WordsEvent {
  const SpeakPauseRequested();
}

class SpeakResumeRequested extends WordsEvent {
  const SpeakResumeRequested();
}

class SpeakStopRequested extends WordsEvent {
  const SpeakStopRequested();
}
