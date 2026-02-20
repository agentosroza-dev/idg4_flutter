import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logics/student_logic.dart';
import '../logics/textsize_logic.dart';
import '../logics/theme_logic.dart';
import '../logics/user_logic.dart';
import '../screens/splash_screen.dart';

Widget appProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeLogic()),
      ChangeNotifierProvider(create: (context) => TextsizeLogic()),
      ChangeNotifierProvider(create: (context) => UserLogic()),
      ChangeNotifierProvider(create: (context) => StudentLogic()),
    ],
    child: SplashScreen(),
  );
}
