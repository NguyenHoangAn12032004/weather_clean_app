import 'package:equatable/equatable.dart';
import '../../domain/entities/weather.dart';
import '../../domain/entities/forecast.dart'; 
import '../../domain/entities/air_quality.dart'; // New

abstract class WeatherState extends Equatable {
  const WeatherState();
  
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherEntity weather;
  final ForecastEntity? forecast;
  final AirQualityEntity? airQuality; // New

  const WeatherLoaded(this.weather, {this.forecast, this.airQuality});

  @override
  List<Object?> get props => [weather, forecast, airQuality];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}
