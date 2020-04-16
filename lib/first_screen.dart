import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forecast/add_city_dialog.dart';
import 'package:forecast/default_forecast_widget.dart';
import 'package:forecast/forecast_list_screen.dart';
import 'package:forecast/info_screen.dart';
import 'package:forecast/utils/custom_styles.dart';
import 'bloc/forecast_bloc.dart';
import 'bloc/forecast_event.dart';
import 'bloc/forecast_state.dart';
import 'no_connection_screen.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  Completer<void> _refreshCompleter;
  ForecastBloc bloc;
  String city = "Gliwice";
  bool isConnection = true;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ForecastBloc>(context)
      ..add(ForecastAddCityEvent(city: city));
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForecastBloc, ForecastState>(
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
    );
  }

  Widget _buildView() {
    return SafeArea(
      // bottom: true,
      child: CupertinoPageScaffold(
          child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: Icon(CupertinoIcons.info),
                  onTap: _openInfoScreen,
                ),
              ),
              Spacer(flex: 1),
              DefaultForecastWidget(),
              Spacer(
                flex: 3,
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 5.0,
                        color: Colors.grey)
                  ]),
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(6.0),
                    color: CupertinoColors.activeBlue,
                    onPressed: _openAddNew,
                    child: Text("Nowa prognoza",
                        style: TextStyle(color: CupertinoColors.white)),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 5.0,
                        color: Colors.grey)
                  ]),
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(6.0),
                    color: CupertinoColors.activeBlue,
                    onPressed: _openForecastList,
                    child: Text(
                      "Wszystkie prognozy",
                      style: TextStyle(color: CupertinoColors.white),
                    ),
                  ),
                ),
              ),
              Spacer(flex: 1),
            ],
          ),
        ),
      )),
    );
  }

  void _openAddNew() {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
              title: Text("Dodaj nową prognozę"),
              message:
                  Text("Znajdź prognozę za pomocą jednej z poniższych opcji:"),
              cancelButton: CupertinoActionSheetAction(
                child: Text("Wstecz"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: Text("Miasto"),
                  onPressed: _openAddCity,
                ),
                CupertinoActionSheetAction(
                  child: Text("Lokalizacja"),
                  onPressed: _openAddLocalization,
                ),
              ],
            ));
  }

  void _openForecastList() {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => ForecastListScreen()));
  }

  void _openAddCity() {
    showCupertinoDialog(
        context: context, builder: (context) => AddCityDialog());
  }

  void _openAddLocalization() {}

  void _openInfoScreen() {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => InfoScreen()));
  }
}
