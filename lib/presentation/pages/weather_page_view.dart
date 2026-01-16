import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../injection.dart';
import '../bloc/city_list_bloc.dart';
import '../bloc/city_list_state.dart';
import '../bloc/city_list_event.dart';

import 'weather_single_page.dart';

class WeatherPageView extends StatelessWidget {
  const WeatherPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CityListBloc>()..add(LoadCities()),
      child: const _PageViewBody(),
    );
  }
}

class _PageViewBody extends StatefulWidget {
  const _PageViewBody();

  @override
  State<_PageViewBody> createState() => _PageViewBodyState();
}

class _PageViewBodyState extends State<_PageViewBody> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Base background
      body: BlocBuilder<CityListBloc, CityListState>(
        builder: (context, state) {
          if (state is CityListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final cities = (state is CityListLoaded) ? state.cities : <String>[];
          
          // Total pages = 1 (GPS) + Saved Cities
          final totalPages = 1 + cities.length;

          return Stack(
            children: [
              PageView.builder(
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                itemCount: totalPages,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const WeatherSinglePage(cityName: null); // GPS Page
                  }
                  return WeatherSinglePage(cityName: cities[index - 1]);
                },
              ),
              
              // Bottom Action Bar (Page Indicator & Menu)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
              // Map Button (Left)
              IconButton(
                icon: const Icon(Icons.map_outlined, color: Colors.white, size: 28),
                onPressed: () {
                   // Get current page's weather location if possible, 
                   // but PageView state is inside children. 
                   // Simple solution: Just go to map with default or last known location?
                   // Better: Ideally we want center on current city. 
                   // But PageView doesn't easily expose current city data here without more state.
                   // Let's pass 0,0 and let map default or handle it? 
                   // Or just open Map and let it show default view.
                   // WAIT: We can pass latitude/longitude if we have it in State? 
                   // WeatherPageView doesn't hold weather data directly.
                   // Let's just open map without coords for now, MapPage defaults to Hanoi or user location logic inside if we added it.
                   // Actually AppRouter defaults to Hanoi.
                   context.push('/map');
                },
              ),
              
              // Indicator (Center)
              if (cities.isNotEmpty)
                SmoothPageIndicator(
                  controller: _controller,
                  count: totalPages,
                  effect: const WormEffect(
                    dotColor: Colors.white38,
                    activeDotColor: Colors.white,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 8,
                  ),
                ),
                
              // List Button (Right)
              IconButton(
                        icon: const Icon(Icons.list, color: Colors.white70),
                        onPressed: () async {
                           // Navigate to City Management
                           final newIndex = await context.push<int>('/cities');
                           
                           // If a city was selected (index returned)
                           if (newIndex != null && context.mounted) {
                              // Force update bloc to ensure page view has correct count
                              context.read<CityListBloc>().add(LoadCities());
                              
                              // Slight delay to allow rebuild before jumping
                              Future.delayed(const Duration(milliseconds: 100), () {
                                if (_controller.hasClients) {
                                  _controller.jumpToPage(newIndex);
                                }
                              });
                           } else {
                              // Just refresh list if back was pressed
                              if (context.mounted) {
                                 context.read<CityListBloc>().add(LoadCities()); 
                              }
                           }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
