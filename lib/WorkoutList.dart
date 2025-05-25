
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:note2fit/SettingsPage.dart';
import 'dart:math' as math;
import 'package:note2fit/models/WorkoutPlanModel.dart';

import 'ExerciseList.dart';
import 'base.dart';
import 'models/ExerciseModel.dart';
import 'models/ExerciseSetModel.dart';
import 'models/WorkoutModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(ExerciseSetAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(WorkoutPlanAdapter());

  await Hive.openBox('workout_plan');
  await Hive.openBox('settings');

  await BaseClass.saveSampleWorkouts();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    BaseClass.init(context);

    return const MaterialApp(
      title: 'Flutter Demo',
      home: WorkoutList(),
    );
  }
}

class WorkoutList extends StatefulWidget {
  const WorkoutList({super.key});

  @override
  State<WorkoutList> createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((callback) {
      if (BaseClass.settingsBox.get("autoStartWorkout", defaultValue: false)) {
        for (int i = 0; i < BaseClass.box.length; i++) {
          final WorkoutPlan workoutPlan = BaseClass.box.get(i);
          if (workoutPlan.isDefaultWorkoutPlan) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ExerciseList(workoutPlanId: workoutPlan.workoutPlanId)),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),

      appBar: appBarDesign(),

      body: ListView.builder(
        padding: const EdgeInsets.only(top: 5),
        itemCount: BaseClass.box.length,
        itemBuilder: (context, i) {
          final WorkoutPlan workoutPlan = BaseClass.box.get(i);
          return Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: workoutContainer(workoutPlan),
          );
        },
      ),
    );
  }

  /*App bar widget*/
  PreferredSize appBarDesign() {
    return PreferredSize(
      preferredSize: Size.fromHeight(BaseClass.appBarHeight),
      /* Add shadow effect to app bar */
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x4D000000),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: AppBar(
          centerTitle: true,
          toolbarHeight: BaseClass.appBarHeight,
          title: const Text(
            "Workout List",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500
            ),
          ),
          backgroundColor: const Color(0xFF005EAA),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                "images/settings-icon.svg",
                width: 20,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SettingsPage()),
                );
              },
            ),
            // You can add more widgets here if you like!
          ]
        ),
      ),
    );
  }

  /*Workout container widget*/
  InkWell workoutContainer(WorkoutPlan workoutPlan) {
    final int daysPassed = todayDate.difference(workoutPlan.workoutPlanStartDate).inDays;
    final int todayWorkoutNum = daysPassed % workoutPlan.workoutPlanDays.length;
    Workout? todayWorkout = workoutPlan.workoutPlanDays[todayWorkoutNum];

    String todayWorkoutTotalSets() {
      if (todayWorkout != null) {
        int totalSets = 0;
        for (var exercise in todayWorkout.exercises) {
          totalSets += exercise.exerciseSets.length;
        }
        return totalSets.toString();
      }
      return "0";
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ExerciseList(workoutPlanId: workoutPlan.workoutPlanId)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(10),
          /*If workout is default, highlight blue, else, gray*/
          border: Border.all(
              color: workoutPlan.isDefaultWorkoutPlan ? const Color(0xFF005EAA) : const Color(0xFFE0E0E0),
              style: BorderStyle.solid,
              width: 1
          ),
          boxShadow: workoutPlan.isDefaultWorkoutPlan ? const [
            BoxShadow(
              color: Color(0x80005EAA),
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ] : const [
            BoxShadow(
              color: Color(0x1A000000),
              spreadRadius: 0,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column( /*Separate text and button*/
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 10),
              child: Column( /*Separate workout name and day details*/
                children: [
                  Row( /*Workout name and buttons*/
                    children: [
                      Text(
                        workoutPlan.workoutPlanName,
                        style: const TextStyle(
                          color: Color(0xFF313131),
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          'images/edit-icon.svg',
                          height: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SvgPicture.asset(
                        'images/back-icon.svg',
                        height: 18,
                      )
                    ],
                  ),
                  Column( /*Day details*/
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today",
                        style: TextStyle(
                          color: Color(0xFF696969),
                          fontSize: 14,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      todayWorkout != null ? Row(
                        children: [
                          SvgPicture.asset(
                            'images/weight-icon.svg',
                            height: 15,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            todayWorkout.workoutDayName,
                            style: const TextStyle(
                              color: Color(0xFF696969),
                              fontSize: 12,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          Container(
                            width: 1.5,
                            height: 12,
                            color: const Color(0xFFE0E0E0),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          Text(
                            "${todayWorkout.exercises.length.toString()} exercises",
                            style: const TextStyle(
                                color: Color(0xFF696969),
                                fontSize: 12,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          Container(
                            width: 1.5, // Line thickness
                            height: 12, // Line height
                            color: const Color(0xFFE0E0E0), // Line color
                            margin: const EdgeInsets.symmetric(horizontal: 8), // Space around the line
                          ),
                          Text(
                            "${todayWorkoutTotalSets()} sets",
                            style: const TextStyle(
                                color: Color(0xFF696969),
                                fontSize: 12,
                                fontWeight: FontWeight.w500
                            ),
                          )
                        ],
                      ) : Row(
                        children: [
                          SvgPicture.asset(
                            'images/rest-icon.svg',
                            height: 15,
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "Rest Day",
                            style: TextStyle(
                                color: Color(0xFF696969),
                                fontSize: 12,
                                fontWeight: FontWeight.w500
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container( /*View info button*/
              width: double.infinity,
              height: 35,
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF696969),
                  backgroundColor: const Color(0xFFF8F8F8),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                  ),
                  elevation: 0,
                ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          "View Info ",
                        style: TextStyle(
                          color: Color(0xFF005EAA),
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      Transform.rotate(
                          angle: math.pi / 2,
                        child: SvgPicture.asset(
                          'images/dropdown-icon.svg',
                          height: 10,
                          color: const Color(0xFF005EAA),
                        ),
                      )
                    ],
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
