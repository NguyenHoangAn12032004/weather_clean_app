import 'package:flutter/material.dart';
import '../../domain/entities/air_quality.dart';
import 'glass_container.dart';

class AirQualityWidget extends StatelessWidget {
  final AirQualityEntity? airQuality;

  const AirQualityWidget({super.key, this.airQuality});

  @override
  Widget build(BuildContext context) {
    if (airQuality == null) return const SizedBox.shrink();

    final aqi = airQuality!.aqiIndex;
    final description = _getAqiDescription(aqi);

    
    // Calculate slider position (0.0 to 1.0) based on AQI (1 to 5)
    // 1 -> 0.1, 5 -> 0.9
    final position = (aqi - 1) / 4.0; 

    return GlassContainer(
      opacity: 0.2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.waves, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'CHẤT LƯỢNG KHÔNG KHÍ',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '$aqi - $description',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // Gradient Slider Bar
            SizedBox(
              height: 10,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                   Container(
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(5),
                       gradient: const LinearGradient(
                         colors: [
                           Colors.green,
                           Colors.yellow,
                           Colors.orange,
                           Colors.red,
                           Colors.purple,
                         ],
                       ),
                     ),
                   ),
                   // Indicator Dot
                   Align(
                     alignment: Alignment(position * 2 - 1, 0), // Convert 0..1 to -1..1
                     child: Container(
                       width: 12,
                       height: 12,
                       decoration: BoxDecoration(
                         color: Colors.white,
                         shape: BoxShape.circle,
                         border: Border.all(color: Colors.black, width: 2),
                         boxShadow: [
                           BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                         ]
                       ),
                     ),
                   )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
            const SizedBox(height: 16),
            
            // Details Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem('PM2.5', airQuality!.pm2_5.toStringAsFixed(1)),
                _buildDetailItem('PM10', airQuality!.pm10.toStringAsFixed(1)),
                _buildDetailItem('SO2', airQuality!.so2.toStringAsFixed(1)),
                _buildDetailItem('NO2', airQuality!.no2.toStringAsFixed(1)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _getAqiDescription(int index) {
    switch (index) {
      case 1: return 'Tốt';
      case 2: return 'Khá';
      case 3: return 'Trung bình';
      case 4: return 'Kém';
      case 5: return 'Rất kém';
      default: return 'Không xác định';
    }
  }


}
