import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource local;
  const AuthRepositoryImpl(this.local);

  @override
  Future<AppUser?> getCurrentUser() async {
    final email = await local.getCurrentEmail();
    if (email == null) return null;
    return AppUser(email: email);
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final creds = await local.getUserCredentials(email);
    if (creds == null) {
      throw Exception('User not found');
    }
    if (creds['password'] != password) {
      throw Exception('Invalid credentials');
    }
    await local.setLoggedInEmail(email);
    return AppUser(email: email);
  }

  @override
  Future<AppUser> register({
    required String email,
    required String password,
  }) async {
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }
    await local.saveUser(email: email, password: password);
    await local.setLoggedInEmail(email);
    return AppUser(email: email);
  }

  @override
  Future<void> logout() async {
    await local.setLoggedInEmail(null);
  }
}
