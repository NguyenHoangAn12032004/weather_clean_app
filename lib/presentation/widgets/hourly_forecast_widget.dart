import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/forecast.dart';
import 'glass_container.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<ForecastItemEntity> items;

  const HourlyForecastWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // Take first 8 items (~24 hours)
    final hourlyItems = items.take(8).toList();

    return GlassContainer(
      opacity: 0.2, // Darker glass for better contrast
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DỰ BÁO TỪNG GIỜ (3h/lần)', // Localized label
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hourlyItems.length,
              itemBuilder: (context, index) {
                final item = hourlyItems[index];
                final time = DateFormat('HH:mm').format(item.dateTime);
                
                return Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        time,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      Image.network(
                        'https://openweathermap.org/img/wn/${item.iconCode}.png',
                        width: 40,
                        height: 40,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud, size: 30, color: Colors.white),
                      ),
                      Text(
                        '${item.temperature.toStringAsFixed(0)}°',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
