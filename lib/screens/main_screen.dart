import 'dart:io';

import 'package:distancelearning_mobile/Layouts/main.large.dart';
import 'package:distancelearning_mobile/Layouts/main.small.dart';
import 'package:distancelearning_mobile/notifiers/main_screen_change_notifier.dart';
import 'package:distancelearning_mobile/utils/files.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainWidget extends StatelessWidget {
  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final Map<String, dynamic> parent =
        context.watch<MainScreenChangeNotifier>().parent;
    final List<FileSystemEntity> listItems =
        context.watch<MainScreenChangeNotifier>().files.toList();

    return WillPopScope(
      onWillPop: () async {
        final String dirPath = await getMainDirPath();
        final String parentDir =
            await getParentDirPath(parent['dir'].path.toString());
        if (parent['dir'].path == dirPath) {
          return Future.value(true);
        } else {
          context.read<MainScreenChangeNotifier>().setFiles(parentDir);
          return Future.value(false);
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(244, 249, 240, 1),
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return PageView(
              children: [
                if (constraints.maxWidth < 600)
                  SmallLayout(
                      height: height, width: width, listItems: listItems)
                else
                  LargeLayout(
                      height: height, width: width, listItems: listItems)
              ],
            );
          },
        ),
      ),
    );
  }
}
