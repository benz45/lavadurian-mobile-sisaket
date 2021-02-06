import 'package:LavaDurian/App/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:LavaDurian/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lava Durian Sisaket',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      // home: WelcomeScreen(),
      home: SplashPage(),
    );
  }
}
