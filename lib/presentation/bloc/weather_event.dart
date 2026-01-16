import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class GetWeatherForCity extends WeatherEvent {
  final String city;

  const GetWeatherForCity(this.city);

  @override
  List<Object> get props => [city];
}

class LoadSavedCity extends WeatherEvent {}

class GetWeatherForLocation extends WeatherEvent {}
