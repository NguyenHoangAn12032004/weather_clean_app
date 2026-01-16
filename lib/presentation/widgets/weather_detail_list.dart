
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/weather.dart';
import '../../injection.dart'; // For getIt
import '../bloc/settings/settings_cubit.dart';
import '../bloc/settings/settings_state.dart';
import 'glass_container.dart';

class WeatherDetailList extends StatelessWidget {
  final WeatherEntity weather;

  const WeatherDetailList({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: getIt<SettingsCubit>(), // Listen to global settings
      builder: (context, settingsState) {
        // Unit Helpers
        String getTemp(double c) {
           if (settingsState.tempUnit == TemperatureUnit.fahrenheit) {
             final f = (c * 9 / 5) + 32;
             return '${f.toStringAsFixed(0)}°';
           }
           return '${c.toStringAsFixed(0)}°';
        }

        String getWind(double ms) {
           if (settingsState.windUnit == WindSpeedUnit.kilometersPerHour) {
             final kmh = ms * 3.6;
             return '${kmh.toStringAsFixed(1)} km/h';
           }
           return '$ms m/s';
        }

        final items = [
          _DetailItem(
            icon: Icons.water_drop_outlined,
            title: 'Độ ẩm',
            value: '${weather.humidity}%',
            subValue: 'Điểm sương: ${getTemp(weather.temperature - 2)}', // Use converted temp
          ),
          _DetailItem(
            icon: Icons.air,
            title: 'Gió',
            value: getWind(weather.windSpeed),
            subValue: 'Hướng: Đông Nam', 
          ),
          _DetailItem(
            icon: Icons.speed,
            title: 'Áp suất',
            value: '${weather.pressure} hPa',
            subValue: 'Ổn định',
          ),
          _DetailItem(
            icon: Icons.visibility_outlined,
            title: 'Tầm nhìn',
            value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
            subValue: 'Rõ nét',
          ),
          _DetailItem(
            icon: Icons.thermostat,
            title: 'Cảm giác',
            value: getTemp(weather.feelsLike),
            subValue: 'Cao hơn thực tế',
          ),
          _DetailItem(
            icon: Icons.wb_sunny_outlined,
            title: 'UV',
            value: '3', 
            subValue: 'Trung bình',
          ),
        ];

        return SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                width: 110,
                margin: EdgeInsets.only(
                  left: index == 0 ? 0 : 6, 
                  right: index == items.length - 1 ? 0 : 6
                ),
                child: _buildVerticalCard(context, item),
              );
            },
          ),
        );
      }
    );
  }

  Widget _buildVerticalCard(BuildContext context, _DetailItem item) {
    return GlassContainer(
      opacity: 0.15,
      borderRadius: BorderRadius.circular(24), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top: Icon
          Container(
             padding: const EdgeInsets.all(8),
             decoration: BoxDecoration(
               color: Colors.white.withOpacity(0.1),
               shape: BoxShape.circle,
             ),
             child: Icon(item.icon, color: Colors.white, size: 20),
          ),
          
          const SizedBox(height: 10),

          // Middle: Title
          Text(
            item.title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Bottom: Value and Sub
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  item.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15, // Reduced slightly
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.subValue,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailItem {
  final IconData icon;
  final String title;
  final String value;
  final String subValue;

  const _DetailItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.subValue,
  });
}
