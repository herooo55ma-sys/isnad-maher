import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _key = 'password_hash';
  static const _defaultPassword = '1234';

  static String _hash(String s) => sha256.convert(utf8.encode(s)).toString();

  static Future<bool> verify(String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_key)) {
      await prefs.setString(_key, _hash(_defaultPassword));
    }
    return prefs.getString(_key) == _hash(password);
  }

  static Future<void> changePassword(String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _hash(newPassword));
  }
}
