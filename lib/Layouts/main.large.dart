import 'dart:io';

import 'package:distancelearning_mobile/notifiers/main_screen_change_notifier.dart';
import 'package:distancelearning_mobile/widgets/helpers.dart';
import 'package:distancelearning_mobile/widgets/list_items.dart';
import 'package:distancelearning_mobile/widgets/top_bar_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LargeLayout extends StatefulWidget {
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
  _LargeLayoutState createState() => _LargeLayoutState();
}

class _LargeLayoutState extends State<LargeLayout> {
  final ScrollController _controller = ScrollController();
  bool closeTopController = false;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        closeTopController = _controller.offset > 20;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<FileSystemEntity> files = widget.listItems
        .where((element) => element.path.split("_").last == "file")
        .toList();
    final List<FileSystemEntity> directory = widget.listItems
        .whereType<Directory>()
        .where((element) => element.path.split("_").last != "file")
        .toList();
    context.read<MainScreenChangeNotifier>().landscapeHeightTall =
        widget.height > 500;
    final double directoryListHeight =
        context.read<MainScreenChangeNotifier>().landscapeHeightTall
            ? 200
            : 100;

    return Container(
      width: double.infinity,
      height: widget.height,
      child: Column(
        children: [
          ColoredBoxWithFlag(
            width: widget.width,
            height: widget.height / 2,
            textAlign: AnAlignment.center,
          ),
          TopBarWithSearch(
            width: widget.width,
          ),
          if (directory.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(
                vertical:
                    context.read<MainScreenChangeNotifier>().landscapeHeightTall
                        ? 30.0
                        : 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!closeTopController)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 5.0,
                      ),
                      child: (directory.isNotEmpty)
                          ? const Text("Folders")
                          : Container(),
                    )
                  else
                    Container(),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: closeTopController ? 0 : 1,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: widget.width,
                      height: closeTopController ? 0 : directoryListHeight,
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 30.0,
                          top: context
                                  .read<MainScreenChangeNotifier>()
                                  .landscapeHeightTall
                              ? 30.0
                              : 10.0,
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
                    ),
                  )
                ],
              ),
            )
          else
            Container(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: (files.isNotEmpty) ? const Text("Files") : Container(),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: files.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListVideoItem(
                        height: widget.height,
                        file: files[index],
                        dir: Directory(files[index].path),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
