import 'package:flutter/material.dart';
import 'package:notchai_frontend/screens/bottom_navigation.dart';
import 'package:notchai_frontend/screens/signin.dart';
import 'package:notchai_frontend/utils/app_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NotchAI',
      theme: ThemeData(
        primaryColor: primary,
      ),
      home: const BottomNavBar(),
    );
  }
}
