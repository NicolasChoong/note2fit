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
      ExerciseSet(12, 100.0, 9, false),
      ExerciseSet(12, 95.0, 7, false),
      ExerciseSet(12, 90.0, 6, false)
    ];
    final sampleSet2 = [
      ExerciseSet(12, 80.0, 8, false),
      ExerciseSet(12, 75.0, 5, false)
    ];

    final sampleExerciseList1 = [
      Exercise("Bench Press", sampleSet1, false),
      Exercise("Barbell Row", sampleSet2, false)
    ];

    final sampleExerciseList2 = [
      Exercise("Squats", sampleSet2, false),
      Exercise("RDL", sampleSet1, false)
    ];

    final chestDay = Workout("Chest Day", sampleExerciseList1, false, DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    final legDay = Workout("Leg Day", sampleExerciseList2, false, DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));

    var workoutWeekPlan = [
      chestDay,
      legDay,
      null,
      chestDay,
      legDay,
      null,
      null
    ];

    var workoutWeekPlan2 = [
      null,
      null,
      chestDay,
      null,
      null,
      chestDay,
      legDay,
    ];

    var workoutPlan = WorkoutPlan(0, "Main Workout", DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), workoutWeekPlan);
    var workoutPlan2 = WorkoutPlan(1, "Backup Workout", DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), workoutWeekPlan2);

    await BaseClass.box.clear();
    await BaseClass.box.put(workoutPlan.workoutPlanId, workoutPlan);
    await BaseClass.box.put(workoutPlan2.workoutPlanId, workoutPlan2);
  }
}