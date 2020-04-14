import 'package:flutter/cupertino.dart';

class ChangeDefaultForecast extends StatefulWidget {
  @override
  _ChangeDefaultForecastState createState() => _ChangeDefaultForecastState();
}

class _ChangeDefaultForecastState extends State<ChangeDefaultForecast> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Center(child: Text("Zmiana domyślnej pogody")));
  }
}
