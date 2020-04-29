import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:forecast/bloc/forecast_event.dart';
import 'package:forecast/bloc/forecast_state.dart';
import 'package:forecast/model/api/weather_data.dart';
import 'package:forecast/forecast_card/forecast_card_list.dart' as list;
import 'package:permission_handler/permission_handler.dart';
import '../forecast_card/forecast_card.dart';

Future fetchCityData(String city) async {
  final String apiKey = "b6dc63335a86e575b1eab4dc075c87b1";
  final response = await http.get(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey&lang=pl");

  if (response.statusCode == 200) {
    try {
      return WeatherData.fromJson(json.decode(response.body));
    } catch (e) {
      return e;
    }
  } else {
    return 'Status code != 200';
  }
}

Future fetchLocalizationData(double lat, double long) async {
  final String apiKey = "b6dc63335a86e575b1eab4dc075c87b1";
  final response = await http.get(
      "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&units=metric&appid=$apiKey&lang=pl");

  if (response.statusCode == 200) {
    try {
      return WeatherData.fromJson(json.decode(response.body));
    } catch (e) {
      return e;
    }
  } else {
    return 'Failed to load forecast';
  }
}

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  bool isConnection = false;

  @override
  ForecastState get initialState => ForecastInitial();

  @override
  Stream<ForecastState> mapEventToState(ForecastEvent event) async* {
    if (event is ForecastAddCityEvent) {
      yield ForecastLoading();
      await _checkConnection().then((answer) {
        isConnection = answer;
      });
      if (isConnection) {
        try {
          var respond = await fetchCityData(event.city);
          if (respond is WeatherData) {
            _addCityForecastToList(respond, event);
            yield ForecastLoaded();
          } else {
            yield ForecastNotFound();
          }
        } catch (e) {
          yield ForecastFailure(error: e.toString());
          throw e;
        }
      } else {
        yield ForecastFailure(error: "No connection");
      }
    }
    if (event is ForecastAddLocalizationEvent) {
      yield ForecastLoading();
      Position position;
      PermissionStatus permissionStatus;
      try {
        permissionStatus = await Permission.location.status;
        if (permissionStatus.isUndetermined) {
          permissionStatus = await Permission.location.request();
        }
        if (permissionStatus.isDenied) {
          print("denied");
          yield LocationPermissionDenied();
          return;
        } else if (permissionStatus.isPermanentlyDenied) {
          print("permamently denied");
          yield LocationPermissionDenied();
          return;
        } else if (permissionStatus.isRestricted) {
          print("restricted");
          yield LocationPermissionRestricted();
          return;
        } else if (permissionStatus.isGranted) {
          print("granted");
          try {
            position = await Geolocator()
                .getCurrentPosition()
                .timeout(Duration(seconds: 5));
            await _checkConnection().then((answer) {
              isConnection = answer;
            });
            if (isConnection) {
              try {
                var respond =
                    await fetchLocalizationData(position.latitude, position.longitude);
                if (respond is WeatherData) {
                  bool isNew = _addLocalizationForecastToList(respond, event);
                  if (isNew) {
                    yield ForecastLoaded();
                    return;
                  } else {
                    yield ForecastAlreadySaved();
                    return;
                  }
                } else {
                  yield ForecastNotFound();
                  return;
                }
              } catch (e) {
                yield ForecastFailure(error: e.toString());
                throw e;
              }
            } else {
              yield ForecastFailure(error: "No connection");
              return;
            }
          } catch (e) {
            print("geolocator error ${e.toString()}");
            yield ForecastNoGps();
            return;
          }
        }
      } catch (e) {
        print("error ${e.toString()}");
        yield ForecastFailure(error: e.toString());
        return;
      }
    }
    if (event is ForecastCardDeleted) {
      list.forecastList.removeAt(event.ind);
      yield ForecastLoading();
      yield ForecastDeleted();
    }
    if (event is RefreshForecast) {
      yield ForecastLoading();
      bool isConnection = false;
      await _checkConnection().then((answer) {
        isConnection = answer;
      });
      if (isConnection) {
        if (list.forecastList.isEmpty) {
          yield ForecastLoaded();
        } else {
          try {
            List<ForecastCard> tempForecastList = [];
            await _refreshForecastList().then((list) {
              tempForecastList = list;
            });
            list.forecastList.clear();
            list.forecastList = tempForecastList;
            yield ForecastLoaded();
          } catch (e) {
            yield ForecastFailure(error: e.toString());
          }
        }
      } else
        yield ForecastFailure(error: "No connection");
    }
  }

  Future<bool> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  Future _refreshForecastList() async {
    List<ForecastCard> tempForecastList = [];
    for (int i = 0; i < list.forecastList.length; i++) {
      var r = await fetchCityData(list.forecastList[i].city);
      String city = list.forecastList[i].city;
      DateTime date = DateTime.now();
      String iconDesc = r.weather[0].main;
      double temp = r.main.temp;
      double tempMin = r.main.tempMin;
      double tempMax = r.main.tempMax;
      int pressure = r.main.pressure;
      int sunrise = r.sys.sunrise;
      int sunset = r.sys.sunset;
      String description = r.weather[0].description;

      var listElement = ForecastCard(
        city: city,
        date: date,
        iconDesc: iconDesc,
        temp: temp,
        tempMax: tempMax,
        tempMin: tempMin,
        pressure: pressure,
        sunrise: sunrise,
        sunset: sunset,
        description: description,
        index: list.forecastList.length,
      );
      tempForecastList.add(listElement);
    }
    return tempForecastList;
  }

  void _addCityForecastToList(WeatherData r, ForecastAddCityEvent event) {
    String city = event.city;
    DateTime date = DateTime.now();
    String iconDesc = r.weather[0].main;
    double temp = r.main.temp;
    double tempMin = r.main.tempMin;
    double tempMax = r.main.tempMax;
    int pressure = r.main.pressure;
    int sunrise = r.sys.sunrise;
    int sunset = r.sys.sunset;
    String description = r.weather[0].description;

    var listElement = ForecastCard(
      city: city,
      date: date,
      iconDesc: iconDesc,
      temp: temp,
      tempMax: tempMax,
      tempMin: tempMin,
      pressure: pressure,
      sunrise: sunrise,
      sunset: sunset,
      description: description,
      index: list.forecastList.length,
    );
    list.forecastList.insert(0, listElement);
    list.defaultForecast = listElement;
  }

  bool _addLocalizationForecastToList(
      WeatherData r, ForecastAddLocalizationEvent event) {
    String city = r.name;
    DateTime date = DateTime.now();
    String iconDesc = r.weather[0].main;
    double temp = r.main.temp;
    double tempMin = r.main.tempMin;
    double tempMax = r.main.tempMax;
    int pressure = r.main.pressure;
    int sunrise = r.sys.sunrise;
    int sunset = r.sys.sunset;
    String description = r.weather[0].description;

    for (int i = 0; i < list.forecastList.length; i++) {
      if (list.forecastList[i].city == city) return false;
    }
    var listElement = ForecastCard(
      city: city,
      date: date,
      iconDesc: iconDesc,
      temp: temp,
      tempMax: tempMax,
      tempMin: tempMin,
      pressure: pressure,
      sunrise: sunrise,
      sunset: sunset,
      description: description,
      index: list.forecastList.length,
    );
    list.forecastList.insert(0, listElement);
    return true;
  }
}
