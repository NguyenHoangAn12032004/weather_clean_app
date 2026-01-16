
import 'package:flutter/material.dart';

class Weather3DIcon extends StatelessWidget {
  final String iconCode; // e.g., "01d", "10n"
  final double size;

  const Weather3DIcon({
    super.key,
    required this.iconCode,
    this.size = 160,
  });

  @override
  Widget build(BuildContext context) {
    // Premium 3D Asset Path
    // Naming convention: 01d.png, 02n.png in assets/icons/3d/
    final assetPath = 'assets/icons/3d/$iconCode.png';

    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to High-Res OpenWeatherMap if local 3D asset missing
        return Image.network(
          'https://openweathermap.org/img/wn/$iconCode@4x.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
           loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(width: size, height: size); // Empty placeholder, no spinner circle
            },
           errorBuilder: (context, error, stackTrace) => Icon(
            Icons.cloud, 
            size: size, 
            color: Colors.white54
           ),
        );
      },
    );
  }
}
