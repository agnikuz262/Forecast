import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forecast/app_state_notifier.dart';
import 'package:forecast/bloc/forecast_bloc.dart';
import 'package:forecast/ui/home/home_screen.dart';
import 'package:forecast/ui/settings/settings_screen.dart';
import 'dart:core';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider<AppStateNotifier>(
    create: (context) => AppStateNotifier(),
    child: BlocProvider<ForecastBloc>(
      create: (BuildContext context) => ForecastBloc(),
      child: MyApp(),
    )));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appState, child) {
        return CupertinoApp(
          debugShowCheckedModeBanner: false,
          title: 'Pogoda',
          theme: appState.isDarkModeOn
              ? CupertinoThemeData(
                  barBackgroundColor: Color.fromRGBO(25, 25, 25, 1),
                  textTheme: CupertinoTextThemeData(
                      textStyle: TextStyle(
                          fontFamily: 'San Francisco', color: Colors.white)),
                  scaffoldBackgroundColor: Color.fromRGBO(0, 0, 0, 0.9),
                  brightness: Brightness.dark,
                  primaryColor: Color.fromRGBO(50, 130, 209, 1.0),
                )
              : CupertinoThemeData(
                  scaffoldBackgroundColor: Color.fromRGBO(240, 240, 240, 1),
                  brightness: Brightness.light,
                  barBackgroundColor: Color.fromRGBO(240, 240, 240, 1),
                  textTheme: CupertinoTextThemeData(
                      textStyle: TextStyle(
                          fontFamily: 'San Francisco', color: Colors.black)),
                  primaryColor: Color.fromRGBO(50, 130, 209, 1.0)),
          home: MyHomePage(title: 'Pogoda'),
        );
      },
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
        items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              title: Text(
                "Główna",
              )),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings), title: Text("Ustawienia")),
        ],
      ),
      tabBuilder: (context, i) {
        switch (i) {
          case 0:
            return HomeScreen();
            break;
          case 1:
            return SettingsScreen();
            break;
          default:
            return HomeScreen();
            break;
        }
      },
      resizeToAvoidBottomInset: false,
    );
  }
}
