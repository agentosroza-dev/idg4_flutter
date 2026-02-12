import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeLogic extends ChangeNotifier{

  final _key = "ThemeLogic";
  final _storage = FlutterSecureStorage();

  int _themeIndex = 0;
  int get themeIndex => _themeIndex;

  Future readTheme() async{
    String index = await _storage.read(key: _key) ?? "0";
    _themeIndex = int.parse(index);
    notifyListeners();
  }

  void changeToSystem(){
    _themeIndex = 0;
    _storage.write(key: _key, value:  _themeIndex.toString());
    notifyListeners();
  }

  void changeToDark(){
    _themeIndex = 1;
    _storage.write(key: _key, value:  _themeIndex.toString());
    notifyListeners();
  }

  void changeToLight(){
    _themeIndex = 2;
    _storage.write(key: _key, value:  _themeIndex.toString());
    notifyListeners();
  }
}