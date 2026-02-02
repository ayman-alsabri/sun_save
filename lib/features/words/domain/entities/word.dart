import 'package:equatable/equatable.dart';

class Word extends Equatable {
  final String id;
  final String en;
  final String ar;
  final bool isSaved;

  const Word({
    required this.id,
    required this.en,
    required this.ar,
    this.isSaved = false,
  });

  Word copyWith({String? id, String? en, String? ar, bool? isSaved}) {
    return Word(
      id: id ?? this.id,
      en: en ?? this.en,
      ar: ar ?? this.ar,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [id, en, ar, isSaved];
}
