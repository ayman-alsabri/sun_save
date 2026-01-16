import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String email;

  const AppUser({required this.email});

  @override
  List<Object?> get props => [email];
}
