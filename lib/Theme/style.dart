import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qvid/Theme/colors.dart';

final BorderRadius radius = BorderRadius.circular(6.0);

final ThemeData appTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: backgroundColor,

  primaryColor: mainColor,
//  accentColor: mainColor,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: TextStyle(color: Colors.red),
      unselectedLabelStyle: TextStyle(color: disabledTextColor)),
    
  ///appBar theme
  appBarTheme: AppBarTheme(
      color: transparentColor,
      elevation: 0.0,
      systemOverlayStyle:
          SystemUiOverlayStyle(statusBarColor: Colors.transparent)),

  ///text theme
 textTheme: GoogleFonts.openSansTextTheme().copyWith(
    subtitle1: TextStyle(color: disabledTextColor),
    caption: TextStyle(color: disabledTextColor),
    bodyText1: TextStyle(fontSize: 16.0, color: Colors.black),
    headline6: TextStyle(fontSize: 18.0, color: Colors.black),
    button: TextStyle(fontSize: 16.0, letterSpacing: 1),
    subtitle2: TextStyle(),
    bodyText2: TextStyle(fontSize: 16.0, color: Colors.black),
  ), 
);

/// NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyText1)
/// body2        14.0  regular  0.25  (bodyText2)
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5
