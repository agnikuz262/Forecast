import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forecast/bloc/forecast_bloc.dart';
import 'package:forecast/bloc/forecast_event.dart';
import 'package:forecast/bloc/forecast_state.dart';
import 'package:forecast/model/api/weather_data.dart';
import 'package:mockito/mockito.dart';
import 'package:forecast/model/api/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  group('ForecastBloc', () {
    ForecastBloc forecastBloc;
    ApiService apiService;

    setUp(() {
      forecastBloc = ForecastBloc();
      apiService = MockApiService();
    });

    group('ForecastByCityRequested', () {
      blocTest(
        'emits [ForecastLoading, ForecastLoaded] when ForecastAddCityEvent is added and fetchCityData succeeds',
        build: () async {
          when(apiService.fetchCityData('Warsaw')).thenAnswer(
            (_) => Future.value(
              WeatherData(),
            ),
          );
          return forecastBloc;
        },
        act: (bloc) => bloc.add(ForecastAddCityEvent(city: 'Warsaw')),
        expect: [
          ForecastLoading(),
          ForecastLoaded(navigateToList: true),
        ],
      );
    });

    group('ForecastByLocalizatoinRequested', () {
      blocTest(
        'emits [ForecastLoading, ForecastFailure] when ForecastAddLocalizationEvent is added and fetchLocalizationData fails',
        build: () async {
          when(apiService.fetchLocalizationData(50.29, 18.67)).thenAnswer(
                (_) => Future.value(
              WeatherData(),
            ),
          );
          return forecastBloc;
        },
        act: (bloc) => bloc.add(ForecastAddLocalizationEvent()),
        expect: [
          ForecastLoading(),
          ForecastFailure(error: "Premission request timeout"),
        ],
      );
    });

    group('ForecastRefresh', () {
      blocTest(
        'emits [ForecastLoading, ForecastLoaded] when RefreshForecast is added',
        build: () async {
          return forecastBloc;
        },
        act: (bloc) => bloc.add(RefreshForecast()),
        expect: [
          ForecastLoading(),
          ForecastLoaded(navigateToList: true),
        ],
      );
    });
  });
}
