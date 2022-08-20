
import 'package:cameraapp/models/FlagModel.dart';
import 'package:hive/hive.dart';
part 'videoModel.g.dart';
@HiveType( typeId : 0,adapterName: "videoModelAdapter")
class VideoModel{
  @HiveField(1)
  String? path;
  @HiveField(2)
  bool isFlagged=false;
  @HiveField(3)
  List<FlagModel> flagsModels=[];
  VideoModel(this.path, {required this.isFlagged,required this.flagsModels});
}