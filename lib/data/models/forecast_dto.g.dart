// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForecastDto _$ForecastDtoFromJson(Map<String, dynamic> json) => ForecastDto(
  list: (json['list'] as List<dynamic>?)
      ?.map((e) => ForecastItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  city: json['city'] == null
      ? null
      : ForecastCityDto.fromJson(json['city'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ForecastDtoToJson(ForecastDto instance) =>
    <String, dynamic>{'list': instance.list, 'city': instance.city};

ForecastItemDto _$ForecastItemDtoFromJson(Map<String, dynamic> json) =>
    ForecastItemDto(
      dt: (json['dt'] as num?)?.toInt(),
      main: json['main'] == null
          ? null
          : MainDto.fromJson(json['main'] as Map<String, dynamic>),
      weather: (json['weather'] as List<dynamic>?)
          ?.map(
            (e) => WeatherDescriptionDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      dtTxt: json['dt_txt'] as String?,
    );

Map<String, dynamic> _$ForecastItemDtoToJson(ForecastItemDto instance) =>
    <String, dynamic>{
      'dt': instance.dt,
      'main': instance.main,
      'weather': instance.weather,
      'dt_txt': instance.dtTxt,
    };

ForecastCityDto _$ForecastCityDtoFromJson(Map<String, dynamic> json) =>
    ForecastCityDto(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$ForecastCityDtoToJson(ForecastCityDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'country': instance.country,
    };
