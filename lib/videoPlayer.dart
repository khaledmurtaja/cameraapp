import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:video_player/video_player.dart';

class CustomTrimmer extends StatefulWidget {
  String? path;
  CustomTrimmer({this.path});
  @override
  State<CustomTrimmer> createState() => _CustomTrimmerState(path: path);
}

class _CustomTrimmerState extends State<CustomTrimmer> {

  String? path;
  Trimmer? _trimmer;
  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;
  VideoPlayerController? _videoPlayerController;
  _CustomTrimmerState({this.path});
  @override
  void initState() {
    File f = File(path!);
    super.initState();
    generatingThumbnails();
  }

  Future<void> generatingThumbnails() async {
    _trimmer = Trimmer();
    await _trimmer!.loadVideo(videoFile: File(path.toString()));
    // _trimmer!.videoPlayerController!.initialize().then((value){
    //   // setState((){
    //   //   _trimmer!.videoPlayerController!.seekTo(Duration(seconds: 7));
    //   // });
    //   //_trimmer!.videoPlayerController!.play();
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Video trimmer"),
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
              children: [
            VideoViewer(trimmer: _trimmer!),
            TextButton(
              child: _isPlaying
                  ? Icon(
                      Icons.pause,
                      size: 80.0,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.play_arrow,
                      size: 80.0,
                      color: Colors.white,
                    ),
              onPressed: () async {
                bool playbackState = await _trimmer!.videPlaybackControl(
                  startValue: _startValue,
                  endValue: _endValue,
                );
                setState(() {
                  _isPlaying = playbackState;
                });
              },
            ),
          ]),
          TrimEditor(
             circlePaintColor: Colors.yellow,
            trimmer: _trimmer!,
            viewerHeight: 50.0,
            viewerWidth: MediaQuery.of(context).size.width,
            onChangeStart: (value) {
              print(value);
              _startValue = value;
            },
            onChangeEnd: (value) {
              _endValue = value;
            },
            onChangePlaybackState: (value) {
              setState(() {
                _isPlaying = value;
              });
            },
          )
        ],
      ),
    );
  }
}
