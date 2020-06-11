import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forecast/ui/forecast_card/forecast_card.dart';
import 'package:forecast/ui/forecast_card/forecast_card_list.dart' as list;
import 'package:forecast/ui/forecast_list_screen.dart';
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
        child: (defaultCard != null)
            ? Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      defaultCard.forecast.city,
                      style: CustomStyles.cityStyle
                          .copyWith(color: widget.textColor ?? null),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    IconProvider.getIcon(defaultCard.forecast.iconDesc),
                    SizedBox(height: 10.0),
                    Text(
                      "${defaultCard.forecast.temp.toInt()}°",
                      style: CustomStyles.tempWidgetStyle
                          .copyWith(color: widget.textColor ?? null),
                      textAlign: TextAlign.center,
                    ),
                    CupertinoButton(
                      child: Text("Szczegóły"),
                      onPressed: _openListWithDefault,
                    )
                  ],
                ))
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                    width: 130,
                    height: 180,
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Brak domyślnej prognozy.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        SizedBox(height: 5.0,),
                        Image.asset(
                          "assets/icons/sun_and_cloud.png",
                          height: 70,
                          width: 70,
                          color: widget.textColor ?? Colors.black12,
                        ),
                        SizedBox(height: 10.0,),
                        Text(
                          "Po dodaniu prognoz, ustaw ją w zakładce Ustawienia.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        )
                      ],
                    ))),
              ));
  }

  void _openListWithDefault() {
    Navigator.of(context)
        .push(CupertinoPageRoute(builder: (context) => ForecastListScreen()));
  }
}
