import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forecast/app_state_notifier.dart';
import 'package:forecast/bloc/forecast_bloc.dart';
import 'package:forecast/bloc/forecast_event.dart';
import 'package:forecast/bloc/forecast_state.dart';
import 'package:forecast/ui/forecast_list/forecast_card/forecast_card_list.dart'
    as list;
import 'package:forecast/ui/forecast_list/forecast_card/forecast_card.dart';
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
            return Center(
              child: CupertinoActivityIndicator(
                animating: true,
                radius: 15,
              ),
            );
          } else if (state is ForecastFailure) {
            state = ForecastInitial();
            return NoConnectionScreen();
          } else {
            return _buildView();
          }
        },
        listener: (context, state) {
          if (state is ForecastDeleted) {
            Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Color.fromRGBO(50, 130, 209, 1.0),
                content: Text("Usunięto prognozę")));
            _bloc.add(SetInitialState());
          }
        },
        bloc: _bloc,
      ),
    );
  }

  Widget _emptyListWidget() {
    return Consumer<AppStateNotifier>(builder: (context, appState, child) {
      return Center(
        child: Text(
          "Brak dodanych prognoz",
          style: TextStyle(
              color: appState.isDarkModeOn ? Colors.white : Colors.black),
        ),
      );
    });
  }

  Widget _buildView() {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        border: Border(bottom: BorderSide(style: BorderStyle.none)),
        middle: Text(
          "Twoje prognozy",
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.only(left: 15.0),
          child: Icon(
            CupertinoIcons.refresh,
            color: Color.fromRGBO(50, 130, 209, 1.0),
            size: 30.0,
          ),
          onPressed: () {
            _bloc.add(RefreshForecast());
            Navigator.of(context).pop();
          },
        ),
      ),
      child: (list.forecastList.isEmpty)
          ? _emptyListWidget()
          : Consumer<AppStateNotifier>(builder: (context, appState, child) {
              list.forecastList = list.forecastList
                  .map((forecastCard) => ForecastCard(
                        forecast: forecastCard.forecast,
                        listId: forecastCard.listId,
                        textColor: appState.isDarkModeOn ? Colors.white : null,
                      ))
                  .toList();
              return SafeArea(
                  child:
                      PageView(children: list.forecastList.reversed.toList()));
            }),
    );
  }
}
