import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class BaseUrl {
      String get base {
    if (kIsWeb) {
      // For web platform (Chrome, Firefox, etc.)
      // Use localhost or your actual backend URL for production
      return "http://localhost:8000";
    } else if (Platform.isAndroid) {
      // Android emulator/device
      return "http://10.0.2.2:8000";
    } else if (Platform.isIOS) {
      // iOS simulator/device
      return "http://localhost:8000";
    } else if (Platform.isMacOS) {
      // macOS desktop
      return "http://localhost:8000";
    } else if (Platform.isWindows) {
      // Windows desktop
      return "http://localhost:8000";
    } else if (Platform.isLinux) {
      // Linux desktop
      return "http://localhost:8000";
    } else if (Platform.isFuchsia) {
      // Fuchsia OS
      return "http://localhost:8000";
    }
    // Default fallback
    return "http://localhost:8000";
  }
}