import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/home.dart';

void main() {
  runApp(AcadexaApp());
}

class AcadexaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acadexa',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => AcadexaLoginPage(),
        '/home': (context) => MyApp(),
      },
    );
  }
}
