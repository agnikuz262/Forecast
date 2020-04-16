import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forecast/utils/custom_styles.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Informacje o aplikacji"),),
        child: Container(
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                      width: 190,
                      height: 190,
                      padding: EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        border: Border.all(
                            width: 1.0, color: CupertinoColors.systemGrey),
                      )),
                  Image.asset(
                    'assets/icons/umbrella512.png',
                    height: 130,
                    width: 130,
                  )
                ],
              ),
              Text(
                "Pogoda",
                style: CustomStyles.tempStyle.copyWith(fontSize: 35),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Aplikacja Pogoda służy do informowania użytkownika o aktualnej pogodzie dla wybranych przez siebie miast lub lokalizacji.",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 50.0,),
                    Text("Autorzy:", style: TextStyle(color: Colors.black)),
                    SizedBox(height: 10.0,),
                    Text("Agnieszka Kuźniecow",
                        style: TextStyle(color: Colors.black)),
                    Text("Michał Grzyśka",
                        style: TextStyle(color: Colors.black))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
