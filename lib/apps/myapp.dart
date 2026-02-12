import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logics/textsize_logic.dart';
import '../logics/theme_logic.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  Widget home;

  MyApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    int themeIndex = context.watch<ThemeLogic>().themeIndex;
    int scaleIndex = context.watch<TextsizeLogic>().scaleIndex;

    return MaterialApp(
      // initialRoute: "/login",
      home: home,
      themeMode: themeIndex == 1
          ? ThemeMode.dark
          : themeIndex == 2
          ? ThemeMode.light
          : ThemeMode.system,
      theme: lightTheme(scaleIndex),
      darkTheme: darkTheme(scaleIndex),
      // onGenerateRoute: (settings) {
      //   switch (settings.name) {
      //     case "/":
      //       return MaterialPageRoute(builder: (context) => MainScreen());
      //     case "/login":
      //       return MaterialPageRoute(builder: (context) => LoginScreen());
      //     default:
      //       return MaterialPageRoute(
      //         builder: (context) => Scaffold(
      //           appBar: AppBar(title: Text("Page Not Found")),
      //           body: Center(child: Text("Route might be wrong")),
      //         ),
      //         fullscreenDialog: true,
      //         settings: settings,
      //       );
      //   }
      // },
    );
  }
}
