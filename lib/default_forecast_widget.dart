import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forecast/forecast_card/forecast_card.dart';
import 'package:forecast/forecast_card/forecast_card_list.dart' as list;
import 'package:forecast/forecast_list_screen.dart';
import 'package:forecast/helpers/icon_provider.dart';
import 'package:forecast/utils/custom_styles.dart';

class DefaultForecastWidget extends StatefulWidget {
  final Color cardColor;
  final Color textColor;

  DefaultForecastWidget({this.cardColor, this.textColor});

  @override
  _DefaultForecastWidgetState createState() => _DefaultForecastWidgetState();
}

class _DefaultForecastWidgetState extends State<DefaultForecastWidget> {
  ForecastCard defaultCard;

  @override
  void initState() {
    super.initState();
    defaultCard = list.defaultForecast;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.cardColor ?? Colors.white,
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              defaultCard.city,
              style: CustomStyles.cityStyle
                  .copyWith(color: widget.textColor ?? null),
            ),
            SizedBox(
              height: 10.0,
            ),
            IconProvider.getIcon(defaultCard.iconDesc),
            Text(
              "${defaultCard.temp.toInt()}°",
              style: CustomStyles.tempWidgetStyle
                  .copyWith(color: widget.textColor ?? null),
              textAlign: TextAlign.center,
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
}
