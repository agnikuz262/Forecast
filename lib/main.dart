import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forecast/helpers/alert_dialogs.dart';
import 'package:forecast/bloc/forecast_bloc.dart';
import 'package:forecast/bloc/forecast_event.dart';
import 'package:forecast/bloc/forecast_state.dart';
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
          textTheme:
              CupertinoTextThemeData(primaryColor: CupertinoColors.activeBlue)),
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
  Completer<void> _refreshCompleter;
  ForecastBloc bloc;
  String city = "Gliwice";
  bool isConnection = true;

  void onTransition(Transition<ForecastEvent, ForecastState> transition) {
    print(transition);
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ForecastBloc>(context)
      ..add(ForecastAddCityEvent(city: city));
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: CupertinoColors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.create), title: Text("Prognozy")),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings), title: Text("Ustawienia")),
        ],
      ),
      tabBuilder: (context, i) {
        switch (i) {
          case 0:
            return _buildBlocConsumer();
            break;
          case 1:
            return CupertinoPageScaffold(
                child: Center(
              child: Text("Ustawienia"),
            ));
            break;
          default:
            return _buildBlocConsumer();
            break;
        }
      },
      resizeToAvoidBottomInset: false,
      // navigationBar: _buildAppBar(),
      backgroundColor: CupertinoColors.white,
//        floatingActionButton: isConnection
//            ? new FloatingActionButton(
//                backgroundColor: CustomStyles.accentColor,
//                elevation: 7.0,
//                child: new Icon(Icons.add),
//                onPressed: () {
//                  AlertDialogs().displayAddDialog(context, bloc);
//                },
//              )
//            : Container(),
    );
  }

//  AppBar _buildAppBar() {
//    return BottomNa(
//      elevation: 4.0,
//      title: Row(
//        children: <Widget>[
//          Stack(
//            alignment: Alignment.center,
//            children: <Widget>[
//              Container(
//                  decoration: new BoxDecoration(
//                      color: Colors.white70,
//                      borderRadius: BorderRadius.circular(50.0)),
//                  width: 37.0,
//                  height: 37.0),
//              SvgPicture.asset('assets/icons/umbrella1.svg',
//                  height: 30, width: 30)
//            ],
//          ),
//          SizedBox(width: 10.0),
//          Text(widget.title),
//          Spacer(),
//          Container(
//            width: 45.0,
//            child: FlatButton(
//              onPressed: () {
//                bloc.add(RefreshForecast());
//              },
//              child: Icon(
//                CupertinoIcons.refresh
//                color: Colors.white,
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }

  Container _buildBlocConsumer() {
    return Container(
        child: BlocConsumer<ForecastBloc, ForecastState>(
      builder: (context, state) {
        if (state is ForecastInitial) {
          return Center();
        }
        if (state is ForecastLoading) {
          return Center(
              child: CupertinoActivityIndicator(
            animating: true,
            radius: 15.0,
          ));
        }
        if (state is ForecastLoaded) {
          isConnection = true;
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
          state = ForecastInitial();
          return _buildView();
        }
        if (state is ForecastFailure) {
          isConnection = false;
          state = ForecastInitial();
          return NoConnectionScreen();
        }
        if (state is ForecastDeleted) {
          state = ForecastInitial();
          return _buildView();
        }
        if (state is ForecastNotFound) {
          state = ForecastInitial();
          return _buildView();
        } else
          return Center(
            child: Text(
              "Coś poszło nie tak",
              style: TextStyle(color: Colors.red),
            ),
          );
      },
      listener: (BuildContext context, ForecastState state) {
        if (state is ForecastDeleted) {
          setState(() {});
          state = ForecastInitial();
        }
        if (state is ForecastLoaded) {
          setState(() {
            isConnection = true;
          });
          state = ForecastInitial();
        }
        if (state is ForecastFailure) {
          setState(() {
            isConnection = false;
          });
          Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: CustomStyles.accentColor,
              content: Text(
                  "Nie można załadować prognozy. Sprawdź połączenie z Internetem.")));
          state = ForecastInitial();
        }
//        if (state is ForecastNotFound) {
//          Scaffold.of(context).showSnackBar(SnackBar(
//              backgroundColor: CustomStyles.accentColor,
//              content: Text("Nie znaleziono podanego miasta.")));
//          state = ForecastInitial();
//        }
      },
    ));
  }

  Widget _buildView() {
    return SafeArea(
      bottom: true,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(),
//          Padding(
//            padding: const EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 50.0),
//            child: Center(
//                child: Text(
//              "Brak prognoz, dodaj nową za pomocą przycisku w prawym dolnym rogu",
//              textAlign: TextAlign.center,
//              style: TextStyle(color: CupertinoColors.activeBlue),
//            )),
//          ),
          ForecastCard(
            city: "Gliwice",
            date: DateTime.now(),
            description: "Czyste niebo",
            iconDesc: "Clouds",
            pressure: 1025,
            sunrise: 15000,
            sunset: 23434,
            temp: 13.0,
            tempMax: 15.0,
            tempMin: 12.0,
          ),
        ],
      ),
    );
  }
}
