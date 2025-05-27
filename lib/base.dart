import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:note2fit/models/ExercisePlanModel.dart';

import 'models/ExerciseModel.dart';
import 'models/ExerciseSetModel.dart';
import 'models/WorkoutModel.dart';
import 'models/WorkoutPlanModel.dart';

class BaseClass {
  static late double screenHeight;
  static late double screenWidth;
  static late double appBarHeight;

  static void init(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    appBarHeight = screenHeight * 0.06;
  }

  static Box box = Hive.box('workout_plan');
  static Box settingsBox = Hive.box('settings');

  static Future<void> saveSampleWorkouts() async {

    var sampleSet1 = [
      ExerciseSet(12, 100.0, 9, false),
      ExerciseSet(10, 95.0, 7, false),
      ExerciseSet(12, 90.0, 6, false)
    ];
    var sampleExercise1 = [
      Exercise("Bench Press", sampleSet1)
    ];

    var sampleSet2 = [
      ExerciseSet(12, 80.0, 5, false),
      ExerciseSet(12, 75.0, 4, false)
    ];
    var sampleExercise2 = [
      Exercise("Barbell Row", sampleSet2)
    ];

    var sampleSet3 = [
      ExerciseSet(12, 140.0, 8, false),
      ExerciseSet(12, 135.0, 7, false)
    ];
    var sampleExercise3 = [
      Exercise("Squats", sampleSet3)
    ];

    var sampleSet4 = [
      ExerciseSet(12, 180.0, 10, false),
      ExerciseSet(12, 165.0, 11, false)
    ];
    var sampleExercise4 = [
      Exercise("RDL", sampleSet4)
    ];

    var sampleSet5 = [
      ExerciseSet(12, 50.0, 7, false),
      ExerciseSet(12, 45.0, 5, false),
      ExerciseSet(12, 40.0, 4, false),
      ExerciseSet(12, 40.0, 4, false)
    ];
    var sampleSet6 = [
      ExerciseSet(12, 25.0, 6, false),
      ExerciseSet(12, 30.0, 6, false),
      ExerciseSet(12, 25.0, 6, false)
    ];
    var sampleSet7 = [
      ExerciseSet(12, 30.0, 6, false),
      ExerciseSet(12, 25.0, 6, false)
    ];
    var sampleExercise5 = [
      Exercise("Tricep Extension", sampleSet5),
      Exercise("Bicep Curls", sampleSet6),
      Exercise("Rear Delts", sampleSet7)
    ];

    var sampleExercisePlan1 = [
      ExercisePlan(sampleExercise1.map((e) => e.exerciseName).join(" + "), sampleExercise1),
      ExercisePlan(sampleExercise2.map((e) => e.exerciseName).join(" + "), sampleExercise2),
      ExercisePlan(sampleExercise5.map((e) => e.exerciseName).join(" + "), sampleExercise5)
    ];

    var sampleExercisePlan2 = [
      ExercisePlan(sampleExercise3.map((e) => e.exerciseName).join(" + "), sampleExercise3),
      ExercisePlan(sampleExercise4.map((e) => e.exerciseName).join(" + "), sampleExercise4),
      ExercisePlan(sampleExercise5.map((e) => e.exerciseName).join(" + "), sampleExercise5)
    ];

    final chestDay = Workout("Chest Day", sampleExercisePlan1, DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    final legDay = Workout("Leg Day", sampleExercisePlan2, DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));

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

    var workoutPlan = WorkoutPlan(0, "Main Workout", DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), true, workoutWeekPlan);
    var workoutPlan2 = WorkoutPlan(1, "Backup Workout", DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day), false, workoutWeekPlan2);

    await BaseClass.box.clear();
    await BaseClass.box.put(workoutPlan.workoutPlanId, workoutPlan);
    await BaseClass.box.put(workoutPlan2.workoutPlanId, workoutPlan2);
  }

  static bool autoStartWorkout = true;
  static bool temporarySelectWorkout = false;
}