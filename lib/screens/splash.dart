import 'dart:async';

import 'package:distancelearning_mobile/notifiers/main_screen_change_notifier.dart';
import 'package:distancelearning_mobile/screens/main_screen.dart';
import 'package:distancelearning_mobile/views/dialogs.dart';
import 'package:distancelearning_mobile/widgets/helpers.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  static const String routeName = 'splash';
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer startWait() {
    return Timer(
      const Duration(seconds: 2),
      handleEndWait,
    );
  }

  void handleEndWait() {
    makeInitialFileRequest();
  }

  Future<void> makeInitialFileRequest() async {
    final PermissionStatus filePermission = await Permission.storage.status;
    if (filePermission.isGranted) {
      Provider.of<MainScreenChangeNotifier>(context, listen: false).setFiles();
      Navigator.pushReplacementNamed(
        context,
        MainWidget.routeName,
      );
    } else {
      final PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        await makeInitialFileRequest();
      } else {
        showToast("Please grant permission");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    startWait();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xff468908),
      body: Stack(
        children: [
          Align(
            child: Flag(
              width: width,
              height: height * 3,
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.7),
            child: Container(
              height: (height / 3) - 40,
              width: double.infinity,
              color: const Color(0xff468908),
              child: const MainTexts(
                align: AnAlignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
