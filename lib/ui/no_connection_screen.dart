import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forecast/bloc/forecast_bloc.dart';
import 'package:forecast/bloc/forecast_event.dart';
import 'package:forecast/utils/custom_styles.dart';

class NoConnectionScreen extends StatefulWidget {
  @override
  _NoConnectionScreenState createState() => _NoConnectionScreenState();
}

class _NoConnectionScreenState extends State<NoConnectionScreen> {
  ForecastBloc bloc;

  @override
  void initState() {
    bloc = BlocProvider.of<ForecastBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
          child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 250.0,
            ),
            SvgPicture.asset('assets/icons/wifi.svg',
                width: 80.0,
                height: 80.0,
                color: Color.fromRGBO(50, 130, 209, 1.0)),
            SizedBox(height: 20.0),
            Text("Wystąpił błąd, sprawdź połączenie z internetem."),
            SizedBox(
              height: 5,
            ),
            GestureDetector(
                onTap: () {
                  bloc.add(RefreshForecast());
                  Navigator.of(context).pop();
                },
                child: Text("Załaduj ponownie",
                    style: TextStyle(
                      color: Color.fromRGBO(50, 130, 209, 1.0),
                    )))
          ],
        ),
      )),
    );
  }
}
