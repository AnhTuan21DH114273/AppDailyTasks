import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class UiProvider extends ChangeNotifier{

  bool _isDark = false;
  bool get isDark => _isDark;

  late SharedPreferences storage;

  //Custom dark theme
  final darkTheme = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.dark,
    primaryColorDark: Colors.white,
  );

  //Custom light theme
  final lightTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.light,
    primaryColorDark: Colors.black
  );

  changeTheme(){
    _isDark = !isDark;

    storage.setBool("isDark", _isDark);
    notifyListeners();
  }

  init()async{

     storage = await SharedPreferences.getInstance();
    _isDark = storage.getBool("isDark")??false;
    notifyListeners();
  }
 }