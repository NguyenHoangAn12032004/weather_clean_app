import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/city.dart';

part 'find_response_dto.g.dart';

@JsonSerializable()
class FindResponseDto {
  final String? message;
  final String? cod;
  final int? count;
  final List<FindCityDto>? list;

  FindResponseDto({this.message, this.cod, this.count, this.list});

  factory FindResponseDto.fromJson(Map<String, dynamic> json) => _$FindResponseDtoFromJson(json);
}

@JsonSerializable()
class FindCityDto {
  final int? id;
  final String name;
  final FindCoordDto? coord;
  final FindSysDto? sys;

  FindCityDto({this.id, required this.name, this.coord, this.sys});

  factory FindCityDto.fromJson(Map<String, dynamic> json) => _$FindCityDtoFromJson(json);

  CityEntity toEntity() {
    return CityEntity(
      name: name,
      state: '', // Find API không trả về state
      country: sys?.country ?? '',
      lat: coord?.lat ?? 0.0,
      lon: coord?.lon ?? 0.0,
    );
  }
}

@JsonSerializable()
class FindCoordDto {
  final double? lat;
  final double? lon;

  FindCoordDto({this.lat, this.lon});

  factory FindCoordDto.fromJson(Map<String, dynamic> json) => _$FindCoordDtoFromJson(json);
}

@JsonSerializable()
class FindSysDto {
  final String? country;

  FindSysDto({this.country});

  factory FindSysDto.fromJson(Map<String, dynamic> json) => _$FindSysDtoFromJson(json);
}
