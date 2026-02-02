part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthLoginRequested extends AuthEvent {
  final String name;

  const AuthLoginRequested({required this.name});

  @override
  List<Object?> get props => [name];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
