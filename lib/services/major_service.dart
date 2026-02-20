import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../logics/user_logic.dart';
import '../models/major_model.dart';
import '../models/success_user.dart';
import '../screens/login_screen.dart';
import 'base_url.dart';

class MajorService {
  final base = BaseURL.base;

  Future<List<MajorModel>> readMajors(BuildContext context) async {
    SuccessUser user = context.read<UserLogic>().successUser;
    final url = "$base/api/majors_api";
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
          "Authorization": "Bearer ${user.token}",
        },
      );
      if (response.statusCode == 200) {
        return compute(majorModelFromJson, response.body);
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

  
}
