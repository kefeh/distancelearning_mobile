import 'dart:async';

import 'package:distancelearning_mobile/screens/main_screen.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  static const String routeName = 'splash';
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer startWait() {
    return Timer(const Duration(seconds: 2), handleEndWait);
  }

  void handleEndWait() {
    Navigator.pushReplacementNamed(context, MainWidget.routeName);
  }

  @override
  void initState() {
    super.initState();
    startWait();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Welcome to Minesec Distance Learning"),
      ),
    );
  }
}
