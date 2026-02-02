import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource local;
  const AuthRepositoryImpl(this.local);

  @override
  Future<AppUser?> getCurrentUser() async {
    final name = await local.getUserName();
    if (name == null) return null;
    return AppUser(name: name);
  }

  @override
  Future<AppUser> login({required String name}) async {
    await local.setUserName(name);
    return AppUser(name: name);
  }

  @override
  Future<void> logout() async {
    await local.setUserName(null);
  }
}
