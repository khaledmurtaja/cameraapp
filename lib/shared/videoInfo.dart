import 'package:flutter_video_info/flutter_video_info.dart';

class videoInfo{
  static FlutterVideoInfo? _info;
  videoInfo._();

  static FlutterVideoInfo? getVideoInfoInstance(){
    if(_info==null){
      _info=FlutterVideoInfo();

    }
    return _info;
  }
}