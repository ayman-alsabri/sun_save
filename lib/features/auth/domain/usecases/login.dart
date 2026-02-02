import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;
  const Login(this.repository);

  Future<AppUser> call({required String name}) {
    return repository.login(name: name);
  }
}
