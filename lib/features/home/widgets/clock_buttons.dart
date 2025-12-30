import 'package:flutter/material.dart';
import '../models/today_attendance_model.dart';
import '../services/attendance_service.dart';

class ClockButtons extends StatefulWidget {
  final TodayAttendanceModel attendance;
  final void Function(TodayAttendanceModel updated) onUpdated;

  const ClockButtons({
    super.key,
    required this.attendance,
    required this.onUpdated,
  });

  @override
  State<ClockButtons> createState() => _ClockButtonsState();
}

class _ClockButtonsState extends State<ClockButtons> {
  bool _loading = false;

  /// Clock In
  Future<void> _clockIn() async {
    setState(() => _loading = true);
    try {
      await AttendanceService.clockIn(); // POST clock in
      final updated = await AttendanceService.getTodayAttendance(); // GET latest attendance
      widget.onUpdated(updated); // update UI
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  /// Clock Out
  Future<void> _clockOut() async {
    setState(() => _loading = true);
    try {
      await AttendanceService.clockOut(); // POST clock out
      final updated = await AttendanceService.getTodayAttendance(); // GET latest attendance
      widget.onUpdated(updated); // update UI
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  /// Show error
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasClockIn = widget.attendance.hasClockIn;
    final hasClockOut = widget.attendance.hasClockOut;

    // Tombol Clock In dan Clock Out sesuai logika
    final clockInEnabled = !_loading && !hasClockIn && !hasClockOut;
    final clockOutEnabled = !_loading && hasClockIn && !hasClockOut;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: clockInEnabled ? _clockIn : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Clock In'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: clockOutEnabled ? _clockOut : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clock Out'),
          ),
        ),
      ],
    );
  }
}
