import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSourceException implements Exception {
  final String message;
  const AuthLocalDataSourceException(this.message);

  @override
  String toString() => 'AuthLocalDataSourceException: $message';
}

abstract class AuthLocalDataSource {
  Future<String?> getCurrentEmail();
  Future<void> saveUser({required String email, required String password});
  Future<void> setLoggedInEmail(String? email);
  Future<Map<String, String>?> getUserCredentials(String email);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _usersKey = 'auth_users';
  static const _loggedInEmailKey = 'auth_logged_in_email';

  final SharedPreferences prefs;
  const AuthLocalDataSourceImpl(this.prefs);

  @override
  Future<String?> getCurrentEmail() async => prefs.getString(_loggedInEmailKey);

  @override
  Future<void> setLoggedInEmail(String? email) async {
    if (email == null) {
      await prefs.remove(_loggedInEmailKey);
    } else {
      await prefs.setString(_loggedInEmailKey, email);
    }
  }

  Map<String, dynamic> _readUsers() {
    final raw = prefs.getString(_usersKey);
    if (raw == null || raw.isEmpty) return <String, dynamic>{};
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) return <String, dynamic>{};
    return decoded;
  }

  Future<void> _writeUsers(Map<String, dynamic> users) async {
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  @override
  Future<Map<String, String>?> getUserCredentials(String email) async {
    final users = _readUsers();
    final entry = users[email];
    if (entry is Map) {
      final password = entry['password'];
      final savedEmail = entry['email'];
      if (password is String && savedEmail is String) {
        return {'email': savedEmail, 'password': password};
      }
    }
    return null;
  }

  @override
  Future<void> saveUser({
    required String email,
    required String password,
  }) async {
    final users = _readUsers();
    if (users.containsKey(email)) {
      throw const AuthLocalDataSourceException('User already exists');
    }
    users[email] = {'email': email, 'password': password};
    await _writeUsers(users);
  }
}
