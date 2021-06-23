import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:distancelearning_mobile/notifiers/main_screen_change_notifier.dart';
import 'package:distancelearning_mobile/screens/main_screen.dart';
import 'package:distancelearning_mobile/screens/splash.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef DirectoryCallback = void Function(String);
void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainScreenChangeNotifier(),
      child: MaterialApp(
        locale: DevicePreview.locale(context), // Add the locale here
        builder: DevicePreview.appBuilder,
        title: 'Distance Learning',
        initialRoute: Splash.routeName,
        routes: {
          Splash.routeName: (context) => const Splash(),
          MainWidget.routeName: (context) => MainWidget(),
        },
      ),
    );
  }
}
