import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forecast/bloc/forecast_bloc.dart';
import 'package:forecast/bloc/forecast_event.dart';

class AddCityDialog extends StatefulWidget {
  @override
  _AddCityDialogState createState() => _AddCityDialogState();
}

class _AddCityDialogState extends State<AddCityDialog> {
  TextEditingController _textController;
  ForecastBloc _bloc;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _bloc = BlocProvider.of<ForecastBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Dodawanie prognozy"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10.0),
          Text("Wprowadź miasto"),
          SizedBox(height: 10.0),
          CupertinoTextField(decoration: BoxDecoration(borderRadius: BorderRadius.circular(100.0),
              //todo
              color: CupertinoColors.black),
            placeholder: "Wprowadź miasto",
            textAlignVertical: TextAlignVertical.top,
            textCapitalization: TextCapitalization.words,
            controller: _textController,
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
            enabled: true,
          ),
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text("Wstecz"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        CupertinoDialogAction(
          child: Text("Dodaj"),
          onPressed: () { _addForecast(); },
        ),
      ],
    );
  }

  void _addForecast() {
    var city = _textController.text;
    print(city);
    _bloc.add(ForecastAddCityEvent(city: city));
    Navigator.of(context).pop();
  }
}
