import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/glass_container.dart';

class WeatherMapPage extends StatefulWidget {
  final double lat;
  final double lon;

  const WeatherMapPage({
    super.key,
    required this.lat,
    required this.lon,
  });

  @override
  State<WeatherMapPage> createState() => _WeatherMapPageState();
}

class _WeatherMapPageState extends State<WeatherMapPage> {
  // Layer options: 'precipitation_new', 'clouds_new', 'temp_new', 'wind_new', 'pressure_new'
  String _currentLayer = 'precipitation_new';
  final MapController _mapController = MapController();

  final Map<String, String> _layerNames = {
    'precipitation_new': 'Mưa',
    'temp_new': 'Nhiệt độ',
    'clouds_new': 'Mây',
    'wind_new': 'Gió',
    'pressure_new': 'Áp suất',
  };

  // Thematic colors for each layer
  final Map<String, Color> _layerColors = {
    'precipitation_new': Colors.blueAccent,
    'temp_new': Colors.orangeAccent,
    'clouds_new': Colors.blueGrey,
    'wind_new': Colors.tealAccent,
    'pressure_new': Colors.purpleAccent,
  };

  Color get _themeColor => _layerColors[_currentLayer] ?? Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(widget.lat, widget.lon),
              initialZoom: 8.0,
              minZoom: 2.0,
              maxZoom: 18.0,
              backgroundColor: Colors.black,
            ),
            children: [
              // 1. Base Map (Dark Mode)
              TileLayer(
                urlTemplate: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.weather_clean_app', 
              ),
              
              // 2. Weather Overlay
              TileLayer(
                urlTemplate: 'https://tile.openweathermap.org/map/$_currentLayer/{z}/{x}/{y}.png?appid=${AppConstants.apiKey}',
                userAgentPackageName: 'com.example.weather_clean_app',
              ),
              
              // 3. Current Location Marker
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(widget.lat, widget.lon),
                    width: 50,
                    height: 50,
                    child: _buildAnimatedMarker(),
                  ),
                ],
              ),
            ],
          ),

          // --- HEADER ---
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Back Button
                GlassContainer(
                   opacity: 0.2,
                   borderRadius: BorderRadius.circular(30),
                   child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Title
                Expanded(
                  child: GlassContainer(
                    opacity: 0.15,
                    color: _themeColor.withValues(alpha: 0.15), // Tinted background
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Icon(_getLayerIcon(_currentLayer), color: _themeColor, size: 20),
                           const SizedBox(width: 8),
                           Text(
                            'Bản đồ ${_layerNames[_currentLayer]}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- LAYER SELECTOR (Right Side) ---
          Positioned(
            right: 16,
            bottom: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _layerNames.entries.map((entry) {
                final key = entry.key;
                final name = entry.value;
                final isSelected = key == _currentLayer;
                final color = _layerColors[key]!;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentLayer = key;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: isSelected ? 160 : 50, // Increased width
                      height: 50,
                      child: GlassContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 10), 
                        color: isSelected ? color.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(25),
                        opacity: isSelected ? 0.6 : 0.1,
                        child: Center(
                          child: isSelected 
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  name, 
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )
                            : Icon(_getLayerIcon(key), color: Colors.white70, size: 20),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // --- MY LOCATION BUTTON (Bottom Left) ---
          Positioned(
            left: 16,
            bottom: 40,
            child: FloatingActionButton(
               backgroundColor: const Color(0xFF333333),
               foregroundColor: _themeColor,
               shape: const CircleBorder(),
               onPressed: () {
                  _mapController.move(LatLng(widget.lat, widget.lon), 10.0);
               },
               child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMarker() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      onEnd: () {}, // Can loop animation if converted to StatefulWidget with AnimationController, but simple is fine
      child: const Icon(Icons.location_on, color: Colors.redAccent, size: 50),
    );
  }

  IconData _getLayerIcon(String layer) {
    switch (layer) {
      case 'precipitation_new': return Icons.umbrella;
      case 'temp_new': return Icons.thermostat;
      case 'clouds_new': return Icons.cloud;
      case 'wind_new': return Icons.air;
      case 'pressure_new': return Icons.speed;
      default: return Icons.layers;
    }
  }
}
