import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forecast/app_state_notifier.dart';
import 'package:forecast/bloc/forecast_bloc.dart';
import 'package:forecast/bloc/forecast_state.dart';
import 'package:forecast/forecast_card/forecast_card.dart';
import 'package:forecast/forecast_card/forecast_card_list.dart' as list;
import 'package:forecast/no_connection_screen.dart';
import 'package:provider/provider.dart';

class ForecastListScreen extends StatefulWidget {
  @override
  _ForecastListScreenState createState() => _ForecastListScreenState();
}

class _ForecastListScreenState extends State<ForecastListScreen> {
  ForecastBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<ForecastBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<ForecastBloc, ForecastState>(
      builder: (context, state) {
        if (state is ForecastLoading) {
          state = ForecastInitial();
          return CupertinoActivityIndicator(
            animating: true,
            radius: 15.0,
          );
        }
        if (state is ForecastLoaded) {
          print("loaded");
          state = ForecastInitial();
          return _buildView();
        }
        if (state is ForecastFailure) {
          print("failure");
          state = ForecastInitial();
          return NoConnectionScreen();
        } else {
          return Container(
            child: Text(
              "Coś poszło nie tak",
              style: TextStyle(color: Colors.red),
            ),
          );
        }
      },
      listener: (context, state) {},
      bloc: _bloc,
    ));
  }

  Widget _buildView() {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          border: Border(bottom: BorderSide(style: BorderStyle.none)),
          middle: Text(
            "Twoje prognozy",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          trailing: Icon(
            CupertinoIcons.refresh,
            color: CupertinoColors.activeBlue,
          ),
        ),
        child: Consumer<AppStateNotifier>(builder: (context, appState, child) {
          list.forecastList = list.forecastList
              .map((forecastCard) => ForecastCard(
                    city: forecastCard.city,
                    index: forecastCard.index,
                    tempMin: forecastCard.tempMin,
                    tempMax: forecastCard.tempMax,
                    temp: forecastCard.temp,
                    sunset: forecastCard.sunset,
                    sunrise: forecastCard.sunrise,
                    pressure: forecastCard.pressure,
                    iconDesc: forecastCard.iconDesc,
                    description: forecastCard.description,
                    date: forecastCard.date,
                    textColor:
                        appState.isDarkModeOn ? Colors.white : null,
                  ))
              .toList();
          return SafeArea(
              child: PageView(children: list.forecastList
                  //.map((forecastCard) {
//            forecastCard.textColor =
//                appState.isDarkModeOn ?
//                Colors.white
//                    : Colors.grey;
                  //      }).toList()
                  ));
        }));
  }
}
