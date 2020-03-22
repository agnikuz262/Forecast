import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ForecastEvent extends Equatable {
  const ForecastEvent();

  @override
  List<Object> get props => [];
}

class ForecastAddCityEvent extends ForecastEvent {
  final city;
  ForecastAddCityEvent({@required this.city});

  @override
  List<Object> get props => [city];

  @override
  String toString() => 'ForecastAddCityEvent { city: $city }';
}

class ForecastCardDeleted extends ForecastEvent {
  final ind;
  ForecastCardDeleted({@required this.ind});

  @override
  List<Object> get props => [ind];

  @override
  String toString() => 'ForecastCardDeleted { ind: $ind }';
}

class RefreshForecast extends ForecastEvent {
  const RefreshForecast();

  @override
  List<Object> get props => [];
}