import 'package:hive/hive.dart';
import 'ExerciseModel.dart';

part 'WorkoutModel.g.dart';

@HiveType(typeId: 2)
class Workout {
  @HiveField(0)
  final String workoutDayName;

  @HiveField(1)
  final List<Exercise> exercises;

  Workout(this.workoutDayName, this.exercises);
}

/*
class Workout {
  final String workoutName;
  final Map<String, WorkoutForTheDay> workoutForTheDay;

  Workout(this.workoutName, this.workoutForTheDay);
}*/