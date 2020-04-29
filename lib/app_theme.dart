import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final CupertinoThemeData lightTheme = CupertinoThemeData(
    primaryColor: CupertinoColors.activeBlue,
    scaffoldBackgroundColor: Colors.white,
    barBackgroundColor: Colors.white,
    textTheme: CupertinoTextThemeData(
      primaryColor: Colors.red,
      textStyle: TextStyle(fontFamily: 'San Francisco', fontSize: 17),
    ),
  );

  static final CupertinoThemeData darkTheme = CupertinoThemeData(
    primaryColor: CupertinoColors.activeBlue,
    scaffoldBackgroundColor: Colors.black38,
    barBackgroundColor: Colors.black38,
    textTheme: CupertinoTextThemeData(
      primaryColor: Colors.red,
      textStyle: TextStyle(fontFamily: 'San Francisco', fontSize: 17),
    ),
  );
}
