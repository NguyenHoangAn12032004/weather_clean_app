
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
import '../widgets/weather_detail_list.dart';
import '../widgets/hourly_forecast_chart.dart';
import '../widgets/weather_3d_icon.dart';
import '../bloc/settings/settings_cubit.dart';
import '../bloc/settings/settings_state.dart';
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
      child: const Scaffold(
         backgroundColor: Colors.transparent, 
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

    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: getIt<SettingsCubit>(),
      builder: (context, settingsState) {
        
        // Helper
        String getTemp(double c, {bool showUnit = true}) {
           if (settingsState.tempUnit == TemperatureUnit.fahrenheit) {
             final f = (c * 9 / 5) + 32;
             return '${f.toStringAsFixed(0)}${showUnit ? "°" : ""}';
           }
           return '${c.toStringAsFixed(0)}${showUnit ? "°" : ""}';
        }

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
                                if (context.read<WeatherBloc>().toString().contains('GPS')) 
                                   const Icon(Icons.location_on, color: Colors.white, size: 20),
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
                      // Removed Map Button
                    ],
                  ),
                  
                  const SizedBox(height: 40),

                  // --- MAIN INFO ---
                  Column(
                    children: [
                       // 3D Animated Icon (Premium)
                       BreathingWidget(
                          child: Weather3DIcon(
                            iconCode: weather.iconCode,
                            size: 180, 
                          ),
                       ),
                      Text(
                        // Explicitly show C or F if user wants "Ghi rõ chữ C và F"
                        getTemp(weather.temperature, showUnit: false) + '°', // 100°
                        style: const TextStyle(fontSize: 100, fontWeight: FontWeight.w200, color: Colors.white, height: 1.0),
                      ),
                      Text(
                        weather.description.replaceFirst(weather.description[0], weather.description[0].toUpperCase()), 
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white70, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        // Explicit Unit labels for High/Low
                        'Cao nhất: ${getTemp(weather.temperature)}${settingsState.tempUnit == TemperatureUnit.celsius ? "C" : "F"}  Thấp nhất: ${getTemp(weather.feelsLike)}${settingsState.tempUnit == TemperatureUnit.celsius ? "C" : "F"}', 
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // --- CHARTS & DETAILS ---
                  if (forecast != null && forecast.list.isNotEmpty) ...[
                    HourlyForecastChart(items: forecast.list),
                    const SizedBox(height: 20),
                  ],

                  if (forecast != null && forecast.list.isNotEmpty) ...[
                    DailyForecastWidget(items: forecast.list),
                    const SizedBox(height: 20),
                  ],
                  
                  WeatherDetailList(weather: weather),
                  
                  const SizedBox(height: 20),

                  SunAstroChart(weather: weather),
                  
                  const SizedBox(height: 40),

                  if (airQuality != null)
                     AirQualityWidget(airQuality: airQuality),

                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ),
        );
      },
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
