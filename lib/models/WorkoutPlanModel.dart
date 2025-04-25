import 'package:hive/hive.dart';
import 'WorkoutModel.dart';

part 'WorkoutPlanModel.g.dart';

@HiveType(typeId: 3)
class WorkoutPlan {
  @HiveField(0)
  final String workoutPlanName;

  @HiveField(1)
  final Map<String, Workout> workoutWeekPlan;

  WorkoutPlan(this.workoutPlanName, this.workoutWeekPlan);
}