import 'dart:ui';
import 'package:flutter/material.dart';

class CustomStyles {
  static Color accentColor = Color(0xFFed4079);
  static Color primaryColor = Color(0xFF01579b);
  static Color lightPrimaryColor = Color(0xFF4f83cc);
  static var circularProgressColor =
      AlwaysStoppedAnimation<Color>(Colors.white);
  static Color appGray = Colors.grey[850];

  static TextStyle cityStyle = TextStyle(
      color: Colors.grey[800],
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.normal,
      fontFamily: 'Open Sans',
      fontSize: 24);

  static TextStyle dateStyle = TextStyle(
      color: Colors.grey[800],
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.normal,
      fontFamily: 'Open Sans',
      fontSize: 18);

  static TextStyle pressureStyle = TextStyle(
      color: Colors.grey[800],
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.normal,
      fontFamily: 'Open Sans',
      fontSize: 24);

  static TextStyle tempStyle = TextStyle(
      color: Colors.grey[800],
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.normal,
      fontFamily: 'Open Sans',
      fontSize: 60);

  static TextStyle tempWidgetStyle = TextStyle(
      color: Colors.grey[800],
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.normal,
      fontFamily: 'Open Sans',
      fontSize: 30);

  static TextStyle tempMinMax = TextStyle(
      color: Colors.grey[800],
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.normal,
      fontFamily: 'Open Sans',
      fontSize: 24);

  static TextStyle tempLabel = TextStyle(
      color: Colors.grey[800],
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.normal,
      fontFamily: 'Open Sans',
      fontSize: 24);

  static TextStyle sunStyle = TextStyle(
      color: Colors.grey[800],
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.normal,
      fontFamily: 'Open Sans',
      fontSize: 22);

  static TextStyle descriptionStyle = TextStyle(
      color: Colors.grey[800],
      fontWeight: FontWeight.w200,
      fontStyle: FontStyle.normal,
      fontFamily: 'Open Sans',
      fontSize: 40);

  static Map<int, Color> color = {
    50: Color.fromRGBO(1, 87, 155, .1),
    100: Color.fromRGBO(1, 87, 155, .2),
    200: Color.fromRGBO(1, 87, 155, .3),
    300: Color.fromRGBO(1, 87, 155, .4),
    400: Color.fromRGBO(1, 87, 155, .5),
    500: Color.fromRGBO(1, 87, 155, .6),
    600: Color.fromRGBO(1, 87, 155, .7),
    700: Color.fromRGBO(1, 87, 155, .8),
    800: Color.fromRGBO(1, 87, 155, .9),
    900: Color.fromRGBO(1, 87, 155, 1),
  };
}
