import 'package:hive/hive.dart';

part 'ExerciseSetModel.g.dart';

@HiveType(typeId: 0)
class ExerciseSet {
  @HiveField(0)
  final int setNum;

  @HiveField(1)
  final int setTargetReps;

  @HiveField(2)
  final double setCurrentWeight;

  @HiveField(3)
  final int setCurrentReps;

  @HiveField(4)
  final bool isSetDone;

  ExerciseSet(this.setNum, this.setTargetReps, this.setCurrentWeight, this.setCurrentReps, this.isSetDone);
}