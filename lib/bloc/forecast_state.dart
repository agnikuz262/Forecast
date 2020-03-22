import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class ForecastState extends Equatable {
  const ForecastState();

  @override
  List<Object> get props => [];
}

class ForecastInitial extends ForecastState {}

class ForecastLoading extends ForecastState {}

class ForecastNotFound extends ForecastState {}

class ForecastDeleted extends ForecastState {}

class ForecastLoaded extends ForecastState {}

class ForecastFailure extends ForecastState {
  final String error;
  const ForecastFailure({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ForecastFailure { error: $error }';
}