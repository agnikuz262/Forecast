import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'change_default_forecast_widget.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              ListTile(
                onTap: () {
                  setState(() {
                    _isDarkTheme = !_isDarkTheme;
                  });
                },
                title: Text("Tryb ciemny"),
                trailing: CupertinoSwitch(
                  value: _isDarkTheme,
                  onChanged: (bool value) {
                    setState(() {
                      _isDarkTheme = value;
                      print(_isDarkTheme);
                    });
                  },
                  activeColor: CupertinoColors.activeBlue,
                ),
              ),
              Divider(thickness: 0.2, color: CupertinoColors.systemGrey,),
              ListTile(
                title: Text("Zmień domyślną prognozę pogody"),
                onTap: _openChangeDefaultForecastWidget,
              )
            ],
          ),
        ),
      ),
    ));
  }

  void _openChangeDefaultForecastWidget() {
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => ChangeDefaultForecast()));
  }
}
