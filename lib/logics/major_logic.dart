import 'package:flutter/material.dart';

import '../models/major_model.dart';
import '../services/major_service.dart';

class MajorLogic extends ChangeNotifier {
  List<MajorModel> _majors = [];
  List<MajorModel> get majors => _majors;

  final _service = MajorService();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  Future readMajors(BuildContext context) async {
    final data = await _service.readMajors(context);
    _majors = data;
    _loading = false;
    notifyListeners();
  }
}
