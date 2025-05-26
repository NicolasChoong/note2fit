import 'package:hive/hive.dart';
import 'WorkoutModel.dart';

part 'WorkoutPlanModel.g.dart';

@HiveType(typeId: 0)
class WorkoutPlan {
  @HiveField(0)
  int workoutPlanId;

  @HiveField(1)
  String workoutPlanName;

  @HiveField(2)
  DateTime workoutPlanStartDate;

  @HiveField(3)
  bool isDefaultWorkoutPlan;

  @HiveField(4)
  List<Workout?> workoutPlanDays;

  WorkoutPlan(this.workoutPlanId, this.workoutPlanName, this.workoutPlanStartDate, this.isDefaultWorkoutPlan, this.workoutPlanDays);
}