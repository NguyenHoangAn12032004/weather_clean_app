import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/weather.dart';
import 'glass_container.dart';

class DetailsGridWidget extends StatelessWidget {
  final WeatherEntity weather;

  const DetailsGridWidget({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    // Format helpers
    String formatTime(int timestamp) {
 
      // Note: timezone is offset in seconds from UTC. 
      // But DateTime.fromMillisecondsSinceEpoch(x, isUtc: true) gives UTC.
      // Usually weather.timezone is offset from UTC.
      // Better:
      final utcDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
      final cityTime = utcDate.add(Duration(seconds: weather.timezone));
      return DateFormat('HH:mm').format(cityTime);
    }

    final sunrise = formatTime(weather.sunrise);
    final sunset = formatTime(weather.sunset);

    final items = [
      _DetailItem(
        icon: Icons.air,
        title: 'Gió',
        value: '${weather.windSpeed} m/s',
        subValue: 'Hướng: Đông Nam', // Placeholder or add deg logic later
      ),
      _DetailItem(
        icon: Icons.water_drop_outlined,
        title: 'Độ ẩm',
        value: '${weather.humidity}%',
        subValue: 'Điểm sương: ${weather.temperature - 2}°', // Approx
      ),
      _DetailItem(
        icon: Icons.thermostat,
        title: 'Cảm giác',
        value: '${weather.feelsLike.toStringAsFixed(0)}°',
        subValue: 'Khá giống thực tế',
      ),
      _DetailItem(
        icon: Icons.visibility,
        title: 'Tầm nhìn',
        value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
        subValue: 'Trời quang đãng',
      ),
      _DetailItem(
        icon: Icons.speed,
        title: 'Áp suất',
        value: '${weather.pressure} hPa',
        subValue: 'Bình thường',
      ),
      _DetailItem(
        icon: Icons.wb_sunny_outlined,
        title: 'Mặt trời',
        value: sunset,
        subValue: 'Mọc: $sunrise',
        isSun: true,
      ),
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0, // Make it square to give more height
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subValue;
  final bool isSun;

  const _DetailItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.subValue,
    this.isSun = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      opacity: 0.15,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white70, size: 18), // Smaller icon
                const SizedBox(width: 6),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11, // Smaller title
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(), // Use Spacer to push content down
            if (isSun) ...[
              Text(
                'Lặn: $value',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18, 
                  fontWeight: FontWeight.w500,
                ),
              ),
               Text(
                'Mọc: ${subValue.split(' ')[1]}', 
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ] else ...[
               FittedBox( // Prevent overflow for large numbers
                 fit: BoxFit.scaleDown,
                 alignment: Alignment.centerLeft,
                 child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24, // Reduced from 28
                    fontWeight: FontWeight.w400,
                  ),
                ),
               ),
              Text(
                subValue,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
                maxLines: 2, // Allow wrapping
                overflow: TextOverflow.ellipsis,
              ),
            ]
          ],
        ),
      ),
    );
  }
}
