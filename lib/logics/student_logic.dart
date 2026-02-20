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

  String? _nextPageUrl;
  bool _isFetchingMore = false;

  Future readStudents(BuildContext context, {bool refresh = false}) async {

    if (!refresh && _nextPageUrl == null && _students.isNotEmpty) {
      return;
    }

    if (_isFetchingMore) return;

    _isFetchingMore = true;

    final studentModel = await _service.readStudents(
      context,
      refresh ? null : _nextPageUrl,
    );

    if (refresh) {
      _students = studentModel.data;
    } else {
      _students.addAll(studentModel.data);
    }

    debugPrint("_nextPageUrl: $_nextPageUrl");
    
    _nextPageUrl = studentModel.nextPageUrl == "null"
        ? null
        : studentModel.nextPageUrl;

    _loading = false;
    _isFetchingMore = false;

    notifyListeners();
  }
}
