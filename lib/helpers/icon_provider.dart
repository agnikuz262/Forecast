import 'package:flutter/cupertino.dart';

class IconProvider {
  static getIcon(String iconDesc, {double size}) {
    switch (iconDesc) {
      case "Clear":
        return Image.asset('assets/icons/sun.png', width: size ?? 60.0, height: size ?? 60.0);

      case "Thunderstorm":
        return Image.asset('assets/icons/storm.png',
            width: 60.0, height: 60.0);

      case "Drizzle":
        return Image.asset('assets/icons/drizzle.png');

      case "Rain":
        return Image.asset('assets/icons/drop.png',
            width: 80.0, height: 80.0);

      case "Snow":
        return Image.asset('assets/icons/snow.png', width: 90.0, height: 90.0);

      case "Clouds":
        return Image.asset('assets/icons/cloudy.png', width: 70.0, height: 70.0);

      default:
        return Image.asset('assets/icons/fog.png');
    }
  }
}