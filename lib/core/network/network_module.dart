import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/remote/geo_service.dart';
import '../../data/datasources/remote/weather_service.dart';
import '../constants/app_constants.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        queryParameters: {'appid': AppConstants.apiKey, 'units': 'metric'},
      ),
    );
    
    // Add logging or interceptors if needed
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    return dio;
  }

  @lazySingleton
  WeatherService getWeatherService(Dio dio) => WeatherService(dio);

  @lazySingleton
  GeoService getGeoService(Dio dio) => GeoService(dio);

  @preResolve
  @lazySingleton
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
