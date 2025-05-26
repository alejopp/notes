import 'dart:math';

import 'package:bext_notes/core/constants/shared_preferences_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../profile/domain/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<UserEntity?> login(String email, String password) async {
    if (!_isValidEmailFormat(email) || password.length < 6) return null;

    final prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString(SharedPreferencesConstants.email.name);
    final savedPassword =
        prefs.getString(SharedPreferencesConstants.password.name);

    if (!_matchEmailAndPassword(email, savedEmail, password, savedPassword)) {
      return null;
    }

    final token = _generateToken(24);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString('token', token);

    return UserEntity(email: email, password: password, token: token);
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    final token = prefs.getString('token');
    if (email != null && password != null) {
      return UserEntity(email: email, password: password, token: token ?? '');
    }
    return null;
  }

  bool _isValidEmailFormat(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(email);
  }

  bool _matchEmailAndPassword(
    String email,
    String? savedEmail,
    String password,
    String? savedPassword,
  ) {
    if (savedEmail == null && savedPassword == null) return true;
    if (email == savedEmail && password == savedPassword) {
      return true;
    } else {
      return false;
    }
  }

  String _generateToken(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)])
        .join();
  }

  @override
  Future<String?> getCurrentToken() async {
    final prefs = await SharedPreferences.getInstance();
    final currentToken = prefs.getString(SharedPreferencesConstants.token.name);
    return currentToken;
  }
}
