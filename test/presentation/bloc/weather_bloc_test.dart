
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart'; // For Either
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_clean_app/core/error/failures.dart';
import 'package:weather_clean_app/domain/entities/air_quality.dart';
import 'package:weather_clean_app/domain/entities/forecast.dart';
import 'package:weather_clean_app/domain/entities/weather.dart';
import 'package:weather_clean_app/domain/usecases/get_air_quality_usecase.dart';
import 'package:weather_clean_app/domain/usecases/get_current_location_weather_usecase.dart';
import 'package:weather_clean_app/domain/usecases/get_current_weather_usecase.dart';
import 'package:weather_clean_app/domain/usecases/get_forecast_location_usecase.dart';
import 'package:weather_clean_app/domain/usecases/get_forecast_usecase.dart';
import 'package:weather_clean_app/domain/usecases/get_last_city_usecase.dart';
import 'package:weather_clean_app/domain/usecases/save_last_city_usecase.dart';
import 'package:weather_clean_app/presentation/bloc/weather_bloc.dart';
import 'package:weather_clean_app/presentation/bloc/weather_event.dart';
import 'package:weather_clean_app/presentation/bloc/weather_state.dart';

class MockGetCurrentWeatherUseCase extends Mock implements GetCurrentWeatherUseCase {}
class MockGetLastCityUseCase extends Mock implements GetLastCityUseCase {}
class MockSaveLastCityUseCase extends Mock implements SaveLastCityUseCase {}
class MockGetCurrentLocationWeatherUseCase extends Mock implements GetCurrentLocationWeatherUseCase {}
class MockGetForecastUseCase extends Mock implements GetForecastUseCase {}
class MockGetForecastLocationUseCase extends Mock implements GetForecastLocationUseCase {}
class MockGetAirQualityUseCase extends Mock implements GetAirQualityUseCase {}

void main() {
  late WeatherBloc weatherBloc;
  late MockGetCurrentWeatherUseCase mockGetCurrentWeatherUseCase;
  late MockGetLastCityUseCase mockGetLastCityUseCase;
  late MockSaveLastCityUseCase mockSaveLastCityUseCase;
  late MockGetCurrentLocationWeatherUseCase mockGetCurrentLocationWeatherUseCase;
  late MockGetForecastUseCase mockGetForecastUseCase;
  late MockGetForecastLocationUseCase mockGetForecastLocationUseCase;
  late MockGetAirQualityUseCase mockGetAirQualityUseCase;

  setUp(() {
    mockGetCurrentWeatherUseCase = MockGetCurrentWeatherUseCase();
    mockGetLastCityUseCase = MockGetLastCityUseCase();
    mockSaveLastCityUseCase = MockSaveLastCityUseCase();
    mockGetCurrentLocationWeatherUseCase = MockGetCurrentLocationWeatherUseCase();
    mockGetForecastUseCase = MockGetForecastUseCase();
    mockGetForecastLocationUseCase = MockGetForecastLocationUseCase();
    mockGetAirQualityUseCase = MockGetAirQualityUseCase();

    weatherBloc = WeatherBloc(
      mockGetCurrentWeatherUseCase,
      mockGetLastCityUseCase,
      mockSaveLastCityUseCase,
      mockGetCurrentLocationWeatherUseCase,
      mockGetForecastUseCase,
      mockGetForecastLocationUseCase,
      mockGetAirQualityUseCase,
    );
  });

  const tWeather = WeatherEntity(
    cityName: 'Hanoi',
    description: 'Cloudy',
    temperature: 25.0,
    feelsLike: 26.0,
    humidity: 80,
    windSpeed: 10.0,
    iconCode: '04d',
    timezone: 25200,
    lat: 21.0,
    lon: 105.0,
    pressure: 1012,
    visibility: 10000,
    sunrise: 1600000000,
    sunset: 1600050000,
  );

  const tForecast = ForecastEntity(list: [], cityName: 'Hanoi');
  
  // Minimal AQI object
  const tAirQuality = AirQualityEntity(aqiIndex: 1, co: 0, no2: 0, o3: 0, so2: 0, pm2_5: 0, pm10: 0);

  test('initial state should be WeatherInitial', () {
    expect(weatherBloc.state, equals(WeatherInitial()));
  });

  blocTest<WeatherBloc, WeatherState>(
    'emits [WeatherLoading, WeatherLoaded] when GetWeatherForCity is added and API calls succeed',
    build: () {
      when(() => mockGetCurrentWeatherUseCase(any()))
          .thenAnswer((_) async => const Right(tWeather));
      when(() => mockGetForecastUseCase(any()))
          .thenAnswer((_) async => const Right(tForecast));
      when(() => mockGetAirQualityUseCase(any(), any()))
          .thenAnswer((_) async => const Right(tAirQuality));
      when(() => mockSaveLastCityUseCase(any()))
          .thenAnswer((_) async => {});
          
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const GetWeatherForCity('Hanoi')),
    expect: () => [
      WeatherLoading(),
      WeatherLoaded(tWeather, forecast: tForecast, airQuality: tAirQuality),
    ],
    verify: (_) {
      verify(() => mockGetCurrentWeatherUseCase('Hanoi')).called(1);
      verify(() => mockGetForecastUseCase('Hanoi')).called(1);
      verify(() => mockGetAirQualityUseCase(tWeather.lat, tWeather.lon)).called(1);
      verify(() => mockSaveLastCityUseCase('Hanoi')).called(1);
    },
  );

  blocTest<WeatherBloc, WeatherState>(
    'emits [WeatherLoading, WeatherError] when GetWeatherForCity fails for current weather',
    build: () {
      when(() => mockGetCurrentWeatherUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure('Server Error')));
      when(() => mockGetForecastUseCase(any()))
          .thenAnswer((_) async => const Right(tForecast)); // Forecast might succeed independently? Parallel call handling
      
      // Note: In WeatherBloc, if results[0] (Weather) fails, it emits Error immediately.
      
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const GetWeatherForCity('Hanoi')),
    expect: () => [
      WeatherLoading(),
      const WeatherError('Server Error'),
    ],
  );
}
