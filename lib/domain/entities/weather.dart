import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final String cityName;
  final String description;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String iconCode;
  final int timezone; 
  final double lat; 
  final double lon; 
  final int pressure; // New
  final int visibility; // New
  final int sunrise; // New
  final int sunset; // New

  const WeatherEntity({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.iconCode,
    required this.timezone,
    required this.lat,
    required this.lon,
    required this.pressure,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
  });

  @override
  List<Object?> get props => [
        cityName,
        description,
        temperature,
        feelsLike,
        humidity,
        windSpeed,
        iconCode,
        timezone,
        lat, 
        lon, 
        pressure, // New
        visibility,
        sunrise,
        sunset,
      ];
}
