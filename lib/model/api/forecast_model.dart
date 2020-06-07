import 'package:forecast/helpers/time_formatter.dart';
import 'package:forecast/model/api/weather_data.dart';
import 'package:intl/intl.dart';

class ForecastModel {
  int id;
  String city;
  String date;
  String iconDesc;
  double temp;
  double tempMin;
  double tempMax;
  int pressure;
  String sunrise;
  String sunset;
  String description;

  ForecastModel(
      {this.id,
      this.city,
      this.date,
      this.iconDesc,
      this.temp,
      this.tempMin,
      this.tempMax,
      this.pressure,
      this.sunrise,
      this.sunset,
      this.description});

  ForecastModel.fromApi(WeatherData weatherData)
      : id = weatherData.id,
        date = DateFormat("dd.MM.yyyy, HH:mm").format(DateTime.now()),
        city = weatherData.name,
        iconDesc = weatherData.weather[0].main ?? "",
        temp = weatherData.main.temp ?? "",
        tempMin = weatherData.main.tempMin ?? "",
        tempMax = weatherData.main.tempMax ?? "",
        pressure = weatherData.main.pressure ?? "",
        sunrise = TimeFormatter().readTimestamp(weatherData.sys.sunrise) ?? "",
        sunset = TimeFormatter().readTimestamp(weatherData.sys.sunset) ?? "",
        description = weatherData.weather[0].description ?? "";
}
