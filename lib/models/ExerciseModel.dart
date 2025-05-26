import 'package:hive/hive.dart';
import 'ExerciseSetModel.dart';

part 'ExerciseModel.g.dart';

@HiveType(typeId: 3)
class Exercise extends HiveObject {
  @HiveField(0)
  String exerciseName;

  @HiveField(1)
  List<ExerciseSet> exerciseSets;

  bool get isExerciseDone => exerciseSets.every((e) => e.isSetDone);

  Exercise(this.exerciseName, this.exerciseSets);
}