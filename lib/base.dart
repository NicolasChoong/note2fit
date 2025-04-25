import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import 'models/ExerciseModel.dart';
import 'models/ExerciseSetModel.dart';
import 'models/WorkoutModel.dart';
import 'models/WorkoutPlanModel.dart';

class BaseClass {
  static late double screenHeight;
  static late double screenWidth;
  static late double topBarHeight;

  static void init(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    topBarHeight = screenHeight * 0.075;
  }

  static List<String> dayString = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

  static Box box = Hive.box('workout_plan');

  static Future<void> saveSampleWorkouts() async {
    final sampleSet1 = [
      ExerciseSet(1, 12, 100.0, 9, false),
      ExerciseSet(2, 12, 95.0, 7, false),
      ExerciseSet(3, 12, 90.0, 6, false)
    ];
    final sampleSet2 = [
      ExerciseSet(1, 12, 80.0, 8, false),
      ExerciseSet(2, 12, 75.0, 5, false)
    ];

    final sampleExerciseList1 = [
      Exercise("Bench Press", sampleSet1),
      Exercise("Barbell Row", sampleSet2)
    ];

    final sampleExerciseList2 = [
      Exercise("Squats", sampleSet2),
      Exercise("RDL", sampleSet1)
    ];

    final chestDay = Workout("Chest Day", sampleExerciseList1);
    final legDay = Workout("Leg Day", sampleExerciseList2);

    var workoutWeekPlan = {
      "Sunday": chestDay,
      "Tuesday": legDay
    };

    var workoutWeekPlan2 = {
      "Monday": chestDay,
      "Friday": legDay
    };

    var workoutPlan = WorkoutPlan("Main Workout", workoutWeekPlan);
    var workoutPlan2 = WorkoutPlan("Backup Workout", workoutWeekPlan2);

    await BaseClass.box.clear();
    await BaseClass.box.put(0, workoutPlan);
    await BaseClass.box.put(1, workoutPlan2);
  }
}