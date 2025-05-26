// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ExercisePlanModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExercisePlanAdapter extends TypeAdapter<ExercisePlan> {
  @override
  final int typeId = 2;

  @override
  ExercisePlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExercisePlan(
      fields[0] as String,
      (fields[1] as List).cast<Exercise>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExercisePlan obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.exercisePlanName)
      ..writeByte(1)
      ..write(obj.exercises);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExercisePlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
