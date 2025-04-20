import 'package:flutter/cupertino.dart';

class BaseClass {
  static late double screenHeight;
  static late double screenWidth;
  static late double topBarHeight;

  static void init(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    topBarHeight = screenHeight * 0.075;
  }

  static List<String> dayString = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
}