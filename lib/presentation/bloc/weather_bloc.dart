import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_current_weather_usecase.dart';
import '../../domain/usecases/get_last_city_usecase.dart';
import '../../domain/usecases/save_last_city_usecase.dart';
import '../../domain/usecases/get_current_location_weather_usecase.dart';
import '../../domain/usecases/get_forecast_usecase.dart'; 
import '../../domain/usecases/get_forecast_location_usecase.dart'; 
import '../../domain/usecases/get_air_quality_usecase.dart'; // New
import 'weather_event.dart';
import 'weather_state.dart';

@injectable
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeatherUseCase _getCurrentWeatherUseCase;
  final GetLastCityUseCase _getLastCityUseCase;
  final SaveLastCityUseCase _saveLastCityUseCase;
  final GetCurrentLocationWeatherUseCase _getCurrentLocationWeatherUseCase;
  final GetForecastUseCase _getForecastUseCase; 
  final GetForecastLocationUseCase _getForecastLocationUseCase; 
  final GetAirQualityUseCase _getAirQualityUseCase; // New

  WeatherBloc(
    this._getCurrentWeatherUseCase,
    this._getLastCityUseCase,
    this._saveLastCityUseCase,
    this._getCurrentLocationWeatherUseCase,
    this._getForecastUseCase, 
    this._getForecastLocationUseCase, 
    this._getAirQualityUseCase, // New
  ) : super(WeatherInitial()) {
    on<GetWeatherForCity>(_onGetWeatherForCity);
    on<LoadSavedCity>(_onLoadSavedCity);
    on<GetWeatherForLocation>(_onGetWeatherForLocation);
  }

  Future<void> _onLoadSavedCity(
    LoadSavedCity event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    final lastCity = await _getLastCityUseCase();
    if (lastCity != null && lastCity.isNotEmpty) {
      add(GetWeatherForCity(lastCity));
    } else {
      // Mặc định là GPS nếu chưa lưu (First run)
      add(GetWeatherForLocation());
    }
  }

  Future<void> _onGetWeatherForCity(
    GetWeatherForCity event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    
    // Call Parallel: Current Weather + Forecast
    final results = await Future.wait([
       _getCurrentWeatherUseCase(event.city),
       _getForecastUseCase(event.city),
    ]);
    
    final weatherResult = results[0] as dynamic; // Dart quirks with List<Either>
    final forecastResult = results[1] as dynamic;

    await weatherResult.fold(
      (failure) => emit(WeatherError(failure.message)),
      (weather) async { // weather is WeatherEntity
         // Check forecast
         final forecast = forecastResult.fold(
            (l) => null, 
            (r) => r
         );
         
         // Fetch AQI sequentially (needs lat/lon from weather)
         final aqiResult = await _getAirQualityUseCase(weather.lat, weather.lon);
         final airQuality = aqiResult.fold((l) => null, (r) => r);

        emit(WeatherLoaded(weather, forecast: forecast, airQuality: airQuality));
        _saveLastCityUseCase(weather.cityName);
      },
    );
  }

  Future<void> _onGetWeatherForLocation(
    GetWeatherForLocation event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());

    // Call Parallel
    final results = await Future.wait([
       _getCurrentLocationWeatherUseCase(),
       _getForecastLocationUseCase(),
    ]);

    final weatherResult = results[0] as dynamic; 
    final forecastResult = results[1] as dynamic;

    await weatherResult.fold(
      (failure) => emit(WeatherError(failure.message)),
      (weather) async {
        final forecast = forecastResult.fold(
            (l) => null, 
            (r) => r
         );
         
         // Fetch AQI
         final aqiResult = await _getAirQualityUseCase(weather.lat, weather.lon);
         final airQuality = aqiResult.fold((l) => null, (r) => r);

        emit(WeatherLoaded(weather, forecast: forecast, airQuality: airQuality));
        _saveLastCityUseCase(weather.cityName);
      },
    );
  }
}
