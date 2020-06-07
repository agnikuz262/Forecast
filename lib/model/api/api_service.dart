import 'dart:convert';

import 'package:forecast/model/api/weather_data.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = "b6dc63335a86e575b1eab4dc075c87b1";

  Future fetchCityData(String city) async {
    final response = await http.get(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey&lang=pl");

    if (response.statusCode == 200) {
      try {
        return WeatherData.fromJson(json.decode(response.body));
      } catch (e) {
        return true;
      }
    } else {
      return false;
    }
  }

  Future fetchLocalizationData(double lat, double long) async {
    final response = await http.get(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&units=metric&appid=$apiKey&lang=pl");

    if (response.statusCode == 200) {
      try {
        return WeatherData.fromJson(json.decode(response.body));
      } catch (_) {
        return true;
      }
    } else {
      return false;
    }
  }
}