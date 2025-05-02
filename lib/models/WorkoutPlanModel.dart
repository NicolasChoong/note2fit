import 'package:hive/hive.dart';
import 'WorkoutModel.dart';

part 'WorkoutPlanModel.g.dart';

@HiveType(typeId: 3)
class WorkoutPlan {
  @HiveField(0)
  int workoutPlanId;

  @HiveField(1)
  String workoutPlanName;

  @HiveField(2)
  Map<String, Workout> workoutWeekPlan;

  WorkoutPlan(this.workoutPlanId, this.workoutPlanName, this.workoutWeekPlan);
}