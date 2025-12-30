import 'dart:io';

class ApiConfig {
  static const String _devPort = '8787';

  static String get baseUrl {
    // Android Emulator
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:$_devPort/api';
    }

    // Web / Windows / lainnya
    return 'http://127.0.0.1:$_devPort/api';
  }

  // timeout (optional)
  static const Duration timeout = Duration(seconds: 20);
}
