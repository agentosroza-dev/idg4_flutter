import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/success_user.dart';

class UserLogic extends ChangeNotifier {
  SuccessUser _successUser = _defaultUser;
  SuccessUser get successUser => _successUser;

  final _key = "UserLogic";
  final _storage = FlutterSecureStorage();

  Future readUser() async {
    String? userString = await _storage.read(key: _key);
    if (userString == null) {
      _successUser = _defaultUser;
    } else {
      _successUser = successUserFromJson(userString);
    }
    notifyListeners();
  }

  Future saveUser(SuccessUser user) async {
    _successUser = user;
    await _storage.write(key: _key, value:successUserToJson(user));
    notifyListeners();
  }

  Future clearUser() async {
    _successUser = _defaultUser;
    _storage.delete(key: _key);
    notifyListeners();
  }
}

final _defaultUser = SuccessUser(
  user: User(
    id: "id",
    name: "name",
    email: "email",
    emailVerifiedAt: "emailVerifiedAt",
    createdAt: "createdAt",
    updatedAt: "updatedAt",
  ),
  token: "token",
);
