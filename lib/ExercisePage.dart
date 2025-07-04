import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:note2fit/models/ExerciseModel.dart';
import 'package:note2fit/models/ExerciseSetModel.dart';

import 'base.dart';
import 'models/WorkoutPlanModel.dart';

//Get today's date for workout date comparison
final DateTime todayDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

//These variables are made global, and they are 2 states that needs to use these
//Init workout plan and id for saving into hive box
late int workoutPlanId;
late WorkoutPlan workoutPlan;

//Get value from workout plan for this page
Exercise? exercise;
List<ExerciseSet>? exerciseSetList;

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
    String nameOfExercise = "";

    exercise = workoutPlan.workoutPlanDays[todayWorkout]!.exercises[widget.exerciseNum];
    if (exercise != null) {
      nameOfExercise = exercise!.exerciseName;
      exerciseSetList = exercise!.exerciseSets;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),

      /*Main App Bar*/
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(BaseClass.appBarHeight),
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
          /*App bar*/
          child: appBarDesign(nameOfExercise),
        ),
      ),

      /*Body containing a list of sets*/
      body: Center(
        child: exerciseSetList != null ? ListView.builder(
          padding: const EdgeInsets.only(top: 5),
          itemCount: exerciseSetList?.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
              /*Workout container*/
              child: ExerciseSetItem(exerciseSetNum: i),
            );
          },
        ) : const Center(child: Text("No sets detected."))
      ),
    );
  }

  Container appBarDesign(String exerciseName) {
    /*return AppBar(
      centerTitle: true,
      toolbarHeight: BaseClass.topBarHeight,
      title: Text(
        exerciseName,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500
        ),
      ),
      backgroundColor: const Color(0xFF005EAA),
    );*/
    return Container(
      height: BaseClass.appBarHeight,
      width: BaseClass.screenWidth,
      decoration: const BoxDecoration(
          color: Color(0xFFF8F8F8),
          border: Border(
              bottom: BorderSide(color: Color(0xFFE0E0E0), width: 2))),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 10,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset(
                  'images/back.svg',
                  width: 15,
                )),
          ),
          Text(
            exerciseName,
            style: const TextStyle(
                color: Color(0xFF262626),
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
        ],
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

  @override
  void initState() {
    super.initState();
    /*exercise = widget.workoutPlan.workoutWeekPlan[today]!.exercises[widget.exerciseNum];
    exerciseSetList = widget.workoutPlan.workoutWeekPlan[today]!.exercises[widget.exerciseNum].exerciseSets;
    exerciseSet = widget.workoutPlan.workoutWeekPlan[today]!.exercises[widget.exerciseNum].exerciseSets[widget.exerciseSetNum];
    weightController = TextEditingController(text: exerciseSet.setCurrentWeight.toString());
    repsController = TextEditingController(text: exerciseSet.setCurrentReps.toString());*/
    exerciseSet = exerciseSetList![widget.exerciseSetNum];
    weightController = TextEditingController(text: exerciseSet.setCurrentWeight.toString());
    repsController = TextEditingController(text: exerciseSet.setCurrentReps.toString());
  }

  @override
  void dispose() {
    weightController.dispose();
    repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Set ${widget.exerciseSetNum + 1}"),
        const Text("Weight"),
        TextField(
          controller: weightController,
          keyboardType: TextInputType.number,
          onChanged: (inputWeight) {
            exerciseSet.setCurrentWeight = double.tryParse(inputWeight) ?? 0;
            debugPrint("InputWeight is $inputWeight whereas updated weight now is ${exerciseSet.setCurrentWeight}");
          },
        ),
        Text("Target Reps: ${exerciseSet.setTargetReps}"),
        TextField(
          controller: repsController,
          keyboardType: TextInputType.number,
          onChanged: (inputReps) {
            exerciseSet.setCurrentReps = int.tryParse(inputReps) ?? 0;
            debugPrint("InputWeight is $inputReps whereas updated weight now is ${exerciseSet.setCurrentReps}");
          },
        ),
        Text("Is set done ${exerciseSet.isSetDone}"),
        ElevatedButton(
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
        )
      ],
    );
  }
}
