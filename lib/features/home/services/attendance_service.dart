import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/network/api_client.dart';
import '../models/today_attendance_model.dart';

class AttendanceService {
  /// GET /api/home/today
  static Future<TodayAttendanceModel> getTodayAttendance() async {
    final http.Response response = await ApiClient.get('home/today');

    if (response.statusCode != 200) {
      throw Exception('Failed to load today attendance');
    }

    final data = jsonDecode(response.body);
    return TodayAttendanceModel.fromJson(data);
  }

  /// POST /api/home/clock-in
  static Future<TodayAttendanceModel> clockIn() async {
    final response = await ApiClient.post('home/clock-in');
    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Clock in failed');
    }

    return TodayAttendanceModel(
      clockIn: data['clock_in'],
      clockOut: null,
    );
  }

  /// POST /api/home/clock-out
  static Future<TodayAttendanceModel> clockOut() async {
    final response = await ApiClient.post('home/clock-out');
    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Clock out failed');
    }

    return TodayAttendanceModel(
      clockIn: null,
      clockOut: data['clock_out'],
    );
  }
}
