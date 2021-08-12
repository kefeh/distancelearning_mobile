import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoItems extends StatefulWidget {
  final Future<String> fileToBePlayed;
  final bool? looping;
  final bool? autoplay;

  const VideoItems({
    required this.fileToBePlayed,
    this.looping,
    this.autoplay,
    Key? key,
  }) : super(key: key);

  @override
  _VideoItemsState createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItems> {
  ChewieController? _chewieController;

  bool shouldPop = true;
  late File toDelete;
  late String s;
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    s = await widget.fileToBePlayed;
    setState(() {
      videoPlayerController = VideoPlayerController.file(File(s));
      _chewieController = setController(videoPlayerController);

      toDelete = File(s);
      final someFile = toDelete.readAsBytesSync();
      print("ggsgsgsgsgsgsggsgsgsgsgsgsgsgsgsgsgsgsgsgsgsgsgsg");
      print(toDelete);
      print(someFile.length);

      print(toDelete);
    });
  }

  ChewieController setController(VideoPlayerController vidController,
      {Duration? startAt}) {
    return ChewieController(
      videoPlayerController: vidController,
      aspectRatio: vidController.value.aspectRatio,
      autoInitialize: true,
      autoPlay: widget.autoplay ?? true,
      looping: widget.looping ?? false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
      allowedScreenSleep: false,
      startAt: startAt,
    );
  }

  @override
  void dispose() {
    super.dispose();
    print("file deleted");
    toDelete.deleteSync();
    _chewieController != null ? _chewieController!.dispose() : print("s");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (videoPlayerController != null &&
            videoPlayerController.value.isPlaying) {
          videoPlayerController.pause();
        }
        return shouldPop;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: (_chewieController != null)
              ? Stack(
                  children: [
                    Chewie(
                      controller: _chewieController!,
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
