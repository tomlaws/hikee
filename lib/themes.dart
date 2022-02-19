import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color themeColor = Color(0xFF1ec28c);

class Themes {
  static final light = ThemeData.light().copyWith(
      colorScheme: ColorScheme.light(primary: themeColor, secondary: Colors.grey
          // secondary: Color.fromRGBO(241, 130, 69, 1)
          ),
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
          unselectedItemColor: Color(0xffc1cac9),
          showSelectedLabels: false),
      splashColor: Colors.transparent,
      highlightColor: Color(0x0F000000),
      iconTheme: IconThemeData(color: Color(0xFF454157)),
      textTheme: ThemeData(fontFamily: 'Gilroy')
          .textTheme
          .apply(bodyColor: Color(0xFF454157))
      // textTheme: GoogleFonts.nunitoTextTheme(
      //   ThemeData.light().textTheme.apply(bodyColor: Color(0xFF3a3a50)),
      // ),
      );
  static final dark = ThemeData.dark().copyWith(
    backgroundColor: Colors.black,
  );
  static final shadow = BoxShadow(
      blurRadius: 24,
      spreadRadius: -8,
      color: Colors.black.withOpacity(.09),
      offset: Offset(0, 14));
  static final lightShadow = BoxShadow(
      blurRadius: 18,
      spreadRadius: -5,
      color: Colors.black.withOpacity(.06),
      offset: Offset(0, 6));
  static final bottomBarShadow = BoxShadow(
      blurRadius: 16,
      spreadRadius: -8,
      color: Colors.black.withOpacity(.09),
      offset: Offset(0, -6));
  static BoxShadow buttonShadow(Color? color) {
    return BoxShadow(
        blurRadius: 16,
        spreadRadius: -8,
        color: color ?? themeColor,
        offset: Offset(0, 6));
  }

  static final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
}
