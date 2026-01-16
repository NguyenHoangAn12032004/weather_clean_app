import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/city.dart';

part 'city_dto.g.dart';

@JsonSerializable()
class CityDto {
  final String name;
  @JsonKey(name: 'local_names')
  final Map<String, String>? localNames;
  final double lat;
  final double lon;
  final String country;
  final String? state;

  CityDto({
    required this.name,
    this.localNames,
    required this.lat,
    required this.lon,
    required this.country,
    this.state,
  });

  factory CityDto.fromJson(Map<String, dynamic> json) => _$CityDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CityDtoToJson(this);

  CityEntity toEntity() {
    // Ưu tiên lấy tên tiếng Việt nếu có
    final viName = localNames?['vi'];
    return CityEntity(
      name: viName ?? name,
      state: state,
      country: country,
      lat: lat,
      lon: lon,
    );
  }
}
