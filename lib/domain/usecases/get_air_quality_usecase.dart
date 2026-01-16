import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../entities/air_quality.dart';
import '../repositories/weather_repository.dart';

@lazySingleton
class GetAirQualityUseCase {
  final WeatherRepository repository;

  GetAirQualityUseCase(this.repository);

  Future<Either<Failure, AirQualityEntity>> call(double lat, double lon) async {
    return await repository.getAirQuality(lat, lon);
  }
}
