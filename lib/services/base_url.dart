import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

class BaseUrl {
  static String get base {
    if (kIsWeb) {
      return "http://localhost:8000";
    } else if (Platform.isAndroid) {
      return "http://10.0.2.2:8000"; // Android emulator
      // For physical device with Laravel on local network:
      // return "http://192.168.1.x:8000"; // Your computer's IP
    } else if (Platform.isIOS) {
      return "http://localhost:8000"; // iOS simulator
    } else {
      return "http://localhost:8000"; // Desktop
    }
  }
}
