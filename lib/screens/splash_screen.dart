import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../apps/myapp.dart';
import '../logics/major_logic.dart';
import '../logics/student_logic.dart';
import '../logics/textsize_logic.dart';
import '../logics/theme_logic.dart';
import '../logics/user_logic.dart';
import '../models/success_user.dart';
import '../widgets/my_error.dart';
import '../widgets/my_logo.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future? _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _loadData();
  }

  Future _loadData() async {
    await Future.delayed(const Duration(seconds: 2));

    await context.read<ThemeLogic>().readTheme();
    await context.read<TextsizeLogic>().readFontSize();
    await context.read<UserLogic>().readUser();

    final user = context.read<UserLogic>().successUser;

    if (user.token != 'token') {
      await context.read<StudentLogic>().readStudents(context);
      await context.read<MajorLogic>().readMajors(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _futureData == null
          ? MyLogo(context)
          : FutureBuilder(
              future: _futureData,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return MyError(
                    context,
                    error: snapshot.error.toString(),
                    onPressed: () {
                      setState(() {
                        _futureData = _loadData();
                      });
                    },
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  final SuccessUser user = context
                      .watch<UserLogic>()
                      .successUser;
                  debugPrint("user.token: ${user.token}");
                  if (user.token != 'token') {
                    return MyApp(home: MainScreen());
                  } else {
                    return MyApp(home: LoginScreen());
                  }
                } else {
                  return MyLogo(context);
                }
              },
            ),
    );
  }
}
