import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:note2fit/models/WorkoutPlanModel.dart';

import 'ExercisePage.dart';
import 'base.dart';
import 'models/ExerciseModel.dart';
import 'models/ExerciseSetModel.dart';
import 'models/WorkoutModel.dart';

//Get today's date for workout date comparison
final DateTime todayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

class ExerciseList extends StatefulWidget {
  const ExerciseList({super.key, required this.workoutPlanId});

  final int workoutPlanId;

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  //Init workout plan and id for saving into hive box
  late int workoutPlanId;
  late WorkoutPlan workoutPlan;
  Workout? workoutToday;
  List<Exercise>? exerciseList;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData(){
    setState(() {
      workoutPlanId = widget.workoutPlanId;
      workoutPlan = BaseClass.box.get(workoutPlanId);

      final int daysPassed = todayDate.difference(workoutPlan.workoutPlanStartDate).inDays;
      final int todayWorkoutNum = daysPassed % workoutPlan.workoutPlanDays.length;
      workoutToday = workoutPlan.workoutPlanDays[todayWorkoutNum];

      if (workoutToday != null) {
        /*nameOfWorkoutDay = workoutPlan.workoutPlanDays[todayWorkoutNum]?.workoutDayName;
        exerciseList = workoutPlan.workoutPlanDays[todayWorkoutNum]?.exercises;
        isWorkoutDone = workoutPlan.workoutPlanDays[todayWorkoutNum]?.isWorkoutDone;*/
        exerciseList = workoutToday?.exercises;

        DateTime? lastWorkoutDate = workoutPlan.workoutPlanDays[todayWorkoutNum]?.lastWorkoutDate;
        if (todayDate.isAfter(lastWorkoutDate!)) {
          workoutToday?.lastWorkoutDate = todayDate;
          workoutToday?.isWorkoutDone = false;

          debugPrint("Exercise list is ${exerciseList?.length}");

          if (exerciseList != null && exerciseList!.isNotEmpty) {
            for (Exercise exercise in exerciseList!) {
              exercise.isExerciseDone = false;
              for (ExerciseSet exerciseSet in exercise.exerciseSets) {
                exerciseSet.isSetDone = false;
              }
            }
          }

          BaseClass.box.put(workoutPlanId, workoutPlan);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    BaseClass.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),

      appBar: appBarDesign(),

      body: workoutToday?.workoutDayName != null
          ? (exerciseList != null
          ? ListView.builder(
          padding: const EdgeInsets.only(top: 5),
          itemCount: exerciseList!.length,
          itemBuilder: (context, i) {
            Exercise? exercise = exerciseList?[i];
            return Padding(
              padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: exerciseContainer(exercise!, context, i),
            );
          })
          : const Center(child: Text("No exercise detected.")))
          : const Center(child: Text("It's rest day brother, take a good rest!")),
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
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Transform.rotate(
                angle: math.pi,
                child: SvgPicture.asset(
                  'images/back-icon.svg',
                  height: 14,
                ),
              )),
          title: workoutToday?.workoutDayName != null ? const Text(
            "Workout List",
            style: TextStyle(
                color: Color(0xFF262626),
                fontSize: 18,
                fontWeight: FontWeight.w500
            ),
          ) : const Text(
            "Rest Day",
            style: TextStyle(
                color: Color(0xFF262626),
                fontSize: 18,
                fontWeight: FontWeight.w500
            ),
          ),
          backgroundColor: const Color(0xFFF8F8F8),
        ),
      ),
    );
  }

  InkWell exerciseContainer(Exercise exercise, BuildContext context, int exerciseNum) {

    String exerciseReps() {
      List<int> setTargetReps = [];
      String repsList = "";

      for (var exerciseSet in exercise.exerciseSets) {
        setTargetReps.add(exerciseSet.setTargetReps);
      }
      if (setTargetReps.every((e) => e == setTargetReps.first)) {
        return setTargetReps.first.toString();
      } else {
        for (int i = 0; i < setTargetReps.length; i++) {
          if (i == 0) {
            repsList = "${setTargetReps[i]}";
          } else {
            repsList = "$repsList, ${setTargetReps[i]}";
          }
        }
        return repsList;
      }
    }

    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ExercisePage(workoutPlanId: widget.workoutPlanId, exerciseNum: exerciseNum)),
        );
        loadData();
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: exercise.isExerciseDone ? const Color(0xFF00BF33) : const Color(0xFFE0E0E0),
              style: BorderStyle.solid,
              width: 1
          ),
          boxShadow: exercise.isExerciseDone ? const [
            BoxShadow(
              color: Color(0x8000BF33),
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
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
          child: Column( /*Separate exercise name and sets*/
            children: [
              Row(
                children: [
                  Text(
                   "${exerciseNum + 1}. ${exercise.exerciseName}",
                   style: const TextStyle(
                       color: Color(0xFF313131),
                       fontSize: 18,
                       fontWeight: FontWeight.w500
                   )
                  ),
                  const Spacer(),
                  exercise.isExerciseDone ? SvgPicture.asset(
                    'images/view-icon.svg',
                    height: 20,
                  ) : SvgPicture.asset(
                    'images/back-icon.svg',
                    height: 16,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  SvgPicture.asset(
                    'images/info-icon.svg',
                    height: 14,
                    color: const Color(0xFF696969),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${exercise.exerciseSets.length} sets ${exerciseReps()} reps",
                    style: const TextStyle(
                        color: Color(0xFF696969),
                        fontSize: 12,
                        fontWeight: FontWeight.w500
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}
