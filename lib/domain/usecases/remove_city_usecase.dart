import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../repositories/weather_repository.dart';

@lazySingleton
class RemoveCityUseCase {
  final WeatherRepository repository;

  RemoveCityUseCase(this.repository);

  Future<Either<Failure, void>> call(String city) async {
    return await repository.removeCity(city);
  }
}
