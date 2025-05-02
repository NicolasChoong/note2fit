import 'package:hive/hive.dart';
import 'ExerciseModel.dart';

part 'WorkoutModel.g.dart';

@HiveType(typeId: 2)
class Workout {
  @HiveField(0)
  String workoutDayName;

  @HiveField(1)
  List<Exercise> exercises;

  @HiveField(2)
  bool isWorkoutDone = false;

  @HiveField(3)
  DateTime lastWorkoutDate;

  Workout(this.workoutDayName, this.exercises, this.isWorkoutDone, this.lastWorkoutDate);
}

/*
class Workout {
  final String workoutName;
  final Map<String, WorkoutForTheDay> workoutForTheDay;

  Workout(this.workoutName, this.workoutForTheDay);
}*/