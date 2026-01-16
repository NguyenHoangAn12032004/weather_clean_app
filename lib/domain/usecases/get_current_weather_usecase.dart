import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/error/failures.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

@lazySingleton
class GetCurrentWeatherUseCase {
  final WeatherRepository _repository;

  GetCurrentWeatherUseCase(this._repository);

  Future<Either<Failure, WeatherEntity>> call(String city) async {
    return await _repository.getCurrentWeather(city);
  }
}
