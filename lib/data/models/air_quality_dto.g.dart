// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'air_quality_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirQualityDto _$AirQualityDtoFromJson(Map<String, dynamic> json) =>
    AirQualityDto(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => AirPollutionListDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AirQualityDtoToJson(AirQualityDto instance) =>
    <String, dynamic>{'list': instance.list};

AirPollutionListDto _$AirPollutionListDtoFromJson(Map<String, dynamic> json) =>
    AirPollutionListDto(
      main: json['main'] == null
          ? null
          : AirMainDto.fromJson(json['main'] as Map<String, dynamic>),
      components: json['components'] == null
          ? null
          : AirComponentsDto.fromJson(
              json['components'] as Map<String, dynamic>,
            ),
      dt: (json['dt'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AirPollutionListDtoToJson(
  AirPollutionListDto instance,
) => <String, dynamic>{
  'main': instance.main,
  'components': instance.components,
  'dt': instance.dt,
};

AirMainDto _$AirMainDtoFromJson(Map<String, dynamic> json) =>
    AirMainDto(aqi: (json['aqi'] as num?)?.toInt());

Map<String, dynamic> _$AirMainDtoToJson(AirMainDto instance) =>
    <String, dynamic>{'aqi': instance.aqi};

AirComponentsDto _$AirComponentsDtoFromJson(Map<String, dynamic> json) =>
    AirComponentsDto(
      co: (json['co'] as num?)?.toDouble(),
      no: (json['no'] as num?)?.toDouble(),
      no2: (json['no2'] as num?)?.toDouble(),
      o3: (json['o3'] as num?)?.toDouble(),
      so2: (json['so2'] as num?)?.toDouble(),
      pm2_5: (json['pm2_5'] as num?)?.toDouble(),
      pm10: (json['pm10'] as num?)?.toDouble(),
      nh3: (json['nh3'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AirComponentsDtoToJson(AirComponentsDto instance) =>
    <String, dynamic>{
      'co': instance.co,
      'no': instance.no,
      'no2': instance.no2,
      'o3': instance.o3,
      'so2': instance.so2,
      'pm2_5': instance.pm2_5,
      'pm10': instance.pm10,
      'nh3': instance.nh3,
    };
