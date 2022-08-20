// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videoModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************


class videoModelAdapter extends TypeAdapter<VideoModel> {
  @override
  final int typeId = 0;

  @override
  VideoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoModel(
      fields[1] as String?,
      isFlagged: fields[2] as bool,
      flagsModels: (fields[3] as List).cast<FlagModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, VideoModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.isFlagged)
      ..writeByte(3)
      ..write(obj.flagsModels);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is videoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
