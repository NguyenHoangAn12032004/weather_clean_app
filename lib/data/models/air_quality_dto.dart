import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/air_quality.dart';

part 'air_quality_dto.g.dart';

@JsonSerializable()
class AirQualityDto {
  final List<AirPollutionListDto>? list;

  AirQualityDto({this.list});

  factory AirQualityDto.fromJson(Map<String, dynamic> json) => _$AirQualityDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AirQualityDtoToJson(this);

  AirQualityEntity toEntity() {
    final item = list?.first;
    final components = item?.components;

    return AirQualityEntity(
      aqiIndex: item?.main?.aqi ?? 0,
      co: components?.co ?? 0.0,
      no2: components?.no2 ?? 0.0,
      o3: components?.o3 ?? 0.0,
      so2: components?.so2 ?? 0.0,
      pm2_5: components?.pm2_5 ?? 0.0,
      pm10: components?.pm10 ?? 0.0,
    );
  }
}

@JsonSerializable()
class AirPollutionListDto {
  final AirMainDto? main;
  final AirComponentsDto? components;
  final int? dt;

  AirPollutionListDto({this.main, this.components, this.dt});

  factory AirPollutionListDto.fromJson(Map<String, dynamic> json) => _$AirPollutionListDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AirPollutionListDtoToJson(this);
}

@JsonSerializable()
class AirMainDto {
  final int? aqi;

  AirMainDto({this.aqi});

  factory AirMainDto.fromJson(Map<String, dynamic> json) => _$AirMainDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AirMainDtoToJson(this);
}

@JsonSerializable()
class AirComponentsDto {
  final double? co;
  final double? no;
  final double? no2;
  final double? o3;
  final double? so2;
  @JsonKey(name: 'pm2_5')
  final double? pm2_5;
  final double? pm10;
  final double? nh3;

  AirComponentsDto({this.co, this.no, this.no2, this.o3, this.so2, this.pm2_5, this.pm10, this.nh3});

  factory AirComponentsDto.fromJson(Map<String, dynamic> json) => _$AirComponentsDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AirComponentsDtoToJson(this);
}
