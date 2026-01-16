import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../repositories/weather_repository.dart';

@lazySingleton
class GetSavedCitiesUseCase {
  final WeatherRepository repository;

  GetSavedCitiesUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getSavedCities();
  }
}
