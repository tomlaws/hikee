import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color themeColor = Color(0xFF5DB075);

class Themes {
  static final light = ThemeData.light().copyWith(
    primaryColor: themeColor,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    primaryTextTheme:
        TextTheme(headline6: TextStyle(color: themeColor, fontSize: 18)),
    //appBarTheme: AppBarTheme(textTheme: Theme.of(context).textTheme.apply(displayColor:Colors.red)),
    sliderTheme: SliderThemeData(
        thumbColor: themeColor,
        activeTrackColor: themeColor,
        inactiveTrackColor: themeColor.withOpacity(.25),
        overlayColor: themeColor.withOpacity(.25),
        valueIndicatorColor: Color(0xFFF5F5F5),
        valueIndicatorTextStyle: TextStyle(color: Colors.black87),
        activeTickMarkColor: Colors.white38),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: themeColor,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        selectedLabelStyle: TextStyle(fontSize: 0),
        showSelectedLabels: false),
    splashColor: Colors.transparent,
    highlightColor: Color(0x0F000000),
    textTheme: GoogleFonts.latoTextTheme(
      ThemeData.light().textTheme.apply(bodyColor: Color(0xFF666666)),
    ),
  );
  static final dark = ThemeData.dark().copyWith(
    backgroundColor: Colors.black,
    buttonColor: Colors.red,
  );
}
