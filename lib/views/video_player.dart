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
  late ChewieController _chewieController;

  bool shouldPop = true;
  late File toDelete;
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print("file deleted");
    toDelete.deleteSync();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (videoPlayerController.value.isPlaying) {
          videoPlayerController.pause();
        }
        return shouldPop;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<String>(
            future: widget.fileToBePlayed,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                videoPlayerController =
                    VideoPlayerController.file(File(snapshot.data!));
                _chewieController = ChewieController(
                  videoPlayerController: videoPlayerController,
                  aspectRatio: videoPlayerController.value.aspectRatio,
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
                );

                toDelete = File(snapshot.data!);

                return Stack(
                  children: [
                    Chewie(
                      controller: _chewieController,
                    ),
                  ],
                );
              }
              return Align(
                  alignment: Alignment.center,
                  child: Container(
                    color: Colors.black,
                    child: const CircularProgressIndicator(),
                  ));
            },
          ),
        ),
      ),
    );
  }
}
