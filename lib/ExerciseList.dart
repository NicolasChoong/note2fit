import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:note2fit/models/WorkoutPlanModel.dart';

import 'base.dart';
import 'models/ExerciseModel.dart';
import 'models/WorkoutModel.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key, required this.workoutPlan});

  final WorkoutPlan workoutPlan;

  @override
  Widget build(BuildContext context) {
    BaseClass.init(context);

    final double exerciseHeight = BaseClass.screenHeight * 0.18;
    final double exerciseWidth = BaseClass.screenWidth * 0.9;

    final String today = DateFormat.EEEE().format(DateTime.now());

    String? nameOfWorkoutDay;
    Workout? workoutForToday;
    List<Exercise>? exerciseList;

    if (workoutPlan.workoutWeekPlan.keys.contains(today)) {
      workoutForToday = workoutPlan.workoutWeekPlan[today];
      exerciseList = workoutForToday?.exercises;
      nameOfWorkoutDay = workoutForToday?.workoutDayName;
    } else {
      nameOfWorkoutDay = "Rest Day";
    }

    /*final benchPressSets = [
      ExerciseSet(1, 12, 100.0, 9, false),
      ExerciseSet(2, 12, 95.0, 7, false),
      ExerciseSet(3, 12, 90.0, 6, false)
    ];
    final barbellRowSets = [
      ExerciseSet(1, 12, 80.0, 8, false),
      ExerciseSet(2, 12, 75.0, 5, false)
    ];

    final exerciseList = [
      Exercise("Bench Press", benchPressSets),
      Exercise("Barbell Row", barbellRowSets)
    ];*/

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
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500
          ),
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
                bottom: BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 2
                )
              )
            ),
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
                        )
                    ),
                ),
                Text(
                  nameOfWorkoutDay!,
                  style: const TextStyle(
                    color: Color(0xFF262626),
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),


          /*Exercise list / Rest of the page*/
          Expanded(
              child: workoutPlan.workoutWeekPlan.keys.contains(today) ? ListView.builder(
                  padding: const EdgeInsets.only(top: 5),
                  itemCount: exerciseList?.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 15, left: 20, right: 20),

                      /*Body containing lists of exercise*/
                      child: Column(
                        children: [

                          /*Exercise container*/
                          Container(
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
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Exercise ${i + 1}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                exerciseList![i].exerciseName,
                                                style: const TextStyle(
                                                    color: Color(0xFF313131),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                              Text(
                                                "${exerciseList[i].exerciseSets.length.toString()} sets of ${exerciseList[i].exerciseSets.map((set) => set.setTargetReps).join(",")}",
                                                style: const TextStyle(
                                                    color: Color(0xFF696969),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400
                                                ),
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
                                                            borderRadius: BorderRadius.circular(12)
                                                        ),
                                                        padding: const EdgeInsets.all(4)
                                                    ),
                                                    onPressed: () {},
                                                    child: const Text(
                                                      "Start",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    )
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                          ),
                        ],
                      ),
                    );
                  }
              ) : const Center(child: Text("It's rest day brother, take a good rest!"))
          )
        ],
      ),
    );
  }
}
