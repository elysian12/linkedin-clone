import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MyNetworkVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const MyNetworkVideoPlayer({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  State<MyNetworkVideoPlayer> createState() => _MyNetworkVideoPlayerState();
}

class _MyNetworkVideoPlayerState extends State<MyNetworkVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      })
      ..play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return InkWell(
        onTap: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

class MyFileVideoPlayer extends StatefulWidget {
  final File videoUrl;
  const MyFileVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<MyFileVideoPlayer> createState() => _MyFileVideoPlayerState();
}

class _MyFileVideoPlayerState extends State<MyFileVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      })
      ..play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return InkWell(
        onTap: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
