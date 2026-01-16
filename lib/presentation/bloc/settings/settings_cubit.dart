
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

@lazySingleton
class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences _prefs;

  SettingsCubit(this._prefs) : super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final tempIndex = _prefs.getInt('temp_unit') ?? 0;
    final windIndex = _prefs.getInt('wind_unit') ?? 0;

    emit(SettingsState(
      tempUnit: TemperatureUnit.values[tempIndex],
      windUnit: WindSpeedUnit.values[windIndex],
    ));
  }

  Future<void> setTempUnit(TemperatureUnit unit) async {
    await _prefs.setInt('temp_unit', unit.index);
    emit(state.copyWith(tempUnit: unit));
  }

  Future<void> setWindUnit(WindSpeedUnit unit) async {
    await _prefs.setInt('wind_unit', unit.index);
    emit(state.copyWith(windUnit: unit));
  }
}
