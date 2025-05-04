import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:note2fit/models/WorkoutPlanModel.dart';

import 'ExercisePage.dart';
import 'base.dart';
import 'models/ExerciseModel.dart';
import 'models/ExerciseSetModel.dart';

//Get today's date for workout day
final String today = DateFormat.EEEE().format(DateTime.now());

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

  //Get value from workout plan for this page
  late String? nameOfWorkoutDay;
  late List<Exercise>? exerciseList;
  late bool? isWorkoutDone;
  DateTime? lastWorkoutDate;

  void loadData(){
    setState(() {
      workoutPlanId = widget.workoutPlanId;
      workoutPlan = BaseClass.box.get(workoutPlanId);
      if (workoutPlan.workoutWeekPlan.keys.contains(today)) {
        nameOfWorkoutDay = workoutPlan.workoutWeekPlan[today]?.workoutDayName;
        exerciseList = workoutPlan.workoutWeekPlan[today]?.exercises;
        isWorkoutDone = workoutPlan.workoutWeekPlan[today]?.isWorkoutDone;
        lastWorkoutDate = workoutPlan.workoutWeekPlan[today]?.lastWorkoutDate;

        if (todayDate.isAfter(lastWorkoutDate!)) {
          debugPrint("Today date $todayDate and last workout date $lastWorkoutDate");
          workoutPlan.workoutWeekPlan[today]?.lastWorkoutDate = todayDate;
          workoutPlan.workoutWeekPlan[today]?.isWorkoutDone = false;
          for (Exercise exercise in exerciseList!) {
            exercise.isExerciseDone = false;
            for (ExerciseSet exerciseSet in exercise.exerciseSets) {
              exerciseSet.isSetDone = false;
            }
          }

          BaseClass.box.put(workoutPlanId, workoutPlan);
        }
      } else {
        nameOfWorkoutDay = "Rest Day";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    BaseClass.init(context);

    loadData();

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),

      /*App bar for displaying today's day*/
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: BaseClass.screenHeight * 0.04,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF005EAA),
        title: Text(
          today,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      /*1st child of this column body is the custom navbar*/
      /*2nd child is the exercise list*/
      body: Column(
        children: [
          /*Custom nav bar*/
          Container(
            height: BaseClass.topBarHeight,
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
                  nameOfWorkoutDay!,
                  style: const TextStyle(
                      color: Color(0xFF262626),
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          /*Exercise list / Rest of the page*/
          Expanded(
              child: workoutPlan.workoutWeekPlan.keys.contains(today)
                  ? (exerciseList != null && exerciseList!.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.only(top: 5),
                          itemCount: exerciseList!.length,
                          itemBuilder: (context, i) {
                            Exercise? exercise = exerciseList?[i];
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20),
                              /*Body containing lists of exercise*/
                              child: exerciseContainer(exercise!, context, i),
                            );
                          })
                      : const Center(child: Text("No exercise detected.")))
                  : const Center(child: Text("It's rest day brother, take a good rest!")))
        ],
      ),
    );
  }

  Container exerciseContainer(Exercise exercise, BuildContext context, int exerciseNum) {
    final double exerciseWidth = BaseClass.screenWidth * 0.9;

    return Container(
      width: exerciseWidth,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: const Color(0xFFE0E0E0), style: BorderStyle.solid),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 30,
            decoration: const BoxDecoration(
                color: Color(0xFF005EAA),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Center(
              child: Text(
                "Exercise ${exerciseNum + 1} IsDone ${exercise.isExerciseDone}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15, top: 10, right: 15, bottom: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.exerciseName,
                        style: const TextStyle(
                            color: Color(0xFF313131),
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "${exercise.exerciseSets.length.toString()} sets of ${exercise.exerciseSets.map((set) => set.setTargetReps).join(",")}",
                        style: const TextStyle(
                            color: Color(0xFF696969),
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.14,
                        height: MediaQuery.of(context).size.height * 0.045,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF005EAA),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.all(4)),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ExercisePage(workoutPlanId: widget.workoutPlanId, exerciseNum: exerciseNum)),
                              );
                              loadData();
                            },
                            child: const Text(
                              "Start",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            )),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
