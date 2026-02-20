import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logics/textsize_logic.dart';
import '../logics/theme_logic.dart';
import '../logics/user_logic.dart';
import 'login_screen.dart';
import 'student_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
      endDrawer: _buildDrawer(),
    );
  }

  Widget _buildDrawer() {
    int themeIndex = context.watch<ThemeLogic>().themeIndex;

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Icon(Icons.face, size: 100)),
          ExpansionTile(
            initiallyExpanded: true,
            title: Text("Change App Theme"),
            children: [
              ListTile(
                leading: Icon(Icons.phone_android),
                title: Text("Change To System"),
                trailing: themeIndex == 0
                    ? Icon(Icons.check_circle)
                    : SizedBox(),
                onTap: () {
                  context.read<ThemeLogic>().changeToSystem();
                },
              ),
              ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text("Change To Dark"),
                trailing: themeIndex == 1
                    ? Icon(Icons.check_circle)
                    : SizedBox(),
                onTap: () {
                  context.read<ThemeLogic>().changeToDark();
                },
              ),
              ListTile(
                leading: Icon(Icons.light_mode),
                title: Text("Change To Light"),
                trailing: themeIndex == 2
                    ? Icon(Icons.check_circle)
                    : SizedBox(),
                onTap: () {
                  context.read<ThemeLogic>().changeToLight();
                },
              ),
            ],
          ),
          ListTile(
            title: Text("Text Font Size"),
            subtitle: _buildFontSizeSlider(),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton.icon(
              onPressed: () {
                context.read<UserLogic>().clearUser();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              label: Text("Logout"),
              icon: Icon(Icons.logout),
            ),
          ),
        ],
      ),
    );
  }

  double _currentScale = 1;

  Widget _buildFontSizeSlider() {
    _currentScale = context.watch<TextsizeLogic>().scaleIndex.toDouble();

    int div = TextsizeLogic.MAX_SCALE - TextsizeLogic.MIN_SCALE;
    return Slider(
      value: _currentScale,
      min: TextsizeLogic.MIN_SCALE.toDouble(),
      max: TextsizeLogic.MAX_SCALE.toDouble(),
      divisions: div,
      label: _currentScale.toInt().toString(),
      onChanged: (value) {
        setState(() {
          _currentScale = value;
        });
        context.read<TextsizeLogic>().changeScaleIndex(value.toInt());
      },
    );
  }

  int _currentIndex = 0;

  Widget _buildBody() {
    return IndexedStack(
      index: _currentIndex,
      children: [StudentScreen(), Container(), Container()],
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == 3) {
          _scaffoldKey.currentState!.openEndDrawer();
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
      ],
    );
  }
}
