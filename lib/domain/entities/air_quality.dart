import 'package:equatable/equatable.dart';

class AirQualityEntity extends Equatable {
  final int aqiIndex; // 1 = Good, 2 = Fair, 3 = Moderate, 4 = Poor, 5 = Very Poor
  final double co;
  final double no2;
  final double o3;
  final double so2;
  final double pm2_5;
  final double pm10;

  const AirQualityEntity({
    required this.aqiIndex,
    required this.co,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm2_5,
    required this.pm10,
  });

  @override
  List<Object?> get props => [aqiIndex, co, no2, o3, so2, pm2_5, pm10];
}
