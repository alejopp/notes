import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../profile/domain/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<UserEntity?> login(String email, String password) async {
    if (!_isValidEmail(email) || password.length < 6) return null;

    final token = _generateToken(24);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString('token', token);

    return UserEntity(email: email, password: password, token: token);
  }

  @override
  Future<void> logout() async {}

  @override
  Future<UserEntity?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    final token = prefs.getString('token');
    if (email != null && password != null && token != null) {
      return UserEntity(email: email, password: password, token: token);
    }
    return null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(email);
  }

  String _generateToken(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)])
        .join();
  }
}
