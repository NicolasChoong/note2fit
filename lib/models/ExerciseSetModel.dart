import 'package:hive/hive.dart';

part 'ExerciseSetModel.g.dart';

@HiveType(typeId: 0)
class ExerciseSet {
  @HiveField(0)
  int setNum;

  @HiveField(1)
  int setTargetReps;

  @HiveField(2)
  double setCurrentWeight;

  @HiveField(3)
  int setCurrentReps;

  @HiveField(4)
  bool isSetDone = false;

  ExerciseSet(this.setNum, this.setTargetReps, this.setCurrentWeight, this.setCurrentReps, this.isSetDone);
}