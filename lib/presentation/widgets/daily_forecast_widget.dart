import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/forecast.dart';
import 'glass_container.dart';

class DailyForecastWidget extends StatelessWidget {
  final List<ForecastItemEntity> items;

  const DailyForecastWidget({super.key, required this.items});

  List<_DailyData> _processData() {
    final Map<String, List<ForecastItemEntity>> grouped = {};
    
    for (var item in items) {
      final key = DateFormat('yyyy-MM-dd').format(item.dateTime);
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(item);
    }

    final List<_DailyData> dailyList = [];
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    grouped.forEach((key, dayItems) {
      if (key == today) return; // Skip today as we show it in hourly

      double minTemp = 1000;
      double maxTemp = -1000;
      // Simple logic: Pick icon from the middle of the day (noon)
      String iconCode = dayItems[dayItems.length ~/ 2].iconCode;

      for (var item in dayItems) {
        if (item.temperature < minTemp) minTemp = item.temperature;
        if (item.temperature > maxTemp) maxTemp = item.temperature;
      }

      dailyList.add(_DailyData(
        date: dayItems.first.dateTime,
        minTemp: minTemp,
        maxTemp: maxTemp,
        iconCode: iconCode,
      ));
    });

    return dailyList.take(5).toList(); // Ensure only 5 days
  }

  @override
  Widget build(BuildContext context) {
    final dailyData = _processData();

    return GlassContainer(
      opacity: 0.2, // Consistent with Hourly
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           const Text(
            'DỰ BÁO 5 NGÀY TỚI',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
          const SizedBox(height: 5),
          ...dailyData.map((data) => _buildDailyItem(context, data)),
        ],
      ),
    );
  }

  Widget _buildDailyItem(BuildContext context, _DailyData data) {
    final dayName = DateFormat('EEEE', 'vi').format(data.date); // Need localize
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              dayName.replaceFirst(dayName[0], dayName[0].toUpperCase()),
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          
          Expanded(
            flex: 1,
            child: Image.network(
              'https://openweathermap.org/img/wn/${data.iconCode}.png',
              width: 30,
              height: 30,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud, color: Colors.white, size: 20),
            ),
          ),
          
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Text(
                  '${data.minTemp.toStringAsFixed(0)}°',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.orange],
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  '${data.maxTemp.toStringAsFixed(0)}°',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyData {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String iconCode;

  _DailyData({required this.date, required this.minTemp, required this.maxTemp, required this.iconCode});
}
