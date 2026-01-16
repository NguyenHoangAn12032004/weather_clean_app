import 'package:flutter/material.dart';

class WeatherBackground extends StatelessWidget {
  final String iconCode;
  final Widget child;

  const WeatherBackground({
    super.key,
    required this.iconCode,
    required this.child,
  });

  List<Color> _getGradientColors() {
    // Mapping iconCode to colors
    // Day: 01d (clear), 02d (few clouds), 03d, 04d (clouds), 09d, 10d (rain), 11d (thunder), 13d (snow), 50d (mist)
    // Night: 01n...
    
    if (iconCode.endsWith('n')) {
      // Night themes
      if (iconCode == '01n' || iconCode == '02n') {
        return [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)]; // Moonlit
      }
      return [const Color(0xFF000000), const Color(0xFF434343)]; // Dark Night
    }

    // Day themes
    switch (iconCode) {
      case '01d': // Clear Sky
        return [const Color(0xFF2980B9), const Color(0xFF6DD5FA), const Color(0xFFFFFFFF)];
      case '02d': // Few Clouds
      case '03d':
      case '04d':
        return [const Color(0xFF56CCF2), const Color(0xFF2F80ED)];
      case '09d': // Rain
      case '10d':
      case '11d':
        return [const Color(0xFF373B44), const Color(0xFF4286f4)]; // Stormy
      case '13d': // Snow
        return [const Color(0xFF83a4d4), const Color(0xFFb6fbff)];
      case '50d': // Mist
        return [const Color(0xFF3E5151), const Color(0xFFDECBA4)];
      default:
        return [const Color(0xFF2980B9), const Color(0xFF6DD5FA)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _getGradientColors(),
        ),
      ),
      child: child,
    );
  }
}
