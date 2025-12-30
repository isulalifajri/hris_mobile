import 'package:flutter/material.dart';

class LeaveFormScreen extends StatefulWidget {
  const LeaveFormScreen({super.key});

  @override
  State<LeaveFormScreen> createState() => _LeaveFormScreenState();
}

class _LeaveFormScreenState extends State<LeaveFormScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController reasonController = TextEditingController();

  Future<void> pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              "Pengajuan Cuti",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            /// TANGGAL MULAI
            ListTile(
              title: Text(
                startDate == null
                    ? "Tanggal Mulai"
                    : startDate.toString().split(" ").first,
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => pickDate(true),
            ),

            /// TANGGAL SELESAI
            ListTile(
              title: Text(
                endDate == null
                    ? "Tanggal Selesai"
                    : endDate.toString().split(" ").first,
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => pickDate(false),
            ),

            const SizedBox(height: 16),

            /// ALASAN
            TextFormField(
              controller: reasonController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Alasan Cuti",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Alasan wajib diisi";
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: API submit cuti
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Pengajuan dikirim")),
                  );
                }
              },
              child: const Text("Kirim Pengajuan"),
            )
          ],
        ),
      ),
    );
  }
}
