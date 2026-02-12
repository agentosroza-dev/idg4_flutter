import 'package:flutter/material.dart';

import '../models/student_model.dart';
import '../services/student_service.dart';

class StudentLogic extends ChangeNotifier {
  List<Datum> _students = [];
  List<Datum> get students => _students;

  final _service = StudentService();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  Future readStudents(BuildContext context) async {
    final studentModel = await _service.readStudents(context);
    _students = studentModel.data;
    _loading = false;
    notifyListeners();
  }
}
