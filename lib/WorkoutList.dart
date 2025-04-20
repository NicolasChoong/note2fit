import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:note2fit/base.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:note2fit/ExerciseList.dart';
import 'package:note2fit/basicClasses/WorkoutModel.dart';

import 'basicClasses/ExerciseModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
  Widget build(BuildContext context) {
    final double workoutHeight = BaseClass.screenHeight * 0.18;
    final double workoutWidth = BaseClass.screenWidth * 0.9;

    /*This will be created from a screen, and saved into a database*/
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

    final chestDay = WorkoutForTheDay("Chest Day", sampleExerciseList1);
    final legDay = WorkoutForTheDay("Leg Day", sampleExerciseList2);

    var workoutForEachDayOfTheWeek = {
      "Sunday": chestDay,
      "Tuesday": legDay
    };

    final workoutList = [
      Workout("Main Workout", workoutForEachDayOfTheWeek),
      Workout("Backup Workout", workoutForEachDayOfTheWeek)
    ];
    /*-------------------------------------------------------------*/

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),


      /*Main App Bar*/
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(BaseClass.topBarHeight),
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
            toolbarHeight: BaseClass.topBarHeight,
            title: const Text(
              "Workout List",
              style: TextStyle(
                color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              ),
            ),
            backgroundColor: const Color(0xFF005EAA),
          ),
        ),
      ),


      /*Body containing lists of workouts*/
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 5),
          itemCount: workoutList.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.only(top: 15, left: 20, right: 20),

              /*Workout container*/
              child: Container(
                height: workoutHeight,
                width: workoutWidth,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      style: BorderStyle.solid
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 5, right: 10),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workoutList[i].workoutName,
                                  style: const TextStyle(
                                      color: Color(0xFF313131),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(BaseClass.dayString.length, (j) {
                                    bool selectedDays = workoutList[i].workoutForTheDay.keys.contains(BaseClass.dayString[j]);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: Text(
                                        BaseClass.dayString[j][0],
                                        style: TextStyle(
                                            color: selectedDays
                                                ? const Color(0xFF005EAA)
                                                : const Color(0xFF696969),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset('images/more_options.svg'),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WorkoutPage(workout: workoutList[i])),
                              );
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return const Color(0x80005EAA);
                                    }
                                    return const Color(
                                        0xFF005EAA); // Use the component's default.
                                  },
                                ),
                                shape: const WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))))),
                            child: const Text(
                              "Start Workout",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
