// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityDto _$CityDtoFromJson(Map<String, dynamic> json) => CityDto(
  name: json['name'] as String,
  localNames: (json['local_names'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
  country: json['country'] as String,
  state: json['state'] as String?,
);

Map<String, dynamic> _$CityDtoToJson(CityDto instance) => <String, dynamic>{
  'name': instance.name,
  'local_names': instance.localNames,
  'lat': instance.lat,
  'lon': instance.lon,
  'country': instance.country,
  'state': instance.state,
};
