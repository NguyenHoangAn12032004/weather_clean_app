import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../injection.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';
import '../widgets/weather_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/digital_clock.dart';
import '../widgets/hourly_forecast_widget.dart'; 
import '../widgets/daily_forecast_widget.dart'; 
import '../widgets/weather_effects_layer.dart'; 
import '../widgets/breathing_widget.dart';
import '../widgets/air_quality_widget.dart'; // New

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WeatherBloc>()..add(LoadSavedCity()),
      child: const Scaffold(
        resizeToAvoidBottomInset: false, 
        body: _WeatherView(),
      ),
    );
  }
}

class _WeatherView extends StatelessWidget {
  const _WeatherView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        String iconCode = '01d'; // Default
        
        // Background logic (Always there)
        if (state is WeatherLoaded) {
          iconCode = state.weather.iconCode;
        }

        return Stack(
          children: [
            // 1. Dynamic Background
            Positioned.fill(
              child: WeatherBackground(
                iconCode: iconCode,
                child: Container(), 
              ),
            ),
            // 2. Weather Effects Layer (Rain/Snow) - New
            Positioned.fill(
              child: WeatherEffectsLayer(iconCode: iconCode),
            ),
            // 3. Main Content
            SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: _buildContent(context, state),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, WeatherState state) {
    if (state is WeatherLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }
    
    if (state is WeatherError) {
      return _buildErrorContent(context, state.message);
    }

    if (state is WeatherLoaded) {
      return _buildWeatherContent(context, state);
    }

    return const SizedBox.shrink();
  }

  Widget _buildWeatherContent(BuildContext context, WeatherLoaded state) {
    final weather = state.weather;
    final forecast = state.forecast;
    final airQuality = state.airQuality; // New

    return RefreshIndicator(
      onRefresh: () async {
         context.read<WeatherBloc>().add(GetWeatherForCity(weather.cityName));
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: [
              // --- TOP BAR ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Row(
                           children: [
                            const Icon(Icons.location_on, color: Colors.white, size: 20),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                weather.cityName,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        const Shadow(offset: Offset(0, 2), blurRadius: 4.0, color: Colors.black26),
                                      ],
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                           ],
                         ),
                         const SizedBox(height: 4),
                         DigitalClock(utcOffsetSeconds: weather.timezone), // New 
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.my_location, color: Colors.white, size: 28),
                        onPressed: () => context.read<WeatherBloc>().add(GetWeatherForLocation()),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white, size: 28),
                        onPressed: () async {
                          final city = await context.push<String>('/search');
                          if (city != null && context.mounted) {
                             context.read<WeatherBloc>().add(GetWeatherForCity(city));
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
              
              const SizedBox(height: 40),

              // --- MAIN INFO (Big Temp) ---
              Column(
                children: [
                   // Wrap Image with BreathingWidget
                   BreathingWidget(
                      child: Image.network(
                        'https://openweathermap.org/img/wn/${weather.iconCode}@4x.png',
                        width: 150, height: 150,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud, size: 120, color: Colors.white),
                      ),
                   ),
                  Text(
                    '${weather.temperature.toStringAsFixed(0)}°',
                    style: const TextStyle(fontSize: 100, fontWeight: FontWeight.w200, color: Colors.white, height: 1.0),
                  ),
                  Text(
                    weather.description.replaceFirst(weather.description[0], weather.description[0].toUpperCase()), 
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Cao nhất: ${weather.temperature.toStringAsFixed(0)}°  Thấp nhất: ${weather.feelsLike.toStringAsFixed(0)}°', 
                    // Note: API 'weather' has temp_min/max but entity might not mapping it perfectly or it's same as temp. 
                    // For now using feelsLike or update entity later.
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              
              // --- 1. HOURLY FORECAST MODULE ---
              if (forecast != null && forecast.list.isNotEmpty) ...[
                HourlyForecastWidget(items: forecast.list),
                const SizedBox(height: 20),
              ],

              // --- 2. DAILY FORECAST MODULE ---
              if (forecast != null && forecast.list.isNotEmpty) ...[
                DailyForecastWidget(items: forecast.list),
                const SizedBox(height: 20),
              ],
              
              // --- 3. DETAILS GRID ---
              GlassContainer(
                opacity: 0.15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDetailItem(Icons.air, '${weather.windSpeed} m/s', 'Gió'),
                    Container(width: 1, height: 40, color: Colors.white24),
                    _buildDetailItem(Icons.water_drop_outlined, '${weather.humidity}%', 'Độ ẩm'),
                    Container(width: 1, height: 40, color: Colors.white24),
                    _buildDetailItem(Icons.thermostat, '${weather.feelsLike.toStringAsFixed(0)}°', 'Cảm giác'),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),

              // --- 4. AIR QUALITY ---
              if (airQuality != null)
                 AirQualityWidget(airQuality: airQuality),

              const SizedBox(height: 50), // Padding bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 14)),
      ],
    );
  }

  Widget _buildErrorContent(BuildContext context, String message) {
    return Center(
      child: GlassContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 60),
            const SizedBox(height: 20),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white24, foregroundColor: Colors.white),
              onPressed: () => context.read<WeatherBloc>().add(LoadSavedCity()), 
              child: const Text('Thử lại')
            )
          ],
        ),
      ),
    );
  }
}
