import 'package:flutter/cupertino.dart';

class CityPicker extends StatefulWidget {
  @override
  _CityPickerState createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> {
  int selectItem = 1;
  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      onSelectedItemChanged: (int index) {
        selectItem = index;
      },
      itemExtent: 5.0,
      looping: false,
      magnification: 1.5,
      children: <Widget>[
        Text("1"),
        Text("2"),
        Text("3"),
        Text("4"),
      ],
    );
  }
}
