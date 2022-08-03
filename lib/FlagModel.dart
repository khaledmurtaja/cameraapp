import 'package:hive/hive.dart';

part 'FlagModel.g.dart';
@HiveType( typeId : 1,adapterName: "flagAdapter")
class FlagModel {
  @HiveField(4)
  int? flagPoint;
  @HiveField(5)
  int? beforeFlag;
  @HiveField(6)
  int? afterFlag;

  FlagModel(
      {required this.flagPoint,
      required this.beforeFlag,
      required this.afterFlag});
}
