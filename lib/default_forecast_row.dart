import 'package:flutter/cupertino.dart';
import 'package:forecast/forecast_list_screen.dart';
import 'package:forecast/helpers/icon_provider.dart';

class DefaultForecastRow extends StatefulWidget {
  @override
  _DefaultForecastRowState createState() => _DefaultForecastRowState();
}

class _DefaultForecastRowState extends State<DefaultForecastRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100.0,
      color: Color.fromARGB(50, 173, 216, 230),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(child: IconProvider.getIcon("Clear", size: 60.0)),
            Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("BYTOM",
                    style: TextStyle(color: CupertinoColors.black, fontSize: 20)),
                SizedBox(height: 5.0),
                Text("14°",
                    style: TextStyle(color: CupertinoColors.black, fontSize: 26)),
              ],
            )),
            Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10.0,),
                Row(
                  children: <Widget>[
                    SizedBox(width: 30.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Min 10",
                            style: TextStyle(color: CupertinoColors.black, fontSize: 15)),
                        Text("Max 15",
                            style: TextStyle(color: CupertinoColors.black, fontSize: 15)),
                      ],
                    ),
                  ],
                ),
                CupertinoButton(
                    child: Text("Szczegóły",
                        style: TextStyle(
                            color: CupertinoColors.activeBlue, fontSize: 15)),
                    onPressed: () => Navigator.of(context).push(
                        CupertinoPageRoute(
                            builder: (context) => ForecastListScreen())))
              ],
            )),
          ],
        ),
      ),
    );
  }
}
