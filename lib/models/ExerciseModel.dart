import 'package:hive/hive.dart';
import 'ExerciseSetModel.dart';

part 'ExerciseModel.g.dart';

@HiveType(typeId: 1)
class Exercise extends HiveObject {
  @HiveField(0)
  String exerciseName;

  @HiveField(1)
  List<ExerciseSet> exerciseSets;

  @HiveField(2)
  bool isExerciseDone = false;

  Exercise(this.exerciseName, this.exerciseSets, this.isExerciseDone);
}