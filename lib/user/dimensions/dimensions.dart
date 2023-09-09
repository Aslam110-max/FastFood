import 'package:flutter/cupertino.dart';


class Dimensions {
  static double? screenHeight = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;
  static double? screenWidth = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  static double topPageHeight = screenHeight! / 5.00;
  static double topBarExpandHeight = screenHeight! / 3.30;
  static double topContainerHeight = screenHeight! / 3.1;
  static double topDesignHeight = screenHeight! / 4.84;
  static double topTopPageSpace = screenHeight! / 15.11;
  static double topLogoHeight = screenHeight! / 18.93;
  static double topLogoWidth = screenWidth! / 5.6;
  static double space15 = screenWidth!/26.13;
  static double height10 =screenHeight!/60;
  static double height90 =screenHeight!/8.5;
  static double height120 = screenHeight!/6.5;
  static double height210 = screenHeight!/4.0;
  static double height70 =screenHeight!/9.22;
  static double width120 = screenWidth! / 5.0;
}
