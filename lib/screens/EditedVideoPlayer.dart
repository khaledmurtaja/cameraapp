import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class EditedVideoPlayer extends StatefulWidget {
  String? path;
  EditedVideoPlayer(this.path);

  @override
  _EditedVideoPlayerState createState() => _EditedVideoPlayerState(path);
}

class _EditedVideoPlayerState extends State<EditedVideoPlayer> {
  String? path;
  _EditedVideoPlayerState(this.path);
  late VideoPlayerController _controller;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
      File("$path")
        )
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
         chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: true,
          looping: true,
        );
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Chewie( controller: chewieController! ,),
          )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      );

  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}