import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forecast/app_state_notifier.dart';
import 'package:forecast/bloc/forecast_bloc.dart';
import 'package:forecast/bloc/forecast_event.dart';
import 'package:forecast/bloc/forecast_state.dart';
import 'package:forecast/ui/forecast_card/forecast_card_list.dart' as list;
import 'package:forecast/ui/forecast_card/forecast_card.dart';
import 'package:forecast/ui/no_connection_screen.dart';
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
          return Center(
            child: CupertinoActivityIndicator(
              animating: true,
              radius: 15,
            ),
          );
        }
        if(state is ForecastInitial) {
          return _buildView();
        }
        if (state is ForecastLoaded) {
          state = ForecastInitial();
          return _buildView();
        }
        if (state is ForecastFailure) {
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

  Widget _emptyListWidget() {
    return Center(
      child: Text("Brak dodanych prognoz"),
    );
  }

  Widget _buildView() {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          border: Border(bottom: BorderSide(style: BorderStyle.none)),
          middle: Text(
            "Twoje prognozy",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          trailing: IconButton(
            icon: Icon(
              CupertinoIcons.refresh,
              color: Color.fromRGBO(50, 130, 209, 1.0),
            ),
            onPressed: () {
              _bloc.add(RefreshForecast());
            },
          ),
        ),
        child: (list.forecastList.isEmpty)
            ? _emptyListWidget()
            : Consumer<AppStateNotifier>(builder: (context, appState, child) {
                list.forecastList = list.forecastList
                    .map((forecastCard) => ForecastCard(
                          forecast: forecastCard.forecast,
                          listIndex: forecastCard.listIndex,
                          textColor:
                              appState.isDarkModeOn ? Colors.white : null,
                        ))
                    .toList();
                return SafeArea(child: PageView(children: list.forecastList));
              }));
  }
}
