import 'dart:io';
import 'package:cameraapp/models/EditedVideoModel.dart';
import 'package:cameraapp/shared/HelperFunctions.dart';
import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:video_trimmer/src/videoFlag.dart';
import 'package:cameraapp/shared/globalVars.dart';

class CustomTrimmer extends StatefulWidget {
  final String? path;
  final List<VideoFlag>? videoFlagList;
  final int? duration;
  final int tagKey;
  CustomTrimmer(
      {required this.path,
      required this.videoFlagList,
      required this.duration,
      required this.tagKey});
  @override
  State<CustomTrimmer> createState() => _CustomTrimmerState(
      path: path,
      videoFlagList: videoFlagList,
      duration: duration,
      key: tagKey);
}

class _CustomTrimmerState extends State<CustomTrimmer> {
  String? path;
  int? duration;
  Trimmer _trimmer = Trimmer();
  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;
  int? key;
  List<VideoFlag>? videoFlagList;
  double _tempEnd=0;
  _CustomTrimmerState({this.path, this.videoFlagList, this.duration, this.key});
  @override
  void initState() {
    generatingThumbnails();
    super.initState();
  }

  Future<void> generatingThumbnails() async {
    await _trimmer.loadVideo(videoFile: File(path.toString()));
    if (videoFlagList != null) {
      VideoFlag flagModel =
          validateFlagPoint(videoFlagList!.elementAt(key!), duration);
      _startValue = flagModel.BeforeFlag!.toDouble() * 1000;
      _tempEnd= flagModel.afterFlag!.toDouble() * 1000;
    }
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
        backgroundColor: Colors.black,
        title: Text("Editing"),
        actions: [
       TextButton(
           onPressed:(){
             _trimmer.saveTrimmedVideo(
                 startValue: _startValue,
                 endValue: _endValue==0?_tempEnd:_endValue,
                 onSave:(value){
                   EditedVideosBox!.add(EditedVideoModel(value.toString()));
                 }
             );
           },
           child: Text(
               "Save",
             style: TextStyle(
               color: Colors.white,
               fontWeight: FontWeight.bold
             ),
           )
       )
        ],
      ),
      body: Column(

        children: [
          Stack(alignment: Alignment.center, children: [
            Container(
              height: 500,
              width: double.infinity,
              child: AspectRatio(
                  aspectRatio: 4 / 3, child: VideoViewer(trimmer: _trimmer)),
            ),
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
                bool playbackState = await _trimmer.videPlaybackControl(
                  startValue: _startValue,
                  endValue: _endValue,
                );
                setState(() {
                  _isPlaying = playbackState;
                });
              },
            ),
          ]),
          Container(
            decoration: BoxDecoration(
              color: Colors.black26

            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20,bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                    },
                    child: Icon(
                        Icons.music_off_outlined,
                      color: Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      print(_startValue);
                      print(_endValue);

                    },
                    child: Icon(
                      Icons.content_cut_sharp,
                      color: Colors.yellow,
                    ),
                  ),
                  Icon(
                    Icons.access_time_rounded,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.access_time_rounded,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          TrimEditor(
            durationTextStyle: TextStyle(color: Colors.white),
            tagKey: key,
            fit: BoxFit.cover,
            duration: duration,
            videoFlagList: videoFlagList,
            scrubberPaintColor: Colors.cyan,
            trimmer: _trimmer,
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
