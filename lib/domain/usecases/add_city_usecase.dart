import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../repositories/weather_repository.dart';

@lazySingleton
class AddCityUseCase {
  final WeatherRepository repository;

  AddCityUseCase(this.repository);

  Future<Either<Failure, void>> call(String city) async {
    return await repository.addCity(city);
  }
}
