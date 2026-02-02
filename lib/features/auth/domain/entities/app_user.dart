import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String name;

  const AppUser({required this.name});

  @override
  List<Object?> get props => [name];
}
