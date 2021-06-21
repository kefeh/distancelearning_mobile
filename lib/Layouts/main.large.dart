import 'dart:io';

import 'package:distancelearning_mobile/widgets/list_items.dart';
import 'package:distancelearning_mobile/widgets/top_bar_search.dart';
import 'package:flutter/material.dart';

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
