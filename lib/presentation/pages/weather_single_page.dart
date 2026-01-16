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
 
import '../widgets/daily_forecast_widget.dart'; 
import '../widgets/weather_effects_layer.dart'; 
import '../widgets/breathing_widget.dart';
import '../widgets/air_quality_widget.dart';
import '../widgets/details_grid_widget.dart';
import '../widgets/hourly_forecast_chart.dart';
import '../widgets/sun_astro_chart.dart';

class WeatherSinglePage extends StatelessWidget {
  final String? cityName; // null = Current Location (GPS)

  const WeatherSinglePage({super.key, this.cityName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
         final bloc = getIt<WeatherBloc>();
         if (cityName == null) {
            bloc.add(GetWeatherForLocation());
         } else {
            bloc.add(GetWeatherForCity(cityName!));
         }
         return bloc;
      },
      child: const Scaffold( // Keep Scaffold for SafeArea mainly
         backgroundColor: Colors.transparent, // Allow PageView background if needed
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
        String iconCode = '01d'; 
        
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
            // 2. Weather Effects Layer
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
    final airQuality = state.airQuality;

    return RefreshIndicator(
      onRefresh: () async {
         // Re-fetch logic based on current state City
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
                            if (context.read<WeatherBloc>().toString().contains('GPS')) // Optional: Helper to know if GPS
                               const Icon(Icons.location_on, color: Colors.white, size: 20),
                            // Or just always show location icon or different icon for saved cities?
                            // For now simple Title
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
                         DigitalClock(utcOffsetSeconds: weather.timezone), 
                      ],
                    ),
                  ),
                  // Actions: Only Keep Search? Or maybe List Menu?
                  // In PageView, we usually have a "List" button at bottom or top right
                  IconButton(
                    icon: const Icon(Icons.list, color: Colors.white, size: 28),
                    onPressed: () {
                       // Navigate to City Management?
                       // user request was just to swipe, but let's keep search here for now inside pages?
                       // Ideally Search -> Add City.
                       context.push('/search'); // We'll modify search to ADD city later
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 40),

              // --- MAIN INFO ---
              Column(
                children: [
                   BreathingWidget(
                      child: Image.network(
                        'https://openweathermap.org/img/wn/${weather.iconCode}@4x.png',
                        width: 160, height: 160,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            width: 160, height: 160,
                            child: Center(child: CircularProgressIndicator(color: Colors.white24)),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported, size: 80, color: Colors.white54),
                            Text('Lỗi ảnh', style: TextStyle(color: Colors.white54, fontSize: 10)),
                          ],
                        ),
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
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              
              // --- 1. HOURLY FORECAST MODULE (Chart) ---
              if (forecast != null && forecast.list.isNotEmpty) ...[
                HourlyForecastChart(items: forecast.list),
                const SizedBox(height: 20),
              ],

              if (forecast != null && forecast.list.isNotEmpty) ...[
                DailyForecastWidget(items: forecast.list),
                const SizedBox(height: 20),
              ],
              
              // --- 3. DETAILS GRID ---
              DetailsGridWidget(weather: weather),
              
              const SizedBox(height: 20),

              // --- 4. SUN ASTRO CHART ---
              SunAstroChart(weather: weather),
              
              const SizedBox(height: 40),
              
              const SizedBox(height: 20),

              if (airQuality != null)
                 AirQualityWidget(airQuality: airQuality),

              const SizedBox(height: 100), // More padding for bottom indicators if needed
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildErrorContent(BuildContext context, String message) {
    final isGPS = (context.findAncestorWidgetOfExactType<WeatherSinglePage>()?.cityName == null);

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
              onPressed: () {
                 if (isGPS) {
                    context.read<WeatherBloc>().add(GetWeatherForLocation());
                 } else {
                    // We can't easily get city name here if strict, luckily context read weather might have failed.
                    // Retry simply triggers event again from parent logic or re-add event?
                    // Ideally pass city name into _buildErrorContent
                 }
              }, 
              child: const Text('Thử lại')
            )
          ],
        ),
      ),
    );
  }
}
