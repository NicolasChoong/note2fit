import 'package:hive/hive.dart';
import 'ExerciseModel.dart';

part 'ExercisePlanModel.g.dart';

@HiveType(typeId: 2)
class ExercisePlan extends HiveObject {
  @HiveField(0)
  String exercisePlanName;

  @HiveField(1)
  List<Exercise> exercises;

  int get totalSets => exercises
                        .map((exercise) => exercise.exerciseSets.length)
                        .fold(0, (previousValue, currentValue) => previousValue + currentValue);

  bool get isExercisePlanDone => exercises.every((e) => e.isExerciseDone);

  ExercisePlan(this.exercisePlanName, this.exercises);
}