import 'dart:io';

import 'package:distancelearning_mobile/notifiers/main_screen_change_notifier.dart';
import 'package:distancelearning_mobile/utils/files.dart';
import 'package:distancelearning_mobile/widgets/helpers.dart';
import 'package:distancelearning_mobile/widgets/list_items.dart';
import 'package:distancelearning_mobile/widgets/top_bar_search.dart';
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

class LargeLayout extends StatelessWidget {
  const LargeLayout({
    Key? key,
    required this.height,
    required this.width,
    required this.listItems,
  }) : super(key: key);

  final double height;
  final double width;
  final List<FileSystemEntity> listItems;

  @override
  Widget build(BuildContext context) {
    final List<FileSystemEntity> files = listItems.whereType<File>().toList();
    final List<FileSystemEntity> directory =
        listItems.whereType<Directory>().toList();
    return SafeArea(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: height,
            child: Stack(
              children: [
                Column(
                  children: [
                    TopBarWithSearch(
                      height: height / 3,
                      width: width,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: (directory.isNotEmpty)
                                ? const Text("Folders")
                                : Container(),
                          ),
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 30.0,
                                top: 30.0,
                              ),
                              child: ListView.builder(
                                itemCount: directory.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListFileItemLarge(
                                    file: directory[index],
                                    dir: Directory(directory[index].path),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: (files.isNotEmpty)
                                ? const Text("Files")
                                : Container(),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: files.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListVideoItem(
                                  height: height,
                                  file: listItems[index],
                                  dir: Directory(listItems[index].path),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SmallLayout extends StatelessWidget {
  const SmallLayout({
    Key? key,
    required this.height,
    required this.width,
    required this.listItems,
  }) : super(key: key);

  final double height;
  final double width;
  final List<FileSystemEntity> listItems;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColoredBoxWithFlag(width: width, height: height),
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
                      height: height / 6,
                      width: width,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: listItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return listItems[index]
                                  .path
                                  .split("/")
                                  .last
                                  .contains(".mp4")
                              ? ListVideoItem(
                                  height: height,
                                  file: listItems[index],
                                  dir: Directory(listItems[index].path),
                                )
                              : ListFIleItem(
                                  height: height,
                                  file: listItems[index],
                                  dir: Directory(listItems[index].path),
                                );
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
    );
  }
}

class ColoredBoxWithFlag extends StatelessWidget {
  const ColoredBoxWithFlag({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff468908),
      width: width,
      height: height / 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MainTexts(
            align: AnAlignment.left,
          ),
          Flag(width: width, height: height)
        ],
      ),
    );
  }
}
