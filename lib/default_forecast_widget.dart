import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forecast/forecast_card/forecast_card.dart';
import 'package:forecast/forecast_card/forecast_card_list.dart' as list;
import 'package:forecast/forecast_list_screen.dart';
import 'package:forecast/utils/custom_styles.dart';

class DefaultForecastWidget extends StatefulWidget {
  @override
  _DefaultForecastWidgetState createState() => _DefaultForecastWidgetState();
}

class _DefaultForecastWidgetState extends State<DefaultForecastWidget> {
  ForecastCard defaultCard;

  @override
  void initState() {
    super.initState();
    defaultCard = list.forecastList[list.forecastList.length];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              defaultCard.city,
              style: CustomStyles.cityStyle,
            ),
            SizedBox(
              height: 10.0,
            ),
            iconType,
            Text(
              "${defaultCard.temp.toInt()}°",
              style: CustomStyles.tempWidgetStyle,textAlign: TextAlign.center,
            ),
            CupertinoButton(
              child: Text("Szczegóły"),
              onPressed: _openListWithDefault,
            )
          ],
        ),
      ),
    );
  }

  void _openListWithDefault() {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => ForecastListScreen()));
  }

  Widget get iconType {
    switch (defaultCard.iconDesc) {
      case "Clear":
        return Image.asset('assets/icons/sun.png', width: 30.0, height: 30.0);

      case "Thunderstorm":
        return Image.asset('assets/icons/storm.png',
            width: 60.0, height: 60.0);

      case "Drizzle":
        return Image.asset('assets/icons/drizzle.png');

      case "Rain":
        return Image.asset('assets/icons/drop.png',
            width: 100.0, height: 100.0);

      case "Snow":
        return Image.asset('assets/icons/snow.png', width: 90.0, height: 90.0);

      case "Clouds":
        return Image.asset('assets/icons/cloudy.png', width: 70.0, height: 70.0);

      default:
        return Image.asset('assets/icons/fog.png');
    }
  }
}
