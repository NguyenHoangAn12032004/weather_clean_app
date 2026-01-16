import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WeatherLocalDataSource {
  Future<void> saveLastCity(String city);
  Future<String?> getLastCity();
  // Multi-City support
  Future<List<String>> getSavedCities();
  Future<void> addCity(String city);
  Future<void> removeCity(String city);
}

const String cachedCityKey = 'CACHED_CITY';
const String savedCitiesKey = 'SAVED_CITIES_LIST';

@LazySingleton(as: WeatherLocalDataSource)
class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences _sharedPreferences;

  WeatherLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<String?> getLastCity() async {
    return _sharedPreferences.getString(cachedCityKey);
  }

  @override
  Future<void> saveLastCity(String city) async {
    await _sharedPreferences.setString(cachedCityKey, city);
  }

  @override
  Future<List<String>> getSavedCities() async {
    return _sharedPreferences.getStringList(savedCitiesKey) ?? [];
  }

  @override
  Future<void> addCity(String city) async {
    final cities = await getSavedCities();
    if (!cities.contains(city)) {
      cities.add(city);
      await _sharedPreferences.setStringList(savedCitiesKey, cities);
    }
  }

  @override
  Future<void> removeCity(String city) async {
    final cities = await getSavedCities();
    if (cities.contains(city)) {
      cities.remove(city);
      await _sharedPreferences.setStringList(savedCitiesKey, cities);
    }
  }
}
