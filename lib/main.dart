import 'package:flutter/material.dart';
import 'main_wrapper.dart';
import 'pages/email.dart';
import 'services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(AcadexaApp());
}

class AcadexaApp extends StatefulWidget {
  const AcadexaApp({super.key});

  static _AcadexaAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AcadexaAppState>();

  @override
  _AcadexaAppState createState() => _AcadexaAppState();
}

class _AcadexaAppState extends State<AcadexaApp> {
  ThemeMode _themeMode = ThemeMode.light;



  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acadexa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      initialRoute: '/email', // Change initial route to email.dart
      routes: {
        '/home': (context) => MainWrapper(),
        '/email': (context) => EmailLoginPage(), // Add email route
      },
    );
  }
}
