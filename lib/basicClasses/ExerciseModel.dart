class WorkoutForTheDay {
  final String workoutDayName;
  final List<Exercise> exercises;

  WorkoutForTheDay(this.workoutDayName, this.exercises);
}

class Exercise {
  final String exerciseName;
  final List<ExerciseSet> exerciseSets;

  Exercise(this.exerciseName, this.exerciseSets);
}

class ExerciseSet {
  final int setNum;
  final int setTargetReps;
  final double setCurrentWeight;
  final int setCurrentReps;
  final bool isSetDone;

  ExerciseSet(this.setNum, this.setTargetReps, this.setCurrentWeight, this.setCurrentReps, this.isSetDone);
}