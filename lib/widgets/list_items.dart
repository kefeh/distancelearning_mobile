import 'dart:io';

import 'package:distancelearning_mobile/notifiers/main_screen_change_notifier.dart';
import 'package:distancelearning_mobile/widgets/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListFIleItem extends StatelessWidget {
  const ListFIleItem(
      {Key? key, required this.height, required this.name, required this.dir})
      : super(key: key);

  final double height;
  final String name;
  final Directory dir;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 16.0,
      ),
      child: GestureDetector(
        onTap: () {
          context.read<MainScreenChangeNotifier>().setFiles(dir.path);
        },
        child: BoxWithShadow(
          width: double.infinity,
          height: height / 10,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.folder_rounded,
                        size: 45,
                        color: Color.fromRGBO(107, 123, 250, 0.7),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Text(
                        name,
                      ),
                    ],
                  ),
                ),
                const Text(
                  "10 items",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
