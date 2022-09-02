import 'dart:async';
import 'dart:typed_data';

import 'package:cameraapp/models/videoModel.dart';
import 'package:hive/hive.dart';

import '../models/EditedVideoModel.dart';
import '../models/FlagModel.dart';

bool permissionsGranted=false;
final int VideoMode=1;
final int PicMode=0;
final int oneMinMode=0;
final int threeMinMode=1;
final int fiveMinMod=2;
Timer? durationTimer;
Timer? processingTimer;// this the timer that will stop user events before starting the (system stop)
int customProcessingTimer=0;
int fileDurationInSec = 60; //default value which could be change according to events by user
bool isFlagged=false;
int flagPoint=0;
List<FlagModel> Flags=[];
Box<VideoModel>? FlaggedVideoBox;
Box<EditedVideoModel>? EditedVideosBox;
Uint8List? uint8list;