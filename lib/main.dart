import 'package:flutter/material.dart';
import 'package:mydairy/screens/splashscreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyDairy',
      home: SplashScreen(),
        );
  }
}
