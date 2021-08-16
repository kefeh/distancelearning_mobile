import 'dart:io';

import 'package:distancelearning_mobile/utils/file_encryption_decryption.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'package:distancelearning_mobile/notifiers/main_screen_change_notifier.dart';
import 'package:distancelearning_mobile/utils/files.dart';
import 'package:distancelearning_mobile/views/video_player.dart';
import 'package:distancelearning_mobile/widgets/helpers.dart';

class ListFIleItem extends StatelessWidget {
  const ListFIleItem(
      {Key? key, required this.height, required this.dir, required this.file})
      : super(key: key);

  final double height;
  final Directory dir;
  final FileSystemEntity file;

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
                      NameWithDate(file: file),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListFileItemLarge extends StatelessWidget {
  const ListFileItemLarge({
    Key? key,
    required this.dir,
    required this.file,
  }) : super(key: key);

  final Directory dir;
  final FileSystemEntity file;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0),
      child: GestureDetector(
        onTap: () {
          context.read<MainScreenChangeNotifier>().setFiles(dir.path);
        },
        child: FittedBox(
          fit: BoxFit.fill,
          // alignment: Alignment.topCenter,
          child: Container(
            // height: heightTall ? 100 : 50,
            width: context.read<MainScreenChangeNotifier>().landscapeHeightTall
                ? 200
                : 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: const Color.fromRGBO(70, 137, 8, 0.08),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_rounded,
                    size: context
                            .read<MainScreenChangeNotifier>()
                            .landscapeHeightTall
                        ? 80
                        : 40,
                    color: const Color.fromRGBO(107, 123, 250, 0.7),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: context
                              .read<MainScreenChangeNotifier>()
                              .landscapeHeightTall
                          ? 150
                          : 75,
                      child: Text(
                        file.path.split("/").last,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListVideoItem extends StatefulWidget {
  const ListVideoItem(
      {Key? key, required this.height, required this.file, required this.dir})
      : super(key: key);

  final double height;
  final FileSystemEntity file;
  final Directory dir;

  @override
  _ListVideoItemState createState() => _ListVideoItemState();
}

Worker worker = Worker();

class _ListVideoItemState extends State<ListVideoItem> {
  VideoPlayerController? _videoController;
  late File videoFile;
  File? thumbnailFile;

  @override
  void initState() {
    super.initState();
    videoFile = File(widget.dir.path);

    setThumbnailFile(widget.dir.path);
  }

  Future<void> setThumbnailFile(String filePath) async {
    await worker.isReady;
    final String? thumbnail = await getAThumbnail(filePath);
    setState(() {
      // firstFile = Directory(widget.dir.path)
      //     .listSync()
      //     .where((element) =>
      //         basename((element as File).path, removeExtension: false) ==
      //         "x.mp4")
      //     .toList()[0] as File;
      thumbnailFile =
          (thumbnail != null ? File(thumbnail) : thumbnail) as File?;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_videoController != null) {
      _videoController!.dispose();
    }
    worker.dispose();
  }

  Future<String> runIsolate() async {
    // final String s = await compute(EncryptDecrypt.decryptFile, videoFile.path);
    // final String s = await EncryptDecrypt.decryptFile(videoFile.path);
    final String s = await worker.decrypt({
      'filePath': videoFile.path,
      'type': 'decrypt',
    });
    return s;
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
              builder: (context) => VideoItems(
                fileToBePlayed: runIsolate(),
                // firstFile: firstFile,
              ),
            ),
          );
        },
        child: BoxWithShadow(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(107, 123, 250, 0.7),
                            borderRadius: BorderRadius.circular(20)),
                        child: thumbnailFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  thumbnailFile!,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : const Icon(Icons.video_collection_outlined),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      NameWithDate(file: widget.file),
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

class NameWithDate extends StatelessWidget {
  final FileSystemEntity file;
  const NameWithDate({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String name = basename(file.path);
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            DateFormat.yMMMMd('en_US')
                .add_jm()
                .format(file.statSync().modified),
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
