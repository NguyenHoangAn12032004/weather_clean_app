import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/weather.dart';

part 'weather_dto.g.dart';

@JsonSerializable()
class WeatherDto {
  final List<WeatherDescriptionDto>? weather;
  final MainDto? main;
  final WindDto? wind;
  final String? name;
  final int? dt;
  final int? timezone;
  final CoordDto? coord;
  final int? visibility; // New
  final SysDto? sys; // New

  WeatherDto({this.weather, this.main, this.wind, this.name, this.dt, this.timezone, this.coord, this.visibility, this.sys});

  factory WeatherDto.fromJson(Map<String, dynamic> json) => _$WeatherDtoFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherDtoToJson(this);

  WeatherEntity toEntity() {
    return WeatherEntity(
      cityName: name ?? 'Unknown',
      description: weather?.first.description ?? '',
      temperature: main?.temp ?? 0.0,
      feelsLike: main?.feelsLike ?? 0.0,
      humidity: main?.humidity ?? 0,
      windSpeed: wind?.speed ?? 0.0,
      iconCode: weather?.first.icon ?? '',
      timezone: timezone ?? 0,
      lat: coord?.lat ?? 0.0,
      lon: coord?.lon ?? 0.0,
      pressure: main?.pressure ?? 0, // New
      visibility: visibility ?? 0, // New
      sunrise: sys?.sunrise ?? 0, // New
      sunset: sys?.sunset ?? 0, // New
    );
  }
}

@JsonSerializable()
class WeatherDescriptionDto {
  final int? id;
  final String? main;
  final String? description;
  final String? icon;

  WeatherDescriptionDto({this.id, this.main, this.description, this.icon});

  factory WeatherDescriptionDto.fromJson(Map<String, dynamic> json) => _$WeatherDescriptionDtoFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherDescriptionDtoToJson(this);
}

@JsonSerializable()
class MainDto {
  final double? temp;
  @JsonKey(name: 'feels_like')
  final double? feelsLike;
  @JsonKey(name: 'temp_min')
  final double? tempMin;
  @JsonKey(name: 'temp_max')
  final double? tempMax;
  final int? pressure;
  final int? humidity;

  MainDto({this.temp, this.feelsLike, this.tempMin, this.tempMax, this.pressure, this.humidity});

  factory MainDto.fromJson(Map<String, dynamic> json) => _$MainDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MainDtoToJson(this);
}

@JsonSerializable()
class WindDto {
  final double? speed;
  final int? deg;

  WindDto({this.speed, this.deg});

  factory WindDto.fromJson(Map<String, dynamic> json) => _$WindDtoFromJson(json);
  Map<String, dynamic> toJson() => _$WindDtoToJson(this);
}

@JsonSerializable()
class CoordDto {
  final double? lon;
  final double? lat;

  CoordDto({this.lon, this.lat});

  factory CoordDto.fromJson(Map<String, dynamic> json) => _$CoordDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CoordDtoToJson(this);
}

@JsonSerializable()
class SysDto {
  final int? type;
  final int? id;
  final String? country;
  final int? sunrise;
  final int? sunset;

  SysDto({this.type, this.id, this.country, this.sunrise, this.sunset});

  factory SysDto.fromJson(Map<String, dynamic> json) => _$SysDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SysDtoToJson(this);
}
