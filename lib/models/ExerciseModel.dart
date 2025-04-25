import 'package:hive/hive.dart';
import 'ExerciseSetModel.dart';

part 'ExerciseModel.g.dart';

@HiveType(typeId: 1)
class Exercise {
  @HiveField(0)
  final String exerciseName;

  @HiveField(1)
  final List<ExerciseSet> exerciseSets;

  Exercise(this.exerciseName, this.exerciseSets);
}