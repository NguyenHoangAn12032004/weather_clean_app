import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

@lazySingleton
class GetCurrentLocationWeatherUseCase {
  final WeatherRepository repository;

  GetCurrentLocationWeatherUseCase(this.repository);

  Future<Either<Failure, WeatherEntity>> call() async {
    return await repository.getCurrentWeatherByLocation();
  }
}
