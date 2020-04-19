import 'dart:async';
import 'dart:math';
import 'package:animator/animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forecast/bloc/forecast_bloc.dart';
import 'package:forecast/forecast_card/step_dot_widget.dart';
import 'package:forecast/helpers/time_formater.dart';
import '../helpers/alert_dialogs.dart';
import '../helpers/uppercase_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/custom_styles.dart';
import 'package:forecast/forecast_card/forecast_card_list.dart' as list;
class ForecastCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForecastCardState();
  final String city;
  final DateTime date;
  final String iconDesc;
  final double temp;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int sunrise;
  final int sunset;
  final String description;
  final int index;

  ForecastCard({
    @required this.city,
    this.date,
    this.iconDesc,
    this.temp,
    this.tempMax,
    this.tempMin,
    this.pressure,
    this.sunrise,
    this.sunset,
    this.description,
    this.index
  });
}

class _ForecastCardState extends State<ForecastCard>
    with TickerProviderStateMixin {
  AnimationController sunController;
  AnimationController stormController;
  AnimationController cloudsController;
  Animation sunAnimation;
  Animation stormAnimation;
  Animation cloudsAnimation;
  bool showFirst = true;
  Timer timer;
  ForecastBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ForecastBloc>(context);
    timer =
        Timer.periodic(Duration(milliseconds: 1100), (Timer t) => _showDrops());
    sunController =
        AnimationController(duration: const Duration(seconds: 4), vsync: this)
          ..repeat(period: new Duration(seconds: 20));
    sunAnimation = Tween(begin: 0.0, end: 2 * pi).animate(sunController);
    cloudsController =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..repeat(period: new Duration(seconds: 3));
    cloudsAnimation = Tween(begin: -8.0, end: 3.0).animate(cloudsController);
    cloudsController.forward();
    cloudsController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _buildDate(),
        ),
        Spacer(flex: 3),
        _getIcon(widget.iconDesc),
        Spacer(flex: 2),
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Text(
            widget.description == null
                ? "Brak dostępnego opisu"
                : "${widget.description.capitalize()}",
            style: CustomStyles.descriptionStyle,
            textAlign: TextAlign.center,
          ),
        ),
        Spacer(flex: 2),
        Center(child: Text("${widget.city}", style: CustomStyles.cityStyle)),
        Spacer(flex: 3),
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Opacity(
              opacity: 0.05,
              child: Container(
                height: 120,
                color: CupertinoColors.activeBlue,
              ),
            ),
            Container(
              height: 100,
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("${widget.temp.toInt()}°", style: CustomStyles.tempStyle),
                  Spacer(flex: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Min",
                            style: CustomStyles.tempLabel,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            "${widget.tempMin.toInt()}",
                            style: CustomStyles.tempMinMax,
                          ),
                        ],
                      ),
                      // Spacer(flex:2),
                      Row(
                        children: <Widget>[
                          Text("Max", style: CustomStyles.tempLabel),
                          SizedBox(width: 5.0),
                          Text(
                            "${widget.tempMax.toInt()}",
                            style: CustomStyles.tempMinMax,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Spacer(flex: 3),
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Text("${widget.pressure} hPa",
              style: CustomStyles.pressureStyle),
        ),
        Spacer(flex: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Wschód",
                  style: CustomStyles.sunStyle,
                ),
                SizedBox(height: 2.0),
                Text(
                  "${TimeFormater().readTimestamp(widget.sunrise)}",
                  style: CustomStyles.sunStyle,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Zachód",
                  style: CustomStyles.sunStyle,
                ),
                SizedBox(height: 2.0),
                Text("${TimeFormater().readTimestamp(widget.sunset)}",
                    style: CustomStyles.sunStyle),
              ],
            ),
          ],
        ),
        Spacer(flex: 1),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                list.forecastList.length,
                    (i) => Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: StepDotWidget(
                    list.forecastList.length - i - 1 == widget.index,
                    radius: 12,
                  ),
                ))),
        Spacer(flex: 2),
      ],
    );
  }

  Row _buildDate() {
    return Row(
      children: <Widget>[
        Text(
          "${DateFormat("dd.MM.yyyy, HH:mm").format(widget.date)}",
          style: CustomStyles.dateStyle,
        ),
        Spacer(),
        Container(
          width: 40.0,
          child: FlatButton(
            onPressed: () {
              AlertDialogs().displayDeleteDialog(context, widget, bloc);
            },
            child: Opacity(opacity: 0.4,
              child: Icon(
                CupertinoIcons.delete_simple,
                color: CupertinoColors.activeBlue,
              ),
            ),
          ),
        )
      ],
    );
  }

  void _showDrops() {
    setState(() {
      if (showFirst == true)
        showFirst = false;
      else
        showFirst = true;
    });
  }
  //todo make icons bigger when iPad
  Widget _getIcon(String iconDesc) {
    switch (iconDesc) {
      case "Clear":
        return AnimatedBuilder(
            animation: sunAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: sunAnimation.value,
                child: Image.asset('assets/icons/sun.png',
                    width: 100.0, height: 100.0),
              );
            });

      case "Thunderstorm":
        return Animator(
            cycles: 5,
            builder: (anim) => Opacity(
                opacity: anim.value,
                child: Image.asset('assets/icons/storm.png',
                    width: 100.0, height: 100.0)));

      case "Drizzle":
        return Container(
          width: 95.0,
          height: 95.0,
          child: AnimatedBuilder(
            animation: cloudsController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(cloudsAnimation.value, 0),
                child: Image.asset('assets/icons/drizzle.png'),
              );
            },
          ),
        );

      case "Rain":
        return AnimatedCrossFade(
            crossFadeState: showFirst
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(seconds: 1),
            firstChild:
                Image.asset('assets/icons/drop.png', width: 100.0, height: 100.0),
            secondChild: Image.asset('assets/icons/drop_reverse.png',
                width: 100.0, height: 100.0));

      case "Snow":
        return Stack(children: <Widget>[
          Opacity(
            opacity: 0.4,
            child:
                Image.asset('assets/icons/snow.png', width: 90.0, height: 90.0),
          ),
          Animator(
              duration: Duration(seconds: 2),
              cycles: 7,
              builder: (anim) => Opacity(
                  opacity: anim.value,
                  child: Image.asset('assets/icons/snow.png',
                      width: 90.0, height: 90.0))),
        ]);

      case "Clouds":
        return Container(
          width: 95.0,
          height: 95.0,
          child: AnimatedBuilder(
            animation: cloudsController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(cloudsAnimation.value, 0),
                child: Image.asset('assets/icons/cloudy.png'),
              );
            },
          ),
        );

      default:
        return Container(
          width: 95.0,
          height: 95.0,
          child: AnimatedBuilder(
            animation: cloudsController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(cloudsAnimation.value, 0),
                child: Image.asset('assets/icons/fog.png'),
              );
            },
          ),
        );
    }
  }

  @override
  void dispose() {
    sunController?.dispose();
    cloudsController?.dispose();
    stormController?.dispose();
    timer?.cancel();
    super.dispose();
  }
}
