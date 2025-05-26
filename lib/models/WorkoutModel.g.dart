// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WorkoutModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutAdapter extends TypeAdapter<Workout> {
  @override
  final int typeId = 1;

  @override
  Workout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Workout(
      fields[0] as String,
      (fields[1] as List).cast<ExercisePlan>(),
      fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Workout obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.workoutDayName)
      ..writeByte(1)
      ..write(obj.exercisePlans)
      ..writeByte(2)
      ..write(obj.lastWorkoutDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
