// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EditedVideoModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EditedVideoModelAdapter extends TypeAdapter<EditedVideoModel> {
  @override
  final int typeId = 2;

  @override
  EditedVideoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EditedVideoModel(
      fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EditedVideoModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditedVideoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
