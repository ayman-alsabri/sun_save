import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;
  const Login(this.repository);

  Future<AppUser> call({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}
