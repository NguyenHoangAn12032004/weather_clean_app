import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../entities/forecast.dart';
import '../repositories/weather_repository.dart';

@lazySingleton
class GetForecastUseCase {
  final WeatherRepository repository;

  GetForecastUseCase(this.repository);

  Future<Either<Failure, ForecastEntity>> call(String city) async {
    return await repository.getForecast(city);
  }
}
