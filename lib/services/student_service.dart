import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:my_students/services/base_url.dart';
import 'package:provider/provider.dart';

import '../logics/user_logic.dart';
import '../models/student_model.dart';
import '../models/success_user.dart';
import '../screens/login_screen.dart';

class StudentService {
  // Improved logger instance with better naming
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log level/ Should each log print contain a timestamp
    ),
  );
  
  final base = BaseUrl().base;
  
  Future<StudentModel> readStudents(BuildContext context) async {
    // Use logger instead of debugPrint for consistency
    logger.i("Base URL: $base");
    
    SuccessUser user = context.read<UserLogic>().successUser;
    logger.d("readStudents, user.token = ${user.token}");

    final url = "$base/api/students";
    try {
      logger.i("Fetching students from: $url");
      
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
          "Authorization": "Bearer ${user.token}",
        },
      );
      
      logger.d("Response status: ${response.statusCode}");
      
      if (response.statusCode == 200) {
        logger.i("Successfully fetched students data");
        // Fixed: Added await for compute
        return await compute(studentModelFromJson, response.body);
      } else if (response.statusCode == 401) {
        logger.w("Unauthorized access (401). Clearing user data.");
        await context.read<UserLogic>().clearUser();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginScreen())
        );
        throw Exception("Unauthorized access: ${response.statusCode}");
      } else {
        logger.e("Error status code: ${response.statusCode}");
        logger.e("Response body: ${response.body}");
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      logger.e("Network Error: ${e.toString()}");
      logger.e("Stack trace: $stackTrace");
      throw Exception("Network Error: ${e.toString()}");
    }
  }
}