// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherDto _$WeatherDtoFromJson(Map<String, dynamic> json) => WeatherDto(
  weather: (json['weather'] as List<dynamic>?)
      ?.map((e) => WeatherDescriptionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  main: json['main'] == null
      ? null
      : MainDto.fromJson(json['main'] as Map<String, dynamic>),
  wind: json['wind'] == null
      ? null
      : WindDto.fromJson(json['wind'] as Map<String, dynamic>),
  name: json['name'] as String?,
  dt: (json['dt'] as num?)?.toInt(),
  timezone: (json['timezone'] as num?)?.toInt(),
  coord: json['coord'] == null
      ? null
      : CoordDto.fromJson(json['coord'] as Map<String, dynamic>),
  visibility: (json['visibility'] as num?)?.toInt(),
  sys: json['sys'] == null
      ? null
      : SysDto.fromJson(json['sys'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WeatherDtoToJson(WeatherDto instance) =>
    <String, dynamic>{
      'weather': instance.weather,
      'main': instance.main,
      'wind': instance.wind,
      'name': instance.name,
      'dt': instance.dt,
      'timezone': instance.timezone,
      'coord': instance.coord,
      'visibility': instance.visibility,
      'sys': instance.sys,
    };

WeatherDescriptionDto _$WeatherDescriptionDtoFromJson(
  Map<String, dynamic> json,
) => WeatherDescriptionDto(
  id: (json['id'] as num?)?.toInt(),
  main: json['main'] as String?,
  description: json['description'] as String?,
  icon: json['icon'] as String?,
);

Map<String, dynamic> _$WeatherDescriptionDtoToJson(
  WeatherDescriptionDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'main': instance.main,
  'description': instance.description,
  'icon': instance.icon,
};

MainDto _$MainDtoFromJson(Map<String, dynamic> json) => MainDto(
  temp: (json['temp'] as num?)?.toDouble(),
  feelsLike: (json['feels_like'] as num?)?.toDouble(),
  tempMin: (json['temp_min'] as num?)?.toDouble(),
  tempMax: (json['temp_max'] as num?)?.toDouble(),
  pressure: (json['pressure'] as num?)?.toInt(),
  humidity: (json['humidity'] as num?)?.toInt(),
);

Map<String, dynamic> _$MainDtoToJson(MainDto instance) => <String, dynamic>{
  'temp': instance.temp,
  'feels_like': instance.feelsLike,
  'temp_min': instance.tempMin,
  'temp_max': instance.tempMax,
  'pressure': instance.pressure,
  'humidity': instance.humidity,
};

WindDto _$WindDtoFromJson(Map<String, dynamic> json) => WindDto(
  speed: (json['speed'] as num?)?.toDouble(),
  deg: (json['deg'] as num?)?.toInt(),
);

Map<String, dynamic> _$WindDtoToJson(WindDto instance) => <String, dynamic>{
  'speed': instance.speed,
  'deg': instance.deg,
};

CoordDto _$CoordDtoFromJson(Map<String, dynamic> json) => CoordDto(
  lon: (json['lon'] as num?)?.toDouble(),
  lat: (json['lat'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CoordDtoToJson(CoordDto instance) => <String, dynamic>{
  'lon': instance.lon,
  'lat': instance.lat,
};

SysDto _$SysDtoFromJson(Map<String, dynamic> json) => SysDto(
  type: (json['type'] as num?)?.toInt(),
  id: (json['id'] as num?)?.toInt(),
  country: json['country'] as String?,
  sunrise: (json['sunrise'] as num?)?.toInt(),
  sunset: (json['sunset'] as num?)?.toInt(),
);

Map<String, dynamic> _$SysDtoToJson(SysDto instance) => <String, dynamic>{
  'type': instance.type,
  'id': instance.id,
  'country': instance.country,
  'sunrise': instance.sunrise,
  'sunset': instance.sunset,
};
