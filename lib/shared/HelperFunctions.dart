import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:cameraapp/models/FlagModel.dart';
import 'package:cameraapp/shared/globalVars.dart';
import 'package:cameraapp/models/videoModel.dart';
import 'package:cameraapp/shared/videoInfo.dart';
import 'package:external_path/external_path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/videoModel.dart';
import 'package:video_trimmer/src/videoFlag.dart';

Future<String> getFilePath() async {
  // this function return the file path that we save images &videos to it
  var path = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DCIM);
  Directory directory =
      Directory("$path/CameraAppFlutter/images"); // saving media path
  if ((await Permission.storage.status) == PermissionStatus.granted &&
      (await Permission.camera.status) == PermissionStatus.granted &&
      (await Permission.microphone.status) == PermissionStatus.granted) {
    permissionsGranted = true;
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }
  return directory.path;
}

Directory getDir(
  String path,
) {
  Directory d = Directory(path);
  return d;
}

// showing toasts
void showCustomToast(
    {required String msg,
    required Color textColor,
    required double fontSize,
    required Color backGroundColor}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: backGroundColor,
      textColor: textColor,
      fontSize: fontSize);
}

Timer recordingTimer(
    {required int duration,
    required CameraController? cameraController,
    required bool IsRecording,
    required List<VideoModel> videoClips,
    required Function function}) {
  return Timer.periodic(Duration(seconds: duration), (timer) {
    if (cameraController!.value.isRecordingVideo) {
      cameraController.stopVideoRecording().then((video) async {
        var info=await videoInfo.getVideoInfoInstance()!.getVideoInfo(video.path);
        int duration=info!.duration!~/1000;
        VideoModel videoModel = VideoModel(video.path.toString(),isFlagged: isFlagged,flagsModels: Flags,videoDuration: duration);
        videoClips.add(videoModel);
        if(videoModel.isFlagged){
          FlaggedVideoBox!.add(videoModel);
        }
        isFlagged=false;//set the flag to its initial value cause we have finished the recording operation
        Flags=[];
        if (videoClips.length > 1) {
          VideoModel v = videoClips.elementAt(videoClips.length - 2);
          videoClips.removeAt(videoClips.length - 2);
          File file = File(v.path.toString());
          if(!videoModel.isFlagged) {
            file.deleteSync();
          }
        }
        cameraController.startVideoRecording().then((value) {
          durationTimer!.cancel();
          customProcessingTimer = 0;
          function();
          durationTimer =
              Timer.periodic(Duration(seconds:fileDurationInSec), (timer) {
            if (cameraController.value.isRecordingVideo) {
              cameraController.stopVideoRecording().then((video) async {
                var info=await videoInfo.getVideoInfoInstance()!.getVideoInfo(video.path);
                int duration=info!.duration!~/1000;
                VideoModel videoModel = VideoModel(video.path.toString(),isFlagged: isFlagged,flagsModels: Flags,videoDuration: duration);
                videoClips.add(videoModel);
                if(videoModel.isFlagged){
                  FlaggedVideoBox!.add(videoModel);
                }
                isFlagged=false; //set the flag to its initial value cause we have finished the recording operation
                Flags=[];
                if (videoClips.length > 1) {
                  VideoModel v = videoClips.elementAt(videoClips.length - 2);
                  videoClips.removeAt(videoClips.length - 2);
                  File file = File(v.path.toString());
                  if(!videoModel.isFlagged) {
                    file.deleteSync();
                  }
                }
                cameraController.startVideoRecording().then((value) {
                  customProcessingTimer = 0;
                  function();
                });
              }).catchError((onError) {
                print("$onError");
              });
            }
          });
        });
      }).catchError((onError) {
        print("$onError");
      });
    }
  });
}
VideoFlag validateFlagPoint(VideoFlag flagModel, int? videoDuration) {
  int startPoint =
  (flagModel.flagPoint! - flagModel.BeforeFlag!).toInt();
  int endPoint = (flagModel.flagPoint!+ flagModel.afterFlag!).toInt();
  int duration =
  videoDuration!; // convert to seconds instead of milliseconds
  if (startPoint < 0) {
    startPoint = 0;
  }
  if (endPoint > duration) {
    endPoint = duration;
  }



  return VideoFlag(
      flagPoint: flagModel.flagPoint,
      afterFlag: endPoint,
      BeforeFlag: startPoint);
}

