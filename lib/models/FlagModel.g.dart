// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FlagModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class flagAdapter extends TypeAdapter<FlagModel> {
  @override
  final int typeId = 1;

  @override
  FlagModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlagModel(
      flagPoint: fields[4] as int?,
      beforeFlag: fields[5] as int?,
      afterFlag: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, FlagModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(4)
      ..write(obj.flagPoint)
      ..writeByte(5)
      ..write(obj.beforeFlag)
      ..writeByte(6)
      ..write(obj.afterFlag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is flagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
