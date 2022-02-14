import 'package:flutter/material.dart';

//Editing section to properly place the fonts to be used in the application
class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double horizontalBlockSize;
  static double verticalBlockSize;
  static double textScaleFactor;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    textScaleFactor = _mediaQueryData.textScaleFactor;
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    horizontalBlockSize = screenWidth / 100;
    verticalBlockSize = screenHeight / 100;
  }
}
