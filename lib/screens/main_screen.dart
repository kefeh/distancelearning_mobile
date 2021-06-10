import 'dart:io';

import 'package:distancelearning_mobile/notifiers/main_screen_change_notifier.dart';
import 'package:distancelearning_mobile/widgets/helpers.dart';
import 'package:distancelearning_mobile/widgets/list_items.dart';
import 'package:distancelearning_mobile/widgets/top_bar_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainWidget extends StatelessWidget {
  static const routeName = 'home';

  String? directory;
  bool shouldPop = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final List<ListFIleItem> listItems = context
        .watch<MainScreenChangeNotifier>()
        .files
        .map(
          (element) => ListFIleItem(
            height: height,
            name: element.path.split("/").last,
            dir: Directory(element.path),
          ),
        )
        .toList();
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(244, 249, 240, 1),
        resizeToAvoidBottomInset: false,
        body: PageView(
          children: [
            Stack(
              children: [
                Container(
                  color: const Color(0xff468908),
                  width: double.infinity,
                  height: height / 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MainTexts(),
                      Flag(width: width, height: height)
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: ((2 * height) / 3) + 15,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            TopBarWithSearch(
                              height: height,
                              width: width,
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: listItems.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return listItems[index];
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
