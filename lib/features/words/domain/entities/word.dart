import 'package:equatable/equatable.dart';

class Word extends Equatable {
  final String id;
  final String en;
  final String ar;

  const Word({required this.id, required this.en, required this.ar});

  @override
  List<Object?> get props => [id, en, ar];
}
