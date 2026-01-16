import 'package:injectable/injectable.dart';
import '../repositories/weather_repository.dart';

@lazySingleton
class GetLastCityUseCase {
  final WeatherRepository _repository;

  GetLastCityUseCase(this._repository);

  Future<String?> call() async {
    return await _repository.getLastCity();
  }
}
