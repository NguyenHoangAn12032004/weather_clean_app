import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/rendering.dart';
import '../../injection.dart';
import '../bloc/city_list_bloc.dart';
import '../bloc/city_list_state.dart';
import '../bloc/city_list_event.dart';

import '../widgets/floating_nav_bar.dart';
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
  bool _isDockVisible = true;

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
          final totalPages = 1 + cities.length;

          return NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              if (notification.direction == ScrollDirection.reverse) {
                if (_isDockVisible) setState(() => _isDockVisible = false);
              } else if (notification.direction == ScrollDirection.forward) {
                if (!_isDockVisible) setState(() => _isDockVisible = true);
              }
              return false;
            },
            child: Stack(
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

                // Floating Dock (Bottom)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  bottom: _isDockVisible ? 0 : -100, // Hide by moving down
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Page Indicator (Above Dock)
                      if (cities.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SmoothPageIndicator(
                            controller: _controller,
                            count: totalPages,
                            effect: const WormEffect(
                              dotColor: Colors.white38,
                              activeDotColor: Colors.white,
                              dotHeight: 6,
                              dotWidth: 6,
                              spacing: 8,
                            ),
                          ),
                        ),

                      FloatingNavBar(
                        onSettingsTap: () => context.push('/settings'),
                        onMapTap: () {
                          context.push('/map', extra: {'lat': 21.0, 'lon': 105.0});
                        },
                        onSearchTap: () => context.push('/search'),
                        onListTap: () async {
                          final newIndex = await context.push<int>('/cities');
                          if (newIndex != null && context.mounted) {
                            context.read<CityListBloc>().add(LoadCities());
                            Future.delayed(const Duration(milliseconds: 100), () {
                              if (_controller.hasClients) _controller.jumpToPage(newIndex);
                            });
                          } else {
                            if (context.mounted) context.read<CityListBloc>().add(LoadCities());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
