import 'package:flutter/material.dart';
import 'screens/register_screen.dart';
import 'screens/players_screen.dart';
import 'screens/play_screen.dart';
import 'screens/points_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Par ou Ímpar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegisterScreen(),
    );
  }
}
