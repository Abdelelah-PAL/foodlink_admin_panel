import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SizeConfig {
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  // Initialize the size configuration
  void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientation = MediaQuery.of(context).orientation;

    defaultSize = orientation == Orientation.landscape
        ? screenHeight! * 0.024
        : screenWidth! * 0.024;

    if (kIsWeb) {
      defaultSize = screenWidth! * 0.02;
    }

    if (kDebugMode) {
      print('Screen Width: $screenWidth, Screen Height: $screenHeight');
      print('Default Size: $defaultSize');
    }
  }

  static double getProportionalWidth(double inputWidth) {
    return (inputWidth / 375.0) * screenWidth!;
  }

  static double getProportionalHeight(double inputHeight) {
    return (inputHeight / 812.0) * screenHeight!;
  }

  static double getProperVerticalSpace(double value) {
    return screenHeight! / value;
  }

  static double getProperHorizontalSpace(double value) {
    return screenWidth! / value;
  }

  static Widget customSizedBox(double? width, double? height, Widget? child) {
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}
