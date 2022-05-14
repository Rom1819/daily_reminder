import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color tealClr = Colors.teal;
const Color white = Colors.white;
const Color black = Colors.black;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFFff4667);
const Color primaryClr = bluishClr;

class Themes {
  static final light =
      ThemeData(backgroundColor: white, brightness: Brightness.light);

  static final dark =
      ThemeData(backgroundColor: darkGreyClr, brightness: Brightness.dark);
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? white : black,
  ));
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
  ));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Get.isDarkMode ? white : black,
      ));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
      ));
}
