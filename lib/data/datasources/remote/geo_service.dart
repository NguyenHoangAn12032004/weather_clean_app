import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/city_dto.dart';
import '../../models/find_response_dto.dart';

part 'geo_service.g.dart';

@RestApi(baseUrl: 'https://api.openweathermap.org/')
abstract class GeoService {
  factory GeoService(Dio dio, {String baseUrl}) = _GeoService;

  // Giữ lại Geo Direct nếu cần dùng sau này
  @GET('geo/1.0/direct')
  Future<List<CityDto>> searchCities(
    @Query('q') String query,
    @Query('limit') int limit,
  );

  @GET('data/2.5/find')
  Future<FindResponseDto> findCities(
    @Query('q') String query,
    @Query('type') String type, // 'like'
    @Query('cnt') int count,
  );
}
