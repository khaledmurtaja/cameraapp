// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:video_editor/ui/crop/crop_grid.dart';
// import 'package:video_editor/video_editor.dart';
// import 'package:video_player/video_player.dart';
//
// class videoplayer extends StatefulWidget {
//   String? path;
//   videoplayer({this.path});
//
//
//   @override
//   State<videoplayer> createState() => _videoplayerState(path: path);
// }
//
// class _videoplayerState extends State<videoplayer> {
//   String? path;
//   double _startValue = 0.0;
//   double _endValue = 0.0;
//   bool _isPlaying = false;
//   VideoEditorController? _videoEditorController;
//   _videoplayerState({this.path});
//   @override
//   void initState() {
//     File ff=File(path!);
//     _videoEditorController=VideoEditorController.file(ff);
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("fd"),),
//       body: CropGridViewer(controller:_videoEditorController! ),
//     );
//   }
// }
