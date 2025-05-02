// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WorkoutPlanModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutPlanAdapter extends TypeAdapter<WorkoutPlan> {
  @override
  final int typeId = 3;

  @override
  WorkoutPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutPlan(
      fields[0] as int,
      fields[1] as String,
      (fields[2] as Map).cast<String, Workout>(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutPlan obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.workoutPlanId)
      ..writeByte(1)
      ..write(obj.workoutPlanName)
      ..writeByte(2)
      ..write(obj.workoutWeekPlan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
