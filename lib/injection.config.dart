// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'core/network/network_module.dart' as _i550;
import 'data/datasources/local/weather_local_datasource.dart' as _i510;
import 'data/datasources/remote/geo_service.dart' as _i340;
import 'data/datasources/remote/weather_service.dart' as _i212;
import 'data/repositories/weather_repository_impl.dart' as _i807;
import 'domain/repositories/weather_repository.dart' as _i690;
import 'domain/usecases/add_city_usecase.dart' as _i166;
import 'domain/usecases/get_air_quality_usecase.dart' as _i988;
import 'domain/usecases/get_current_location_weather_usecase.dart' as _i668;
import 'domain/usecases/get_current_weather_usecase.dart' as _i180;
import 'domain/usecases/get_forecast_location_usecase.dart' as _i975;
import 'domain/usecases/get_forecast_usecase.dart' as _i437;
import 'domain/usecases/get_last_city_usecase.dart' as _i28;
import 'domain/usecases/get_saved_cities_usecase.dart' as _i744;
import 'domain/usecases/remove_city_usecase.dart' as _i662;
import 'domain/usecases/save_last_city_usecase.dart' as _i50;
import 'domain/usecases/search_cities_usecase.dart' as _i171;
import 'presentation/bloc/city_list_bloc.dart' as _i909;
import 'presentation/bloc/search_bloc.dart' as _i306;
import 'presentation/bloc/weather_bloc.dart' as _i868;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio);
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => networkModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i212.WeatherService>(
      () => networkModule.getWeatherService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i340.GeoService>(
      () => networkModule.getGeoService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i510.WeatherLocalDataSource>(
      () => _i510.WeatherLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i690.WeatherRepository>(
      () => _i807.WeatherRepositoryImpl(
        gh<_i212.WeatherService>(),
        gh<_i340.GeoService>(),
        gh<_i510.WeatherLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i166.AddCityUseCase>(
      () => _i166.AddCityUseCase(gh<_i690.WeatherRepository>()),
    );
    gh.lazySingleton<_i988.GetAirQualityUseCase>(
      () => _i988.GetAirQualityUseCase(gh<_i690.WeatherRepository>()),
    );
    gh.lazySingleton<_i668.GetCurrentLocationWeatherUseCase>(
      () =>
          _i668.GetCurrentLocationWeatherUseCase(gh<_i690.WeatherRepository>()),
    );
    gh.lazySingleton<_i975.GetForecastLocationUseCase>(
      () => _i975.GetForecastLocationUseCase(gh<_i690.WeatherRepository>()),
    );
    gh.lazySingleton<_i437.GetForecastUseCase>(
      () => _i437.GetForecastUseCase(gh<_i690.WeatherRepository>()),
    );
    gh.lazySingleton<_i744.GetSavedCitiesUseCase>(
      () => _i744.GetSavedCitiesUseCase(gh<_i690.WeatherRepository>()),
    );
    gh.lazySingleton<_i662.RemoveCityUseCase>(
      () => _i662.RemoveCityUseCase(gh<_i690.WeatherRepository>()),
    );
    gh.factory<_i909.CityListBloc>(
      () => _i909.CityListBloc(
        gh<_i744.GetSavedCitiesUseCase>(),
        gh<_i166.AddCityUseCase>(),
        gh<_i662.RemoveCityUseCase>(),
      ),
    );
    gh.lazySingleton<_i180.GetCurrentWeatherUseCase>(
      () => _i180.GetCurrentWeatherUseCase(gh<_i690.WeatherRepository>()),
    );
    gh.lazySingleton<_i28.GetLastCityUseCase>(
      () => _i28.GetLastCityUseCase(gh<_i690.WeatherRepository>()),
    );
    gh.lazySingleton<_i50.SaveLastCityUseCase>(
      () => _i50.SaveLastCityUseCase(gh<_i690.WeatherRepository>()),
    );
    gh.lazySingleton<_i171.SearchCitiesUseCase>(
      () => _i171.SearchCitiesUseCase(gh<_i690.WeatherRepository>()),
    );
    gh.factory<_i306.SearchBloc>(
      () => _i306.SearchBloc(gh<_i171.SearchCitiesUseCase>()),
    );
    gh.factory<_i868.WeatherBloc>(
      () => _i868.WeatherBloc(
        gh<_i180.GetCurrentWeatherUseCase>(),
        gh<_i28.GetLastCityUseCase>(),
        gh<_i50.SaveLastCityUseCase>(),
        gh<_i668.GetCurrentLocationWeatherUseCase>(),
        gh<_i437.GetForecastUseCase>(),
        gh<_i975.GetForecastLocationUseCase>(),
        gh<_i988.GetAirQualityUseCase>(),
      ),
    );
    return this;
  }
}

class _$NetworkModule extends _i550.NetworkModule {}
