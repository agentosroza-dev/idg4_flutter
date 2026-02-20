import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../logics/user_logic.dart';
import '../models/student_model.dart';
import '../models/success_user.dart';
import '../screens/login_screen.dart';
import 'base_url.dart';

class StudentService {
  final base = BaseURL.base;

  Future<StudentModel> readStudents(BuildContext context, String? url) async {
    SuccessUser user = context.read<UserLogic>().successUser;

    final finalUrl = url ?? "$base/api/students";

    http.Response response = await http.get(
      Uri.parse(finalUrl),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Authorization": "Bearer ${user.token}",
      },
    );

    if (response.statusCode == 200) {
      return compute(studentModelFromJson, response.body);
    } else {
      throw Exception("Error ${response.statusCode}");
    }
  }

  Future<bool> deleteStudents(BuildContext context, String id) async {
    SuccessUser user = context.read<UserLogic>().successUser;
    final url = "$base/api/students/$id";
    try {
      http.Response response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
          "Authorization": "Bearer ${user.token}",
        },
      );
      if (response.statusCode == 200) {
        debugPrint("deleted student: ${response.body}");
        return true;
      } else if (response.statusCode == 401) {
        await context.read<UserLogic>().clearUser();
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => LoginScreen()));
        throw Exception("Error status code: ${response.statusCode}");
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network Error: ${e.toString()}");
    }
  }

  Future<bool> insertStudents(
    BuildContext context,
    String name,
    String majorId,
    File? imageFile,
  ) async {
    SuccessUser user = context.read<UserLogic>().successUser;
    final url = "$base/api/students";

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // ADD TOKEN HERE
    request.headers['Authorization'] = 'Bearer ${user.token}';
    request.headers['Accept'] = 'application/json';

    request.fields['name'] = name;
    request.fields['major_id'] = majorId;

    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: basename(imageFile.path),
      );

      request.files.add(multipartFile);
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      debugPrint("Inserted student: ${response.body}");
      return true;
    } else if (response.statusCode == 401) {
      await context.read<UserLogic>().clearUser();
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => LoginScreen()));
      return false;
    } else {
      throw Exception("Error: ${response.statusCode} ${response.body}");
    }
  }

  Future<bool> updateStudent(
    BuildContext context,
    String id, 
    String name,
    String majorId,
    File? imageFile,
  ) async {
    SuccessUser user = context.read<UserLogic>().successUser;

    final url = "$base/api/students/${id}";

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // ✅ Sanctum Token
    request.headers['Authorization'] = 'Bearer ${user.token}';
    request.headers['Accept'] = 'application/json';

    // ✅ Tell Laravel this is PUT
    request.fields['_method'] = 'PUT';

    // ✅ Required fields
    request.fields['name'] = name;
    request.fields['major_id'] = majorId;

    // ✅ Optional image
    if (imageFile != null) {
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: basename(imageFile.path),
      );

      request.files.add(multipartFile);
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      debugPrint("Updated student: ${response.body}");
      return true;
    } else if (response.statusCode == 401) {
      await context.read<UserLogic>().clearUser();
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => LoginScreen()));
      return false;
    } else {
      throw Exception("Error: ${response.statusCode} ${response.body}");
    }
  }
}
