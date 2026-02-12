import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:my_students/services/base_url.dart';
import '../models/success_user.dart';

class UserService {
  // Use late initialization or make it static
    final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log level/ Should each log print contain a timestamp
    ),
  );
  
  // Alternative: Use static instance
  // static final Logger _logger = Logger();
  
  final String base = BaseUrl().base;

  Future<SuccessUser> login(String email, String password) async {
    logger.d("Base URL: $base");
    final url = "$base/api/login";
    
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
        },
        body: jsonEncode({"email": email, "password": password}),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return compute(_parseSuccessUser, response.body);
      } else {
        logger.e("Login failed with status: ${response.statusCode}");
        logger.e("Response body: ${response.body}");
        throw Exception("Login failed: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("Login error: $e");
      throw Exception("Network Error: ${e.toString()}");
    }
  }
  
  // Helper method for compute
  static SuccessUser _parseSuccessUser(String jsonString) {
    return successUserFromJson(jsonString);
  }
}