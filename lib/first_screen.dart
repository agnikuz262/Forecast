import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forecast/add_city_dialog.dart';
import 'package:forecast/default_forecast_widget.dart';
import 'package:forecast/forecast_list_screen.dart';
import 'package:forecast/info_screen.dart';
import 'bloc/forecast_bloc.dart';
import 'bloc/forecast_event.dart';
import 'bloc/forecast_state.dart';
import 'no_connection_screen.dart';
import 'package:forecast/forecast_card/forecast_card_list.dart' as list;

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
    return Scaffold(
      body: BlocConsumer<ForecastBloc, ForecastState>(
        builder: (context, state) {
          if (state is ForecastInitial) {
            return Center();
          }
          if (state is ForecastLoading) {
            return Center(
                child: CupertinoActivityIndicator(
              animating: true,
              radius: 20.0,
            ));
          }
          if (state is ForecastLoaded) {
            isConnection = true;
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
            state = ForecastInitial();
            return _buildView(context);
          }
          if (state is ForecastAlreadySaved) {
            isConnection = true;
            state = ForecastInitial();
            return _buildView(context);
          }
          if (state is ForecastFailure) {
            isConnection = false;
            state = ForecastInitial();
            return NoConnectionScreen();
          }
          if (state is ForecastDeleted) {
            state = ForecastInitial();
            return _buildView(context);
          }
          if (state is ForecastNoGps) {
            isConnection = true;
            state = ForecastInitial();
            return _buildView(context);
          }
          if (state is LocationPermissionDenied) {
            isConnection = true;
            state = ForecastInitial();
            return _buildView(context);
          }
          if (state is LocationPermissionRestricted) {
            isConnection = true;
            state = ForecastInitial();
            return _buildView(context);
          }
          if (state is ForecastNotFound) {
            state = ForecastInitial();
            return _buildView(context);
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
          if (state is ForecastInitial) {
            Center();
          }
          if (state is ForecastLoading) {
            Center(
                child: CupertinoActivityIndicator(
              animating: true,
              radius: 20.0,
            ));
          }
          if (state is ForecastLoaded) {
            setState(() {
              isConnection = true;
            });
            state = ForecastInitial();
            Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: CupertinoColors.activeBlue,
                content: Text(
                    "Pomyślnie dodano prognozę. By ją zobaczyć, naciśnij przycisk \"Wszystkie prognozy\".")));
          }
          if (state is ForecastAlreadySaved) {
            setState(() {});
            state = ForecastInitial();
            Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: CupertinoColors.activeBlue,
                content: Text(
                    "Prognoza dla tego miejsca już istnieje na Twojej liście.")));
          }
          if (state is ForecastNoGps) {
            print("no gps");
            state = ForecastInitial();
            Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: CupertinoColors.activeBlue,
                content: Text(
                    "Nie można pobrać lokalizacji. Sprawdź, czy GPS jest włączony.")));
          }
          if (state is ForecastFailure) {
            setState(() {
              isConnection = false;
            });
            Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: CupertinoColors.activeBlue,
                content: Text(
                    "Nie można załadować prognozy. Sprawdź połączenie z Internetem.")));
            state = ForecastInitial();
          }
          if (state is ForecastNotFound) {
            print("not found");
            state = ForecastInitial();
            Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: CupertinoColors.activeBlue,
                content: Text("Nie znaleziono podanego miasta.")));
          }
          if (state is LocationPermissionDenied) {
            state = ForecastInitial();
            Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: CupertinoColors.activeBlue,
                content: Text(
                    "Odmówiono dostępu do lokalizacji. Możesz to zmienić w ustawieniach urządzenia.")));
          }
          if (state is LocationPermissionRestricted) {
            state = ForecastInitial();
            Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: CupertinoColors.activeBlue,
                content: Text(
                    "Obowiązują restrykcje. Możesz to zmienić w ustawieniach urządzenia.")));
          }
        },
      ),
    );
  }

  Widget _buildView(BuildContext context) {
    return SafeArea(
      // bottom: true,
      child: CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
          child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Spacer(flex: 1),
            (list.defaultForecast != null)
                ? DefaultForecastWidget()
                : Container(),
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
                ],
              ),
            ),
            Spacer(flex: 1),
          ],
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

  void _openInfoScreen() {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => InfoScreen()));
  }
}
