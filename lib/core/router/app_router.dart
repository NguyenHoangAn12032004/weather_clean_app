
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/search_page.dart';
import '../../presentation/pages/weather_page_view.dart';

import '../../presentation/pages/city_management_page.dart';
import '../../presentation/pages/city_management_page.dart';
import '../../presentation/pages/weather_map_page.dart';
import '../../presentation/pages/settings_page.dart'; // New

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WeatherPageView(),
    ),
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SearchPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1), // Slide from bottom
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/cities',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const CityManagementPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0), // Slide from right
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/map',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, double>?;
        final lat = extra?['lat'] ?? 21.0285;
        final lon = extra?['lon'] ?? 105.8542;
        return CustomTransitionPage(
          key: state.pageKey,
          child: WeatherMapPage(lat: lat, lon: lon),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
             return FadeTransition(
               opacity: animation,
               child: child,
             );
          },
        );
      },
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SettingsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
  ],
);
