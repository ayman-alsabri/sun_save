import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSourceException implements Exception {
  final String message;
  const AuthLocalDataSourceException(this.message);

  @override
  String toString() => 'AuthLocalDataSourceException: $message';
}

abstract class AuthLocalDataSource {
  Future<String?> getUserName();
  Future<void> setUserName(String? name);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _loggedInNameKey = 'auth_logged_in_name';

  final SharedPreferences prefs;
  const AuthLocalDataSourceImpl(this.prefs);

  @override
  Future<String?> getUserName() async => prefs.getString(_loggedInNameKey);

  @override
  Future<void> setUserName(String? name) async {
    if (name == null) {
      await prefs.remove(_loggedInNameKey);
    } else {
      await prefs.setString(_loggedInNameKey, name);
    }
  }
}
