import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:note2fit/models/ExerciseModel.dart';
import 'package:note2fit/models/ExerciseSetModel.dart';

import 'base.dart';
import 'models/WorkoutModel.dart';
import 'models/WorkoutPlanModel.dart';

//Get today's date for workout date comparison
final DateTime todayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

//These variables are made global, and they are 2 states that needs to use these
//Init workout plan and id for saving into hive box
late int workoutPlanId;
late WorkoutPlan workoutPlan;

//Get value from workout plan for this page
DateTime? lastWorkoutDate;
Exercise? exercise;
List<ExerciseSet>? exerciseSetList;

//For UI purposes only
String nameOfExercise = "";

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key, required this.workoutPlanId, required this.exerciseNum});

  final int workoutPlanId;
  final int exerciseNum;

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  @override
  Widget build(BuildContext context) {
    BaseClass.init(context);

    workoutPlanId = widget.workoutPlanId;
    workoutPlan = BaseClass.box.get(workoutPlanId);

    //Get today's workout for exercise variable only
    final DateTime startDateOfWorkoutPlan = workoutPlan.workoutPlanStartDate;
    final int daysPassed = todayDate.difference(startDateOfWorkoutPlan).inDays;
    final int todayWorkout = daysPassed % workoutPlan.workoutPlanDays.length;

    lastWorkoutDate = workoutPlan.workoutPlanDays[todayWorkout]?.lastWorkoutDate;
    exercise = workoutPlan.workoutPlanDays[todayWorkout]?.exercises[widget.exerciseNum];
    if (exercise != null) {
      nameOfExercise = exercise!.exerciseName;
      exerciseSetList = exercise!.exerciseSets;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      /*Main App Bar*/
      appBar: appBarDesign(),
      /*Body containing a list of sets*/
      body: exerciseSetList != null ? ListView.builder(
        padding: const EdgeInsets.only(top: 5),
        itemCount: exerciseSetList?.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            /*Workout container*/
            child: ExerciseSetItem(exerciseSetNum: i),
          );
        },
      ) : const Center(child: Text("No sets detected.")),
    );
  }

  /*App bar widget*/
  PreferredSize appBarDesign() {
    Future<void> saveAndExit(BuildContext context) async {
      await BaseClass.box.put(workoutPlanId, workoutPlan);
      Navigator.pop(context);
    }

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
                /*Navigator.pop(context);*/
                saveAndExit(context);
              },
              icon: Transform.rotate(
                angle: math.pi,
                child: SvgPicture.asset(
                  'images/back-icon.svg',
                  height: 14,
                ),
              )),
          title: Text(
            nameOfExercise,
            style: const TextStyle(
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
}

class ExerciseSetItem extends StatefulWidget {
  final int exerciseSetNum;

  const ExerciseSetItem({
    super.key,
    required this.exerciseSetNum
  });

  @override
  _ExerciseSetItemState createState() => _ExerciseSetItemState();
}

class _ExerciseSetItemState extends State<ExerciseSetItem> {
  late TextEditingController weightController;
  late TextEditingController repsController;

  late ExerciseSet exerciseSet;

  String currentWeight = "";
  String currentReps = "";

  @override
  void initState() {
    super.initState();
    /*exercise = widget.workoutPlan.workoutWeekPlan[today]!.exercises[widget.exerciseNum];
    exerciseSetList = widget.workoutPlan.workoutWeekPlan[today]!.exercises[widget.exerciseNum].exerciseSets;
    exerciseSet = widget.workoutPlan.workoutWeekPlan[today]!.exercises[widget.exerciseNum].exerciseSets[widget.exerciseSetNum];
    weightController = TextEditingController(text: exerciseSet.setCurrentWeight.toString());
    repsController = TextEditingController(text: exerciseSet.setCurrentReps.toString());*/
    exerciseSet = exerciseSetList![widget.exerciseSetNum];

    if (exerciseSet.isSetDone) {
      weightController = TextEditingController(text: exerciseSet.setCurrentWeight.toString());
      repsController = TextEditingController(text: exerciseSet.setCurrentReps.toString());
    } else {
      weightController = TextEditingController(text: "");
      repsController = TextEditingController(text: "");
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: exerciseSet.isSetDone ? const Color(0xFF00BF33) : const Color(0xFFE0E0E0),
            style: BorderStyle.solid,
            width: 1
        ),
        boxShadow: exerciseSet.isSetDone ? const [
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Set ${widget.exerciseSetNum + 1}",
              style: const TextStyle(
                  color: Color(0xFF313131),
                  fontSize: 18,
                  fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 5),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recorded weight and reps",
                  style: TextStyle(
                      color: Color(0xFF696969),
                      fontSize: 12,
                      fontWeight: FontWeight.w500
                  )
                ),
                Text(
                  "Target :",
                  style: TextStyle(
                      color: Color(0xFF005EAA),
                      fontSize: 12,
                      fontWeight: FontWeight.w500
                  )
                )
              ],
            ),
            const SizedBox(height: 3),
            IntrinsicHeight(
              child: Row(
                children: [
                  Row(
                    children: [
                      Text(
                        exerciseSet.setCurrentWeight.toString(),
                        style: const TextStyle(
                            color: Color(0xFF262626),
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        )
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "KG",
                          style: TextStyle(
                              color: Color(0xFF262626),
                              fontSize: 12,
                              fontWeight: FontWeight.w500
                          )
                      )
                    ],
                  ),
                  const VerticalDivider(
                    width: 20,
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
                    indent: 3,
                    endIndent: 3,
                  ),
                  Row(
                    children: [
                      Text(
                        exerciseSet.setCurrentReps.toString(),
                        style: const TextStyle(
                            color: Color(0xFF262626),
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                          "reps",
                          style: TextStyle(
                              color: Color(0xFF262626),
                              fontSize: 12,
                              fontWeight: FontWeight.w500
                          )
                      )
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        exerciseSet.setTargetReps.toString(),
                        style: const TextStyle(
                            color: Color(0xFF005EAA),
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                          "reps",
                          style: TextStyle(
                              color: Color(0xFF005EAA),
                              fontSize: 12,
                              fontWeight: FontWeight.w500
                          )
                      )
                    ],
                  ),
                ],
              ),
            ),
            exerciseSet.setCurrentReps == exerciseSet.setTargetReps
                ? const Text(
                  "You hit your target reps!",
                  style: TextStyle(
                      color: Color(0xFF00BF33),
                      fontSize: 12,
                      fontWeight: FontWeight.w500
                  )
                )
                : const SizedBox.shrink(),
            const Divider(
              height: 20,
              thickness: 1,
              color: Color(0xFFE0E0E0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Enter weight:",
                  style: TextStyle(
                      color: Color(0xFF696969),
                      fontSize: 12
                  )
                ),
                SizedBox(
                  width: 110,
                  height: 35,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: const TextSelectionThemeData(
                        cursorColor: Color(0xFF005EAA),
                        selectionColor: Color(0x4D005EAA),
                        selectionHandleColor: Color(0xFF005EAA),
                      ),
                    ),
                    child: TextField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      onChanged: (inputWeight) {
                        exerciseSet.setCurrentWeight = double.tryParse(inputWeight) ?? exerciseSet.setCurrentWeight;
                        if (weightController.text != "" && double.parse(weightController.text) > 0 && repsController.text != "" && double.parse(repsController.text) > 0) {
                          exerciseSet.isSetDone = true;
                        } else {
                          exerciseSet.isSetDone = false;
                        }
                        debugPrint("InputWeight is $inputWeight whereas updated weight now is ${exerciseSet.setCurrentWeight}");
                      },
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                          color: Color(0xFF262626),
                          fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8F8F8),
                        contentPadding: const EdgeInsets.only(left: 10, right: 10),
                          hintText: "-",
                          hintStyle: const TextStyle(
                            color: Color(0xFFAAAAAA),
                            fontSize: 18,
                            fontWeight: FontWeight.w400
                          ),
                        suffixText: 'KG', // Read-only suffix
                        suffixStyle: const TextStyle(
                          color: Color(0xFF262626),
                          fontSize: 12,
                          fontWeight: FontWeight.w500
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Color(0xFF696969),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Color(0xFF005EAA),
                            width: 2,
                          ),
                        )
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                    "Enter reps:",
                    style: TextStyle(
                        color: Color(0xFF696969),
                        fontSize: 12
                    )
                ),
                SizedBox(
                  width: 110,
                  height: 35,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: const TextSelectionThemeData(
                        cursorColor: Color(0xFF005EAA),
                        selectionColor: Color(0x4D005EAA),
                        selectionHandleColor: Color(0xFF005EAA),
                      ),
                    ),
                    child: TextField(
                      controller: repsController,
                      keyboardType: TextInputType.number,
                      onChanged: (inputReps) {
                        exerciseSet.setCurrentReps = int.tryParse(inputReps) ?? exerciseSet.setCurrentReps;
                        if (weightController.text != "" && double.parse(weightController.text) > 0 && repsController.text != "" && double.parse(repsController.text) > 0) {
                          exerciseSet.isSetDone = true;
                        } else {
                          exerciseSet.isSetDone = false;
                        }
                        debugPrint("InputWeight is $inputReps whereas updated weight now is ${exerciseSet.setCurrentReps}");
                      },
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                        color: Color(0xFF262626),
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF8F8F8),
                          contentPadding: const EdgeInsets.only(left: 10, right: 10),
                          hintText: "-",
                          hintStyle: const TextStyle(
                              color: Color(0xFFC4C4C4),
                              fontSize: 18,
                              fontWeight: FontWeight.w400
                          ),
                          suffixText: 'reps', // Read-only suffix
                          suffixStyle: const TextStyle(
                              color: Color(0xFF262626),
                              fontSize: 12,
                              fontWeight: FontWeight.w500
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Color(0xFF696969),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Color(0xFF005EAA),
                              width: 2,
                            ),
                          )
                      ),
                    ),
                  ),
                ),
              ],
            ),
            /*Text("Is set done ${exerciseSet.isSetDone}"),*/
            /*ElevatedButton(
              onPressed: () {
                setState(() {
                  exerciseSet.isSetDone = !exerciseSet.isSetDone;
                  if (exerciseSetList!.every((x) => x.isSetDone)) {
                    exercise?.isExerciseDone = true;
                  } else {
                    exercise?.isExerciseDone = false;
                  }
                  BaseClass.box.put(workoutPlanId, workoutPlan);
                });
                debugPrint("Current weight is ${exerciseSet.setCurrentWeight}\nCurrent reps is ${exerciseSet.setCurrentReps}");

              },
              child: !exerciseSet.isSetDone ? const Text("Finish and Save Set") : const Text("Edit Set"),
            )*/
          ],
        ),
      ),
    );
  }
}
