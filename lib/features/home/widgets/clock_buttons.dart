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

  Future<void> _clockIn() async {
    setState(() => _loading = true);

    try {
      final result = await AttendanceService.clockIn();
      widget.onUpdated(result);
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _clockOut() async {
    setState(() => _loading = true);

    try {
      final result = await AttendanceService.clockOut();
      widget.onUpdated(result);
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasClockIn = widget.attendance.hasClockIn;
    final hasClockOut = widget.attendance.hasClockOut;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed:
                (!_loading && !hasClockIn) ? _clockIn : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Clock In'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed:
                (!_loading && hasClockIn && !hasClockOut)
                    ? _clockOut
                    : null,
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
