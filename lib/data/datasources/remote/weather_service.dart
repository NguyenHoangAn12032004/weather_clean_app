import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/weather_dto.dart';

import '../../models/forecast_dto.dart';
import '../../models/air_quality_dto.dart'; // New
import '../../../core/constants/app_constants.dart';

part 'weather_service.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class WeatherService {
  factory WeatherService(Dio dio, {String baseUrl}) = _WeatherService;

  @GET('weather')
  Future<WeatherDto> getCurrentWeather(
    @Query('q') String city, {
    @Query('lang') String lang = AppConstants.defaultLang,
  });

  @GET('weather')
  Future<WeatherDto> getWeatherByCoordinates(
    @Query('lat') double lat,
    @Query('lon') double lon, {
    @Query('lang') String lang = AppConstants.defaultLang,
  });

  @GET('forecast')
  Future<ForecastDto> getForecast(
    @Query('q') String city, {
    @Query('lang') String lang = AppConstants.defaultLang,
  });

  @GET('forecast')
  Future<ForecastDto> getForecastByCoordinates(
    @Query('lat') double lat,
    @Query('lon') double lon, {
    @Query('lang') String lang = AppConstants.defaultLang,
  });

  @GET('air_pollution')
  Future<AirQualityDto> getAirPollution(
    @Query('lat') double lat,
    @Query('lon') double lon,
  );
}
