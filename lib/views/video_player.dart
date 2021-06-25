import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoItems extends StatefulWidget {
  //TODO: Consider using a black scaffold for the video player
  final VideoPlayerController videoPlayerController;
  final bool? looping;
  final bool? autoplay;

  const VideoItems({
    required this.videoPlayerController,
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

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: widget.videoPlayerController.value.aspectRatio,
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
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.videoPlayerController.value.isPlaying) {
          widget.videoPlayerController.pause();
        }
        return shouldPop;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Chewie(
                controller: _chewieController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
