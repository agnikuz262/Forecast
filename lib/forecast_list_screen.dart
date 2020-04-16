import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forecast/bloc/forecast_bloc.dart';
import 'package:forecast/bloc/forecast_state.dart';
import 'package:forecast/forecast_card/forecast_card_list.dart' as list;
import 'package:forecast/no_connection_screen.dart';

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
    return BlocConsumer<ForecastBloc, ForecastState>(
      builder: (context, state) {
        if (state is ForecastLoading) {
          state = ForecastInitial();
          return CupertinoActivityIndicator(
            animating: true,
            radius: 15.0,
          );
        }
        if (state is ForecastLoaded) {
          print("loaded");
          state = ForecastInitial();
          return _buildView();
        }
        if (state is ForecastNotFound) {
          print("Not found");
          state = ForecastInitial();
          return _buildView();
        }
        if (state is ForecastFailure) {
          print("failure");
          state = ForecastInitial();
          return NoConnectionScreen();
        } else {
          return Container(
            child: Text(
              "Coś poszło nie tak",
              style: TextStyle(color: Colors.red),
            ),
          );
        }
      },
      listener: (context, state) {},
      bloc: _bloc,
    );
  }

  Widget _buildView() {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Twoje prognozy", style: TextStyle(fontWeight: FontWeight.w400),),
          trailing: Icon(CupertinoIcons.refresh, color: CupertinoColors.black,),
        ),
        child: SafeArea(
            child: PageView(
          children: <Widget>[
            for (int i = 0; i < list.forecastList.length; i++) ...[
              list.forecastList[i]
            ]
          ],
        )));
  }
}
