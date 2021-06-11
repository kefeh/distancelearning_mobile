import 'dart:io';

import 'package:distancelearning_mobile/notifiers/main_screen_change_notifier.dart';
import 'package:distancelearning_mobile/utils/files.dart';
import 'package:distancelearning_mobile/views/video_player.dart';
import 'package:distancelearning_mobile/widgets/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

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

class ListVideoItem extends StatefulWidget {
  const ListVideoItem(
      {Key? key, required this.height, required this.name, required this.dir})
      : super(key: key);

  final double height;
  final String name;
  final Directory dir;

  @override
  _ListVideoItemState createState() => _ListVideoItemState();
}

class _ListVideoItemState extends State<ListVideoItem> {
  late VideoPlayerController _videoController;
  late File videoFile;
  File? thumbnailFile;

  @override
  void initState() {
    super.initState();
    videoFile = File(widget.dir.path);
    getThumbnail(widget.dir.path).then((value) => {
          setState(() {
            thumbnailFile = File(value);
          })
        });
    _videoController = VideoPlayerController.file(videoFile);
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
        horizontal: 16.0,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VideoItems(videoPlayerController: _videoController),
            ),
          );
        },
        child: BoxWithShadow(
          width: double.infinity,
          height: widget.height / 10,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 100.0,
                        height: 56.0,
                        child: thumbnailFile != null
                            ? Image.file(thumbnailFile!)
                            : const Icon(Icons.video_collection_outlined),
                      ),
                      Text(
                        widget.name,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.play_arrow_rounded,
                  size: 25,
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
