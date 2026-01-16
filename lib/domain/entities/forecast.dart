import 'package:equatable/equatable.dart';

class ForecastEntity extends Equatable {
  final List<ForecastItemEntity> list;
  final String cityName;

  const ForecastEntity({
    required this.list,
    required this.cityName,
  });

  @override
  List<Object?> get props => [list, cityName];
}

class ForecastItemEntity extends Equatable {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String iconCode;

  const ForecastItemEntity({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.iconCode,
  });

  @override
  List<Object?> get props => [dateTime, temperature, description, iconCode];
}
