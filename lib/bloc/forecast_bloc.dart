import 'dart:io';
import 'package:forecast/model/api/api_service.dart';
import 'package:forecast/model/api/forecast_model.dart';
import 'package:forecast/ui/forecast_card/forecast_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bloc/bloc.dart';
import 'package:forecast/bloc/forecast_event.dart';
import 'package:forecast/bloc/forecast_state.dart';
import 'package:forecast/model/api/weather_data.dart';
import 'package:forecast/ui/forecast_card/forecast_card_list.dart' as list;
import 'package:permission_handler/permission_handler.dart';

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  ApiService apiService = ApiService();

  @override
  ForecastState get initialState => ForecastInitial();

  bool _forecastInList(WeatherData weatherData) {
    for (int i = 0; i < list.forecastList.length; i++) {
      if (list.forecastList[i].forecast.city == weatherData.name) return true;
    }
    return false;
  }

  void _addLocalizationForecastToList(WeatherData weatherData) {
    list.forecastList.insert(
        0,
        ForecastCard(
            forecast: ForecastModel.fromApi(weatherData),
            listIndex: list.forecastList.length));
    //todo remove
    list.defaultForecast = ForecastCard(
        forecast: ForecastModel.fromApi(weatherData),
        listIndex: list.forecastList.length);
  }

  @override
  Stream<ForecastState> mapEventToState(ForecastEvent event) async* {
    if (event is ForecastAddCityEvent) {
      yield ForecastLoading();
      var response = await apiService.fetchCityData(event.city);
      if (response is WeatherData) {
        ForecastModel newForecast = ForecastModel.fromApi(response);
        list.forecastList.insert(
            0,
            ForecastCard(
                forecast: newForecast, listIndex: list.forecastList.length));
        yield ForecastLoaded();
      } else if (response == true) {
        ForecastNotFound();
      } else {
        yield ForecastFailure(error: "No connection");
      }
    }
    if (event is ForecastAddLocalizationEvent) {
      yield ForecastLoading();
      Position position;
      PermissionStatus permissionStatus;
      permissionStatus = await Permission.location.status;

      if (permissionStatus.isUndetermined) {
        permissionStatus = await Permission.location.request();
      }
      if (permissionStatus.isDenied) {
        yield LocationPermissionDenied();
        return;
      } else if (permissionStatus.isPermanentlyDenied) {
        yield LocationPermissionDenied();
        return;
      } else if (permissionStatus.isRestricted) {
        yield LocationPermissionRestricted();
        return;
      } else if (permissionStatus.isGranted) {
        try {
          position = await Geolocator()
              .getCurrentPosition()
              .timeout(Duration(seconds: 5));

          var response = await apiService.fetchLocalizationData(
              position.latitude, position.longitude);
          if (response is WeatherData) {
            if (!_forecastInList(response)) {
              _addLocalizationForecastToList(response);

              yield ForecastLoaded();
              return;
            } else {
              yield ForecastAlreadySaved();
              return;
            }
          } else if (response == true) {
            yield ForecastNotFound();
            return;
          } else {
            yield ForecastFailure(error: "No connection");
          }
        } catch (e) {
          print("geolocator error ${e.toString()}");
          yield ForecastNoGps();
          return;
        }
      }
    }
    if (event is ForecastCardDeleted) {
      yield ForecastLoading();
      try {
        list.forecastList.removeAt(event.listIndex);
        yield ForecastDeleted();
      } catch (_) {
        //todo zmienic na delete failure
        yield ForecastFailure(error: "Nie udało się usunąć prognozy");
      }
    }
    if (event is RefreshForecast) {
      yield ForecastLoading();
      if (list.forecastList.isEmpty) {
        yield ForecastLoaded();
      } else {
        try {
          List<ForecastCard> tempForecastList = [];
          var refreshResult = await _refreshForecastList();
          if (refreshResult == false) {
            yield ForecastFailure(error: "No connection");
            return;
          } else {
            list.forecastList.clear();
            list.forecastList = tempForecastList;
            yield ForecastLoaded();
          }
        } catch (e) {
          yield ForecastFailure(error: e.toString());
        }
      }
    }
  }

  Future _refreshForecastList() async {
    List<ForecastCard> tempForecastList = [];
    if (await _checkConnection()) {
      for (var element in list.forecastList) {
        var forecast = await apiService.fetchCityData(element.forecast.city);
        tempForecastList.add(ForecastCard(
          listIndex: list.forecastList.length,
          forecast: forecast,
        ));
      }
      return tempForecastList;
    } else {
      return false;
    }
  }

  Future<bool> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else
        return false;
    } on SocketException catch (_) {
      return false;
    }
  }
}
