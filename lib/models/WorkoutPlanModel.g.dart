// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WorkoutPlanModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutPlanAdapter extends TypeAdapter<WorkoutPlan> {
  @override
  final int typeId = 0;

  @override
  WorkoutPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutPlan(
      fields[0] as int,
      fields[1] as String,
      fields[2] as DateTime,
      fields[3] as bool,
      (fields[4] as List).cast<Workout?>(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutPlan obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.workoutPlanId)
      ..writeByte(1)
      ..write(obj.workoutPlanName)
      ..writeByte(2)
      ..write(obj.workoutPlanStartDate)
      ..writeByte(3)
      ..write(obj.isDefaultWorkoutPlan)
      ..writeByte(4)
      ..write(obj.workoutPlanDays);
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
