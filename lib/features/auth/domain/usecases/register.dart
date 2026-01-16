import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;
  const Register(this.repository);

  Future<AppUser> call({required String email, required String password}) {
    return repository.register(email: email, password: password);
  }
}
