import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/api_client.dart';
import '../models/user_model.dart';

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

    return AuthResponse(
      token: data['access_token'],
      user: UserModel.fromJson(data['user']),
    );
  }
}
