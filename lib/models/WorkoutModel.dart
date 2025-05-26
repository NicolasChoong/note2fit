import 'package:hive/hive.dart';
import 'ExerciseModel.dart';
import 'ExercisePlanModel.dart';

part 'WorkoutModel.g.dart';

@HiveType(typeId: 1)
class Workout {
  @HiveField(0)
  String workoutDayName;

  @HiveField(1)
  List<ExercisePlan> exercisePlans;

  @HiveField(2)
  DateTime lastWorkoutDate;

  bool get isWorkoutDone => exercisePlans.every((e) => e.isExercisePlanDone);
  
  int get totalExercise => exercisePlans
                          .map((exercisePlan) => exercisePlan.exercises.length)
                          .fold(0, (previousValue, currentValue) => previousValue + currentValue);

  Workout(this.workoutDayName, this.exercisePlans, this.lastWorkoutDate);
}

/*
class Workout {
  final String workoutName;
  final Map<String, WorkoutForTheDay> workoutForTheDay;

  Workout(this.workoutName, this.workoutForTheDay);
}*/