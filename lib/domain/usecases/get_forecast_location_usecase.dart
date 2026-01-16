import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../entities/forecast.dart';
import '../repositories/weather_repository.dart';

@lazySingleton
class GetForecastLocationUseCase {
  final WeatherRepository repository;

  GetForecastLocationUseCase(this.repository);

  Future<Either<Failure, ForecastEntity>> call() async {
    return await repository.getForecastByLocation();
  }
}
