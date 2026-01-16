// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindResponseDto _$FindResponseDtoFromJson(Map<String, dynamic> json) =>
    FindResponseDto(
      message: json['message'] as String?,
      cod: json['cod'] as String?,
      count: (json['count'] as num?)?.toInt(),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => FindCityDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FindResponseDtoToJson(FindResponseDto instance) =>
    <String, dynamic>{
      'message': instance.message,
      'cod': instance.cod,
      'count': instance.count,
      'list': instance.list,
    };

FindCityDto _$FindCityDtoFromJson(Map<String, dynamic> json) => FindCityDto(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  coord: json['coord'] == null
      ? null
      : FindCoordDto.fromJson(json['coord'] as Map<String, dynamic>),
  sys: json['sys'] == null
      ? null
      : FindSysDto.fromJson(json['sys'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FindCityDtoToJson(FindCityDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'coord': instance.coord,
      'sys': instance.sys,
    };

FindCoordDto _$FindCoordDtoFromJson(Map<String, dynamic> json) => FindCoordDto(
  lat: (json['lat'] as num?)?.toDouble(),
  lon: (json['lon'] as num?)?.toDouble(),
);

Map<String, dynamic> _$FindCoordDtoToJson(FindCoordDto instance) =>
    <String, dynamic>{'lat': instance.lat, 'lon': instance.lon};

FindSysDto _$FindSysDtoFromJson(Map<String, dynamic> json) =>
    FindSysDto(country: json['country'] as String?);

Map<String, dynamic> _$FindSysDtoToJson(FindSysDto instance) =>
    <String, dynamic>{'country': instance.country};
