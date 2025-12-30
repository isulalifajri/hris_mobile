import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../auth/models/user_model.dart';
import '../../auth/services/auth_service.dart';
import '../models/today_attendance_model.dart';
import '../services/attendance_service.dart';
import '../widgets/clock_buttons.dart';
import '../widgets/live_clock.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodayAttendanceModel? _attendance;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTodayAttendance();
  }

  Future<void> _loadTodayAttendance() async {
    try {
      final result = await AttendanceService.getTodayAttendance();
      if (mounted) setState(() => _attendance = result ?? TodayAttendanceModel());
    } catch (e) {
      debugPrint('Failed load attendance: $e');
      if (mounted) setState(() => _attendance = TodayAttendanceModel());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 11) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }


  @override
  Widget build(BuildContext context) {
    final attendance = _attendance ?? TodayAttendanceModel();

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadTodayAttendance,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome, ${widget.user.name}',
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(_greeting(),
                                  style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                          /// Avatar + Dropdown Logout
                          _UserAvatar(user: widget.user),
                        ],
                      ),

                      const SizedBox(height: 32),

                      /// LIVE CLOCK
                      const Center(child: LiveClock()),

                      const SizedBox(height: 24),

                      /// CLOCK BUTTONS & QUICK ACTION
                      ClockButtons(
                        attendance: attendance,
                        onUpdated: (updated) => setState(() => _attendance = updated),
                      ),

                      const SizedBox(height: 32),

                      /// TODAY ATTENDANCE CARD
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Absensi Hari Ini',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            _attendanceRow('Clock In', attendance.clockIn),
                            _attendanceRow('Clock Out', attendance.clockOut),
                            _attendanceRow(
                              'Status',
                              attendance.hasClockOut
                                  ? 'Selesai'
                                  : attendance.hasClockIn
                                      ? 'Sedang Bekerja'
                                      : 'Belum Absen',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _attendanceRow(String label, String? value) {
    String displayValue;
    if (label == 'Status') {
      displayValue = value ?? '-';
    } else {
      if (value == null || value.isEmpty) {
        displayValue = '--:--';
      } else {
        // ambil HH:mm saja dari HH:mm:ss
        final parts = value.split(':');
        displayValue = '${parts[0]}:${parts[1]}';
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            displayValue,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// =======================================================
/// USER AVATAR + LOGOUT DROPDOWN
/// =======================================================
class _UserAvatar extends StatefulWidget {
  final UserModel user;
  const _UserAvatar({required this.user});

  @override
  State<_UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<_UserAvatar> {
  OverlayEntry? _overlayEntry;

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      final overlay = Overlay.of(context);
      if (overlay != null) overlay.insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height,
        right: 20,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user.email,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const Divider(),
                InkWell(
                  onTap: () {
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                    AuthService.logout(); // Logout aman tanpa Navigator langsung
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Logout', style: TextStyle(color: Colors.red)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(
          widget.user.name.isNotEmpty
              ? widget.user.name[0].toUpperCase()
              : '?',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      onPressed: _toggleDropdown,
    );
  }
}
