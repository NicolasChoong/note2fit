import 'dart:collection';

import 'ExerciseModel.dart';

class Workout {
  final String workoutName;
  final Map<String, WorkoutForTheDay> workoutForTheDay;

  Workout(this.workoutName, this.workoutForTheDay);
}