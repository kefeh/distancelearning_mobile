import 'dart:async';

import 'package:distancelearning_mobile/notifiers/file_setup_notifier.dart';
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
  late final int numOfItems;
  late final int numFilesMod;
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
      Provider.of<MainScreenChangeNotifier>(context, listen: false)
          .setFiles(null, context: context);
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
    startWait();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print("This is almost amazing then");
    print(Provider.of<FileSetupNotifier>(context).numFilesMod ==
        Provider.of<FileSetupNotifier>(context).numOfFiles);
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const MainTexts(
                    align: AnAlignment.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Encrypting videos",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      BlinkingText(
                        text:
                            " ${Provider.of<FileSetupNotifier>(context).numFilesMod} of ${Provider.of<FileSetupNotifier>(context).numOfFiles}",
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        MainWidget.routeName,
                      );
                    },
                    child: Container(
                      height: 60,
                      width: 200,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(232, 70, 65, 80),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlinkingText extends StatefulWidget {
  final String text;

  const BlinkingText({
    Key? key,
    required this.text,
  }) : super(key: key);
  @override
  _BlinkingTextState createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> animation;
  late AnimationController controller;

  @override
  initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.ease);

    animation = ColorTween(begin: Colors.white, end: Colors.red).animate(curve);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Text(
          widget.text,
          style: TextStyle(
            color: animation.value,
            fontSize: 27,
          ),
        );
      },
    );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}
