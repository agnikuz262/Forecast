import 'package:forecast/model/api/coordinates.dart';
import 'package:forecast/model/api/main_data.dart';
import 'package:forecast/model/api/sys.dart';
import 'package:forecast/model/api/weather.dart';
import 'package:forecast/model/api/wind.dart';
import 'clouds.dart';

class WeatherData {
  Coordinates coord;
  List<Weather> weather;
  Weather weat;
  String base;
  MainData main;
  int visibility;
  Wind wind;
  Clouds clouds;
  int dt;
  Sys sys;
  int id;
  String name;
  int cod;

  WeatherData(
      {this.coord,
      this.weather,
      this.base,
      this.main,
      this.visibility,
      this.wind,
      this.clouds,
      this.dt,
      this.sys,
      this.id,
      this.name,
      this.cod});

  WeatherData.fromJson(Map<String, dynamic> json) {
    coord =
        json['coord'] != null ? new Coordinates.fromJson(json['coord']) : null;
    if (json['weather'] != null) {
      weather = new List<Weather>();
      json['weather'].forEach((v) {
        weather.add(new Weather.fromJson(v));
      });
    }
    base = json['base'];
    main = json['main'] != null ? new MainData.fromJson(json['main']) : null;
    visibility = json['visibility'];
    wind = json['wind'] != null ? new Wind.fromJson(json['wind']) : null;
    clouds =
        json['clouds'] != null ? new Clouds.fromJson(json['clouds']) : null;
    dt = json['dt'];
    sys = json['sys'] != null ? new Sys.fromJson(json['sys']) : null;
    id = json['id'];
    name = json['name'];
    cod = json['cod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coord != null) {
      data['coord'] = this.coord.toJson();
    }
    if (this.weather != null) {
      data['weather'] = this.weather.map((v) => v.toJson()).toList();
    }
    data['base'] = this.base;
    if (this.main != null) {
      data['main'] = this.main.toJson();
    }
    data['visibility'] = this.visibility;
    if (this.wind != null) {
      data['wind'] = this.wind.toJson();
    }
    if (this.clouds != null) {
      data['clouds'] = this.clouds.toJson();
    }
    data['dt'] = this.dt;
    if (this.sys != null) {
      data['sys'] = this.sys.toJson();
    }
    data['id'] = this.id;
    data['name'] = this.name;
    data['cod'] = this.cod;
    return data;
  }
}
