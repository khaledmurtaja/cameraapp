import 'package:hive/hive.dart';
part 'EditedVideoModel.g.dart';
@HiveType(typeId: 1)
class EditedVideoModel{
  @HiveField(1)
  String? path;

  EditedVideoModel(this.path);
}