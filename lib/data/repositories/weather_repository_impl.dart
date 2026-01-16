import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/city.dart';
import '../../domain/entities/weather.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/entities/air_quality.dart'; // New
import '../../domain/repositories/weather_repository.dart';
import '../datasources/remote/geo_service.dart';
import '../datasources/remote/weather_service.dart';
import '../datasources/local/weather_local_datasource.dart';

import '../../core/constants/local_cities.dart';


@LazySingleton(as: WeatherRepository)
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherService _weatherService;
  final GeoService _geoService;
  final WeatherLocalDataSource _localDataSource;

  WeatherRepositoryImpl(this._weatherService, this._geoService, this._localDataSource);

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(String city) async {
    try {
      final result = await _weatherService.getCurrentWeather(city);
      return Right(result.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(ServerFailure('API Key không hợp lệ hoặc chưa được kích hoạt.\nVui lòng kiểm tra lại Key hoặc đợi 10-15 phút.'));
      }
      return Left(ServerFailure(e.message ?? 'Lỗi kết nối máy chủ'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeatherByLocation() async {
    try {
      // 1. Check Permissions
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Left(ServerFailure('Location services are disabled.'));
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left(ServerFailure('Location permissions are denied'));
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return const Left(ServerFailure('Location permissions are permanently denied, we cannot request permissions.'));
      } 

      // 2. Get Position
      final position = await Geolocator.getCurrentPosition();

      // 3. Call API
      final result = await _weatherService.getWeatherByCoordinates(position.latitude, position.longitude);
      return Right(result.toEntity());

    } on DioException catch (e) {
       if (e.response?.statusCode == 401) {
        return const Left(ServerFailure('API Key lỗi.'));
      }
      return Left(ServerFailure(e.message ?? 'Lỗi kết nối máy chủ'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ForecastEntity>> getForecast(String city) async {
    try {
      final result = await _weatherService.getForecast(city);
      return Right(result.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(ServerFailure('API Key lỗi.'));
      }
      return Left(ServerFailure(e.message ?? 'Lỗi kết nối máy chủ'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ForecastEntity>> getForecastByLocation() async {
    try {
      // 1. Get Position (Assuming permission checks are done or shared)
      // Note: Ideally permission check should be extracted, but for now we repeat minimal check or assume it's called after getCurrentWeatherByLocation
      // However, to be safe, we re-fetch position
      final position = await Geolocator.getCurrentPosition();

      // 2. Call API
      final result = await _weatherService.getForecastByCoordinates(position.latitude, position.longitude);
      return Right(result.toEntity());

    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Lỗi kết nối máy chủ'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AirQualityEntity>> getAirQuality(double lat, double lon) async {
    try {
      final result = await _weatherService.getAirPollution(lat, lon);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Lỗi kết nối máy chủ'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSavedCities() async {
    try {
      final cities = await _localDataSource.getSavedCities();
      return Right(cities);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addCity(String city) async {
    try {
      await _localDataSource.addCity(city);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeCity(String city) async {
    try {
      await _localDataSource.removeCity(city);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  String _removeDiacritics(String str) {
    var withDia = 'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ';
    var withoutDia = 'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';
    for (int i = 0; i < withDia.length; i++) {
       str = str.replaceAll(withDia[i], withoutDia[i]);
    }
    return str;
  }

  @override
  Future<Either<Failure, List<CityEntity>>> searchCities(String query) async {
    try {
      // CHIẾN THUẬT: "Expanded Hybrid" (Find + Direct Accented + Direct NoAccent)

      final queryNoAccent = _removeDiacritics(query.toLowerCase());
      
      final futures = <Future<List<CityEntity>>>[];

      // 0. LOCAL SUGGESTION (Bypass API Limitation)
      // Tìm trong danh sách cứng các thành phố lớn VN
      final localMatches = majorVNCities.where((city) {
         final nameLower = city.name.toLowerCase();
         final nameNoAccent = _removeDiacritics(nameLower);
         
         // 1. Check contains không dấu
         if (nameNoAccent.contains(queryNoAccent)) {
             // 2. Check dấu (nếu user nhập có dấu)
             if (query.toLowerCase() != queryNoAccent) {
                 // Nếu target không dấu (ít xảy ra vì mình đã sửa local_cities thành có dấu)
                 if (nameLower == nameNoAccent) return true;
                 
                 // Nếu target có dấu -> Phải contains query gốc
                 if (!nameLower.contains(query.toLowerCase())) return false;
             }
             return true;
         }
         return false;
      }).toList();

      // 1. Find API (Cho query >= 3 ký tự)
      if (queryNoAccent.length >= 3) {
        futures.add(
          _geoService.findCities(queryNoAccent, 'like', 50)
            .then((res) => res.list?.map((e) => e.toEntity()).toList() ?? <CityEntity>[])
            .catchError((_) => <CityEntity>[])
        );
      }

      // 2. Direct API (Có dấu - User nhập gì tìm nấy) -> Bắt "Hạ"
      futures.add(
         _geoService.searchCities(query, 50)
            .then((list) => list.map((e) => e.toEntity()).toList())
            .catchError((_) => <CityEntity>[])
      );
      futures.add(
         _geoService.searchCities('$query,VN', 50)
            .then((list) => list.map((e) => e.toEntity()).toList())
            .catchError((_) => <CityEntity>[])
      );

      // 3. Direct API (Không dấu - Fallback quan trọng khi Find Fail hoặc Direct dấu quá strict)
      // VD: Nhập "Hà" (2 ký tự, Find fail).
      // Direct("Hà") -> Ra "Hạ" (Strict).
      // Cần Direct("Ha") -> Để ra "Hanoi".
      if (query != queryNoAccent || queryNoAccent.length < 3) {
         futures.add(
           _geoService.searchCities(queryNoAccent, 50)
              .then((list) => list.map((e) => e.toEntity()).toList())
              .catchError((_) => <CityEntity>[])
         );
         futures.add(
           _geoService.searchCities('$queryNoAccent,VN', 50)
              .then((list) => list.map((e) => e.toEntity()).toList())
              .catchError((_) => <CityEntity>[])
         );
      }

      // Chờ tất cả xong
      final results = await Future.wait(futures);
      
      final allEntities = <CityEntity>[...localMatches];
      for (var list in results) {
        allEntities.addAll(list);
      }

      if (allEntities.isEmpty) {
         return const Right([]);
      }
      
      // Merge duplicates (Unique by lat/lon)
      final uniqueEntities = <String, CityEntity>{};
      for (var entity in allEntities) {
         final key = '${entity.lat.toStringAsFixed(4)}_${entity.lon.toStringAsFixed(4)}';
         if (!uniqueEntities.containsKey(key)) {
           uniqueEntities[key] = entity;
         }
      }

      // ---------------------------------------------------------
      // LỌC THÔNG MINH (Smart Accent Filter) trên Entity
      // ---------------------------------------------------------
      final queryLower = query.toLowerCase(); 

      final filteredEntities = uniqueEntities.values.where((entity) {
        final nameLower = entity.name.toLowerCase();
        final nameNoAccent = _removeDiacritics(nameLower);

        // Bước 1: Phải chứa từ khóa (không dấu)
        bool baseMatch = nameNoAccent.contains(queryNoAccent);
        
        if (!baseMatch) {
            // Check displayName (cho chắc)
            if (_removeDiacritics(entity.displayName.toLowerCase()).contains(queryNoAccent)) {
               baseMatch = true;
            }
        }

        if (!baseMatch) return false;

        // Bước 2: Kiểm tra dấu (Negative Check)
        if (queryLower != queryNoAccent) { 
           // Tên Entity có dấu không?
           if (nameLower == nameNoAccent) {
              // Tên không dấu -> Giữ (An toàn, chấp nhận Hanoi)
           } else {
              // Tên có dấu (Hạ, Hà Nội...)
              // Nếu không chứa từ khóa có dấu -> Loại (Hạ != Hà)
              if (!nameLower.contains(queryLower)) {
                 return false; 
              }
           }
        }
        
        return true;
      });

      final entities = filteredEntities.toList();
      entities.sort((a, b) {
         // Logic Sort cũ...
        final aName = a.name.toLowerCase();
        final bName = b.name.toLowerCase();
        
        // Ưu tiên VN
        final aCountry = a.country;
        final bCountry = b.country;
        final aVN = aCountry == 'VN';
        final bVN = bCountry == 'VN';
        if (aVN && !bVN) return -1;
        if (!aVN && bVN) return 1;

        // Ưu tiên startsWith query gốc
        final aStarts = aName.startsWith(queryLower);
        final bStarts = bName.startsWith(queryLower);
        if (aStarts && !bStarts) return -1;
        if (!aStarts && bStarts) return 1;

        return 0;
      });

      return Right(entities);

    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 404) {
        return const Right([]);
      }
      if (e.response?.statusCode == 401) {
         return const Left(ServerFailure('API Key lỗi.'));
      }
      return Left(ServerFailure(e.message ?? 'Lỗi tìm kiếm'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<String?> getLastCity() async {
    return _localDataSource.getLastCity();
  }

  @override
  Future<void> saveLastCity(String city) async {
    return _localDataSource.saveLastCity(city);
  }
}
