import 'dart:io';

import 'package:distancelearning_mobile/widgets/helpers.dart';
import 'package:distancelearning_mobile/widgets/list_items.dart';
import 'package:distancelearning_mobile/widgets/top_bar_search.dart';
import 'package:flutter/material.dart';

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
