import 'package:flutter/material.dart';
import 'package:june/june.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return JuneBuilder(
      () => MyController(),
      builder: (c) => MaterialApp(
        theme: ThemeData(),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: c.isDark ? ThemeMode.dark : ThemeMode.light,
        home: const HomeUi(),
      ),
    );
  }
}

class HomeUi extends StatelessWidget {
  const HomeUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: JuneBuilder(
          () => MyController(),
          builder: (c) => Switch(
            value: c.isDark,
            onChanged: (_) => c.changeThemeMode(),
          ),
        ),
      ),
    );
  }
}

class MyController extends JuneState {
  bool isDark = false;

  void changeThemeMode() {
    isDark = !isDark;
    setState();
  }
}
