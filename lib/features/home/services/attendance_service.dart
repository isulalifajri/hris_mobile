import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../models/today_attendance_model.dart';

class AttendanceService {
  /// Ambil token dari SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// GET /api/home/today
  static Future<TodayAttendanceModel> getTodayAttendance() async {
    final token = await _getToken();
    final response = await ApiClient.get('home/today', token: token);

    if (response.statusCode != 200) {
      throw Exception('Failed to load today attendance');
    }

    final data = jsonDecode(response.body);
    return TodayAttendanceModel.fromJson(data);
  }

  /// POST /api/home/clock-in
  static Future<TodayAttendanceModel> clockIn() async {
    final token = await _getToken();
    final response = await ApiClient.post('home/clock-in', token: token);

    final data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Clock in failed');
    }

    return TodayAttendanceModel(clockIn: data['clock_in'], clockOut: null);
  }

  /// POST /api/home/clock-out
  static Future<TodayAttendanceModel> clockOut() async {
    final token = await _getToken();
    final response = await ApiClient.post('home/clock-out', token: token);

    final data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Clock out failed');
    }

    return TodayAttendanceModel(clockIn: null, clockOut: data['clock_out']);
  }
}
