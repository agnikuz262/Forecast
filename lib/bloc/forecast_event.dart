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

class ForecastAddLocalizationEvent extends ForecastEvent {}

class DeleteForecast extends ForecastEvent {
  final listIndex;

  DeleteForecast({@required this.listIndex});

  @override
  List<Object> get props => [listIndex];

  @override
  String toString() => 'ForecastCardDeleted { ind: $listIndex }';
}

class RefreshForecast extends ForecastEvent {
  const RefreshForecast();

  @override
  List<Object> get props => [];
}

class ChangeDefaultForecast extends ForecastEvent {
  final id;

  ChangeDefaultForecast({@required this.id});

  @override
  List<Object> get props => [id];
}

class SetInitialState extends ForecastEvent {}
