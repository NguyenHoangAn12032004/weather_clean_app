import 'package:json_annotation/json_annotation.dart';
import 'weather_dto.dart';
import '../../domain/entities/forecast.dart';

part 'forecast_dto.g.dart';

@JsonSerializable()
class ForecastDto {
  final List<ForecastItemDto>? list;
  final ForecastCityDto? city;

  ForecastDto({this.list, this.city});

  factory ForecastDto.fromJson(Map<String, dynamic> json) => _$ForecastDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ForecastDtoToJson(this);

  ForecastEntity toEntity() {
    return ForecastEntity(
      cityName: city?.name ?? '',
      list: list?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

@JsonSerializable()
class ForecastItemDto {
  final int? dt;
  final MainDto? main;
  final List<WeatherDescriptionDto>? weather;
  @JsonKey(name: 'dt_txt')
  final String? dtTxt;

  ForecastItemDto({this.dt, this.main, this.weather, this.dtTxt});

  factory ForecastItemDto.fromJson(Map<String, dynamic> json) => _$ForecastItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ForecastItemDtoToJson(this);

  ForecastItemEntity toEntity() {
    return ForecastItemEntity(
      dateTime: DateTime.fromMillisecondsSinceEpoch((dt ?? 0) * 1000),
      temperature: main?.temp ?? 0.0,
      description: weather?.first.description ?? '',
      iconCode: weather?.first.icon ?? '',
    );
  }
}

@JsonSerializable()
class ForecastCityDto {
  final int? id;
  final String? name;
  final String? country;

  ForecastCityDto({this.id, this.name, this.country});

  factory ForecastCityDto.fromJson(Map<String, dynamic> json) => _$ForecastCityDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ForecastCityDtoToJson(this);
}
