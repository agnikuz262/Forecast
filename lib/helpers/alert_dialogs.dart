import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forecast/bloc/forecast_bloc.dart';
import 'package:forecast/bloc/forecast_event.dart';
import 'package:forecast/utils/custom_styles.dart';
import '../forecast_card/forecast_card_list.dart' as globals;

//todo change to ios alert dialogs
class AlertDialogs {
  displayAddDialog(BuildContext context, ForecastBloc bloc) async {
    TextEditingController _cityController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Dodaj nową prognozę!'),
            content: Row(
              children: <Widget>[
                Icon(CupertinoIcons.add_circled),
                CupertinoTextField(placeholder: "Wpisz miasto",
                  textCapitalization: TextCapitalization.words,
                  controller: _cityController,
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('WSTECZ'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('DODAJ'),
                onPressed: () {
                  print(_cityController.text);
                  String enteredCity = _cityController.text.toString();
                  bloc.add(ForecastAddCityEvent(city: enteredCity));
                  Navigator.of(context).pop();
          })]);
        });}

  displayDeleteDialog(BuildContext context, Widget widget, ForecastBloc bloc) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Usuwanie prognozy'),
            content:
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
               mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.delete_outline, color: CustomStyles.primaryColor, size: 40,),
                  SizedBox(height: 10.0,),
                  Text("Czy na pewno chcesz usunąć prognozę dla tego miasta?", textAlign: TextAlign.center, ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('WSTECZ'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('USUŃ'),
                onPressed: () {
                  int deleteInd = globals.forecastList.indexOf(widget);
                  bloc.add(ForecastCardDeleted(ind: deleteInd));
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}