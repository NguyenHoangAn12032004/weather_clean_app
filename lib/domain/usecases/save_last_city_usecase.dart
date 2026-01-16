import 'package:injectable/injectable.dart';
import '../repositories/weather_repository.dart';

@lazySingleton
class SaveLastCityUseCase {
  final WeatherRepository _repository;

  SaveLastCityUseCase(this._repository);

  Future<void> call(String city) async {
    return await _repository.saveLastCity(city);
  }
}
