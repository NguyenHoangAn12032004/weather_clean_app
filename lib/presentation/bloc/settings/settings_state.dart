
import 'package:equatable/equatable.dart';

enum TemperatureUnit { celsius, fahrenheit }
enum WindSpeedUnit { metersPerSecond, kilometersPerHour }

class SettingsState extends Equatable {
  final TemperatureUnit tempUnit;
  final WindSpeedUnit windUnit;

  const SettingsState({
    this.tempUnit = TemperatureUnit.celsius,
    this.windUnit = WindSpeedUnit.metersPerSecond,
  });

  SettingsState copyWith({
    TemperatureUnit? tempUnit,
    WindSpeedUnit? windUnit,
  }) {
    return SettingsState(
      tempUnit: tempUnit ?? this.tempUnit,
      windUnit: windUnit ?? this.windUnit,
    );
  }

  @override
  List<Object?> get props => [tempUnit, windUnit];
}
