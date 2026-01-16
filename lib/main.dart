import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/bloc/settings/settings_cubit.dart';
import 'injection.dart';

import 'package:intl/date_symbol_data_local.dart'; // New

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await initializeDateFormatting('vi', null); // New
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide SettingsCubit globally so it lives for the entire app lifecycle
        BlocProvider(create: (_) => getIt<SettingsCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
