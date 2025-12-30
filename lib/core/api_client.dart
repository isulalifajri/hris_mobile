import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config/api_config.dart';

class ApiClient {
  static Map<String, String> _headers({String? token}) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');

    return await http
        .post(
          url,
          headers: _headers(token: token),
          body: jsonEncode(body ?? {}),
        )
        .timeout(ApiConfig.timeout);
  }
}
