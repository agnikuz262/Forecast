import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forecast/app_state_notifier.dart';
import 'package:forecast/ui/info_screen.dart';
import 'package:provider/provider.dart';

import '../change_default_forecast_widget.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkTheme = false;
  int selectItem = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(child:
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
                        onTap: _openChangeDefaultForecastWidget,
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
    );
  }

  void _openChangeDefaultForecastWidget() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return _buildBottomPicker(CupertinoPicker(
            onSelectedItemChanged: (int index) {
              selectItem = index;
            },
            itemExtent: 50.0,
            looping: false,
            squeeze: 1.4,
            magnification: 0.8,
            children: <Widget>[
              Center(child: Text("Miasto 1")),
              Center(child: Text("Miasto 2")),
              Center(child: Text("Miasto 3")),
              Center(child: Text("Miasto 4")),
            ],
          ));
        });
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 200,
      child: GestureDetector(
        // Blocks taps from propagating to the modal sheet and popping.
        onTap: () {},
        child: picker,
      ),
    );
  }

  void _openInfoScreen() {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => InfoScreen()));
  }
}
