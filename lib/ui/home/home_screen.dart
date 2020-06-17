import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forecast/app_state_notifier.dart';
import 'package:forecast/bloc/forecast_bloc.dart';
import 'package:forecast/bloc/forecast_event.dart';
import 'package:forecast/bloc/forecast_state.dart';
import 'package:forecast/ui/forecast_list/forecast_list_screen.dart';
import 'package:forecast/ui/home/add_city_dialog.dart';
import 'package:forecast/ui/home/default_forecast_widget.dart';
import 'package:provider/provider.dart';
import '../no_connection_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ForecastBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ForecastBloc>(context);
    bloc.add(RefreshForecast());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(builder: (context, appState, child) {
      return Scaffold(
        backgroundColor: appState.isDarkModeOn ? Colors.black : Colors.white,
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<ForecastBloc, ForecastState>(
          builder: (context, state) {
            if (state is ForecastLoading) {
              return Center(
                  child: CupertinoActivityIndicator(
                radius: 15,
                animating: true,
              ));
            } else {
              return _buildView(context);
            }
          },
          listener: (BuildContext context, ForecastState state) {
            if (state is ForecastLoaded) {
              setState(() {});
              bloc.add(SetInitialState());
              if (state.navigateToList)
                Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => ForecastListScreen()));
            }
            if (state is ForecastAlreadySaved) {
              setState(() {});
              bloc.add(SetInitialState());
              Scaffold.of(context).showSnackBar(SnackBar(
                  backgroundColor: Color.fromRGBO(50, 130, 209, 1.0),
                  content: Text(
                      "Prognoza dla tego miejsca już znajduje się na Twojej liście.")));
            }
            if (state is ForecastNoGps) {
              bloc.add(SetInitialState());
              Scaffold.of(context).showSnackBar(SnackBar(
                  backgroundColor: Color.fromRGBO(50, 130, 209, 1.0),
                  content: Text(
                      "Nie można pobrać lokalizacji. Sprawdź, czy GPS i internet jest włączony.")));
            }
            if (state is ForecastFailure) {
              setState(() {});
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => NoConnectionScreen()));
              bloc.add(SetInitialState());
            }
            if (state is ForecastNotFound) {
              bloc.add(SetInitialState());
              Scaffold.of(context).showSnackBar(SnackBar(
                  backgroundColor: Color.fromRGBO(50, 130, 209, 1.0),
                  content: Text("Nie znaleziono podanego miasta.")));
            }
            if (state is LocationPermissionDenied) {
              bloc.add(SetInitialState());
              Scaffold.of(context).showSnackBar(SnackBar(
                  backgroundColor: Color.fromRGBO(50, 130, 209, 1.0),
                  content: Text(
                      "Odmówiono dostępu do lokalizacji. Możesz to zmienić w ustawieniach urządzenia.")));
            }
            if (state is LocationPermissionRestricted) {
              bloc.add(SetInitialState());
              Scaffold.of(context).showSnackBar(SnackBar(
                  backgroundColor: Color.fromRGBO(50, 130, 209, 1.0),
                  content: Text(
                      "Obowiązują restrykcje. Możesz to zmienić w ustawieniach urządzenia.")));
            }
            if (state is DefaultForecastChangeSuccess) {
              setState(() {});
              bloc.add(SetInitialState());
            }
            if (state is DefaultForecastChangeFailure) {
              setState(() {});
              bloc.add(SetInitialState());
            }
          },
        ),
      );
    });
  }

  Widget _buildView(BuildContext context) {
    return CupertinoPageScaffold(
      child: Consumer<AppStateNotifier>(builder: (context, appState, child) {
        return SafeArea(
            child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Spacer(flex: 1),
              DefaultForecastWidget(
                textColor: appState.isDarkModeOn ? Colors.white : null,
                cardColor: appState.isDarkModeOn
                    ? Color.fromRGBO(30, 30, 30, 1)
                    : null,
              ),
              Spacer(
                flex: 3,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 5 / 6,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 5.0,
                                  color: appState.isDarkModeOn
                                      ? Colors.black12
                                      : Colors.grey)
                            ]),
                        child: CupertinoButton(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Color.fromRGBO(50, 130, 209, 1.0),
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 5.0,
                                  color: appState.isDarkModeOn
                                      ? Colors.black12
                                      : Colors.grey)
                            ]),
                        child: CupertinoButton(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Color.fromRGBO(50, 130, 209, 1.0),
                          onPressed: _openForecastList,
                          child: Text(
                            "Wszystkie prognozy",
                            style: TextStyle(color: CupertinoColors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(flex: 1),
            ],
          ),
        ));
      }),
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
                  onPressed: () => _openAddLocalization(context),
                ),
              ],
            ));
  }

  void _openForecastList() {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => ForecastListScreen()));
  }

  void _openAddCity() {
    Navigator.of(context).pop();
    showCupertinoDialog(
        context: context, builder: (context) => AddCityDialog());
  }

  void _openAddLocalization(BuildContext context) async {
    Navigator.of(context).pop();
    bloc.add(ForecastAddLocalizationEvent());
  }
}
