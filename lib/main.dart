import 'package:flutter/material.dart';
import 'features/auth/screens/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

// 1️⃣ Tambahkan global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Indonesian locale
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HRIS Mobile',
      theme: ThemeData(primarySwatch: Colors.blue),

      // Pasang navigatorKey
      navigatorKey: navigatorKey,

      home: const LoginScreen(),
    );
  }
}
