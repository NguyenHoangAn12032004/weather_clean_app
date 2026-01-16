import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/city.dart';
import '../entities/weather.dart';
import '../entities/forecast.dart';
import '../entities/air_quality.dart'; // New

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(String city);
  Future<Either<Failure, WeatherEntity>> getCurrentWeatherByLocation();
  Future<Either<Failure, ForecastEntity>> getForecast(String city);
  Future<Either<Failure, ForecastEntity>> getForecastByLocation();
  Future<Either<Failure, AirQualityEntity>> getAirQuality(double lat, double lon); // New
  Future<Either<Failure, List<CityEntity>>> searchCities(String query);
  Future<void> saveLastCity(String city);
  Future<String?> getLastCity();
  Future<Either<Failure, List<String>>> getSavedCities();
  Future<Either<Failure, void>> addCity(String city);
  Future<Either<Failure, void>> removeCity(String city);
}
