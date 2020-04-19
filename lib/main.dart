import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forecast/first_screen.dart';
import 'package:forecast/helpers/alert_dialogs.dart';
import 'package:forecast/bloc/forecast_bloc.dart';
import 'package:forecast/bloc/forecast_event.dart';
import 'package:forecast/bloc/forecast_state.dart';
import 'package:forecast/settings_screen.dart';
import 'package:forecast/utils/custom_styles.dart';
import 'package:forecast/no_connection_screen.dart';
import 'dart:core';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forecast/forecast_card/forecast_card_list.dart' as globals;

import 'forecast_card/forecast_card.dart';

void main() => runApp(BlocProvider<ForecastBloc>(
      create: (BuildContext context) => ForecastBloc(),
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: CupertinoThemeData(
          primaryColor: CupertinoColors.activeBlue,
          primaryContrastingColor: CupertinoColors.activeBlue,
          scaffoldBackgroundColor: CupertinoColors.white,
          textTheme: CupertinoTextThemeData(
              primaryColor: CupertinoColors.black,
              textStyle: TextStyle(fontFamily: 'San Francisco', fontSize: 17))),
      home: MyHomePage(title: 'Pogoda'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: CupertinoColors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home), title: Text("Główna")),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings), title: Text("Ustawienia")),
        ],
      ),
      tabBuilder: (context, i) {
        switch (i) {
          case 0:
            return FirstScreen();
            break;
          case 1:
            return SettingsScreen();
            break;
          default:
            return FirstScreen();
            break;
        }
      },
      resizeToAvoidBottomInset: false,
      backgroundColor: CupertinoColors.white,
    );
  }
}
