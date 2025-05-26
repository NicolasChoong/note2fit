// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ExerciseSetModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseSetAdapter extends TypeAdapter<ExerciseSet> {
  @override
  final int typeId = 4;

  @override
  ExerciseSet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseSet(
      fields[0] as int,
      fields[1] as double,
      fields[2] as int,
      fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseSet obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.setTargetReps)
      ..writeByte(1)
      ..write(obj.setCurrentWeight)
      ..writeByte(2)
      ..write(obj.setCurrentReps)
      ..writeByte(3)
      ..write(obj.isSetDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseSetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
