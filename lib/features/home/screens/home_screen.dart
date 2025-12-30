import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../auth/models/user_model.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  String _today() {
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
        .format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Text(
                'Welcome, ${user.name}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _today(),
                style: TextStyle(color: Colors.grey[600]),
              ),

              const SizedBox(height: 24),

              /// QUICK ACTION
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  _MenuCard(
                    icon: Icons.login,
                    label: 'Clock In',
                    color: Colors.green,
                  ),
                  _MenuCard(
                    icon: Icons.logout,
                    label: 'Clock Out',
                    color: Colors.red,
                  ),
                  _MenuCard(
                    icon: Icons.beach_access,
                    label: 'Ajukan Cuti',
                    color: Colors.orange,
                  ),
                  _MenuCard(
                    icon: Icons.history,
                    label: 'Riwayat',
                    color: Colors.blue,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// TODAY ATTENDANCE
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Absensi Hari Ini',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),

                    _AttendanceRow(label: 'Clock In', value: '--:--'),
                    _AttendanceRow(label: 'Clock Out', value: '--:--'),
                    _AttendanceRow(label: 'Status', value: 'Belum Absen'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// CARD MENU
class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MenuCard({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(.15),
              radius: 28,
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

/// ROW ATTENDANCE
class _AttendanceRow extends StatelessWidget {
  final String label;
  final String value;

  const _AttendanceRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
