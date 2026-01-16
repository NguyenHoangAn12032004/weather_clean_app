import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/error/failures.dart';
import '../entities/city.dart';
import '../repositories/weather_repository.dart';

@lazySingleton
class SearchCitiesUseCase {
  final WeatherRepository _repository;

  SearchCitiesUseCase(this._repository);

  Future<Either<Failure, List<CityEntity>>> call(String query) async {
    return await _repository.searchCities(query);
  }
}
