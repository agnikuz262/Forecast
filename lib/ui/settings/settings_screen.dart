import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forecast/app_state_notifier.dart';
import 'package:forecast/bloc/forecast_bloc.dart';
import 'package:forecast/bloc/forecast_event.dart';
import 'package:forecast/bloc/forecast_state.dart';
import 'file:///C:/Users/akuzniecow/AndroidStudioProjects/forecast/lib/ui/settings/info_screen.dart';
import 'package:provider/provider.dart';
import 'package:forecast/ui/forecast_list/forecast_card/forecast_card_list.dart' as list;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkTheme = false;
  int selectItem = 0;
  ForecastBloc bloc;

  @override
  void initState() {
    bloc = BlocProvider.of<ForecastBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(listener: (context, state) {
        if(state is DefaultForecastChangeSuccess) {
          bloc.add(SetInitialState());
          Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: Color.fromRGBO(50, 130, 209, 1.0),
              content: Text(
                  "Ustawiono domyślną pogodę.")));
        }
        if(state is DefaultForecastChangeFailure) {
          bloc.add(SetInitialState());
          Scaffold.of(context).showSnackBar(SnackBar(
              backgroundColor: Color.fromRGBO(50, 130, 209, 1.0),
              content: Text(
                  "Nie udało się zmienić domyślnej pogody.")));
        }
      },
        bloc: bloc,
        child: CupertinoPageScaffold(child:
            Consumer<AppStateNotifier>(builder: (context, appState, child) {
          return SafeArea(
            child: Column(
              children: <Widget>[
                Container(height: 20.0),
                Divider(
                  height: 0,
                  thickness: 0.3,
                  color: appState.isDarkModeOn
                      ? Colors.transparent
                      : CupertinoColors.systemGrey,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: appState.isDarkModeOn
                      ? Color.fromRGBO(35, 35, 35, 1)
                      : Colors.white,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 8, left: 15.0, right: 2.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 8.0),
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text("Tryb ciemny",
                                  style: TextStyle(
                                      color: appState.isDarkModeOn
                                          ? Colors.white
                                          : Colors.black)),
                              CupertinoSwitch(
                                value: _isDarkTheme,
                                onChanged: (bool value) {
                                  setState(() {
                                    Provider.of<AppStateNotifier>(context,
                                            listen: false)
                                        .updateTheme(value);
                                    _isDarkTheme = !_isDarkTheme;
                                  });
                                },
                                activeColor: Color.fromRGBO(50, 130, 209, 1.0),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 0.3,
                          color: appState.isDarkModeOn
                              ? Colors.white24
                              : CupertinoColors.systemGrey,
                        ),
                        GestureDetector(
                          onTap: () => _openChangeDefaultForecastWidget(appState),
                          child: Container(
                              height: 30,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Zmień domyślną prognozę pogody",
                                    style: TextStyle(
                                        color: appState.isDarkModeOn
                                            ? Colors.white
                                            : Colors.black),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 0.3,
                  color: appState.isDarkModeOn
                      ? Colors.transparent
                      : CupertinoColors.systemGrey,
                ),
                SizedBox(
                  height: 30,
                ),
                Divider(
                  height: 0,
                  thickness: 0.3,
                  color: appState.isDarkModeOn
                      ? Colors.transparent
                      : CupertinoColors.systemGrey,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    color: appState.isDarkModeOn
                        ? Color.fromRGBO(35, 35, 35, 1)
                        : Colors.white,
                    child: GestureDetector(
                      onTap: _openInfoScreen,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8, left: 15.0, right: 2.0, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Text("O aplikacji",
                                style: TextStyle(
                                    color: appState.isDarkModeOn
                                        ? Colors.white
                                        : Colors.black)),
                          ],
                        ),
                      ),
                    )),
                Divider(
                  height: 0,
                  thickness: 0.3,
                  color: appState.isDarkModeOn
                      ? Colors.transparent
                      : CupertinoColors.systemGrey,
                ),
              ],
            ),
          );
        })),
      ),
    );
  }

  void _openChangeDefaultForecastWidget(var appState) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return _buildBottomPicker(CupertinoPicker(
            backgroundColor: appState.isDarkModeOn ? Colors.black : Colors.white,
            onSelectedItemChanged: (int index) {
              setState(() {
                selectItem = index;
              });
            },
            itemExtent: 50.0,
            looping: false,
            squeeze: 1.4,
            children: <Widget>[
              if (list.forecastList.isEmpty)
                Center(child: Text("Brak prognoz"))
              else
                for (var element in list.forecastList)
                  Center(child: Text("${element.forecast.city}")),

            ],
          ));
        });
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 200,
      child: GestureDetector(
        onTap: () {
          if(list.forecastList.isNotEmpty) {
            bloc.add(ChangeDefaultForecast(id: selectItem));
            Navigator.of(context).pop();
          }
        },
        child: picker,
      ),
    );
  }

  void _openInfoScreen() {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => InfoScreen()));
  }
}
