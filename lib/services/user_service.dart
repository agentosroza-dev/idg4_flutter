import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/success_user.dart';
import 'base_url.dart';

class UserService {
  final base = BaseURL.base;

  Future<SuccessUser> login(String email, String password) async {
    final url = "$base/api/signin";
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
        },
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return compute(successUserFromJson, response.body);
      } else {
        throw Exception("Error status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Network Error: ${e.toString()}");
    }
  }
}
