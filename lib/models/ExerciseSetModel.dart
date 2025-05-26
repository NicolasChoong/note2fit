import 'package:hive/hive.dart';

part 'ExerciseSetModel.g.dart';

@HiveType(typeId: 4)
class ExerciseSet {
  @HiveField(0)
  int setTargetReps;

  @HiveField(1)
  double setCurrentWeight;

  @HiveField(2)
  int setCurrentReps;

  @HiveField(3)
  bool isSetDone = false;

  ExerciseSet(this.setTargetReps, this.setCurrentWeight, this.setCurrentReps, this.isSetDone);
}