import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/api_client.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../auth/screens/login_screen.dart';
import '../../../main.dart'; // pastikan path ini benar untuk navigatorKey

class AuthResponse {
  final String token;
  final UserModel user;

  AuthResponse({
    required this.token,
    required this.user,
  });
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService {
  /// LOGIN
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final http.Response response = await ApiClient.post(
      'auth/login',
      body: {
        'email': email,
        'password': password,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw AuthException(data['message'] ?? 'Login gagal');
    }

    // Simpan token & user ke SharedPreferences jika mau
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', data['access_token']);
    await prefs.setString('user', jsonEncode(data['user']));

    return AuthResponse(
      token: data['access_token'],
      user: UserModel.fromJson(data['user']),
    );
  }

  /// LOGOUT SAFE (bisa dipanggil dari OverlayEntry atau widget apapun)
  static Future<void> logout() async {
    try {
      // Panggil API logout jika ada
      await ApiClient.post('auth/logout'); // sesuaikan endpoint

      // Hapus token/session
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user');

      // Navigasi ke login screen menggunakan navigatorKey global
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Logout failed: $e');
    }
  }
}
