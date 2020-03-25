import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 250.0,
          ),
          SvgPicture.asset('assets/icons/wifi.svg',
              width: 80.0, height: 80.0, color: Colors.white),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}