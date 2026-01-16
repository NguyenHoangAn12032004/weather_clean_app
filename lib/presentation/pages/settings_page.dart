
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../injection.dart'; // For getIt
import '../bloc/settings/settings_cubit.dart';
import '../bloc/settings/settings_state.dart';
import '../widgets/glass_container.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SettingsCubit>(), // Use .value to NOT close the singleton
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Cài đặt', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
           Positioned.fill(
             child: DecoratedBox(
               decoration: BoxDecoration(
                 gradient: LinearGradient(
                   colors: [const Color(0xFF1c1b33), const Color(0xFF2e335a)],
                   begin: Alignment.topCenter,
                   end: Alignment.bottomCenter,
                 ),
               ),
             ),
          ),
          
          SafeArea(
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildSectionTitle('Đơn vị'),
                    
                    _buildSettingItem(
                      title: 'Đơn vị nhiệt độ',
                      value: state.tempUnit == TemperatureUnit.celsius ? 'Độ C (°C)' : 'Độ F (°F)',
                      onTap: () => _showTempUnitDialog(context),
                    ),
                    
                    _buildSettingItem(
                      title: 'Đơn vị gió',
                      value: state.windUnit == WindSpeedUnit.metersPerSecond ? 'm/s' : 'km/h',
                      onTap: () => _showWindUnitDialog(context),
                    ),

                    const SizedBox(height: 30),
                    _buildSectionTitle('Giao diện'),
                    _buildSettingItem(
                      title: 'Chủ đề',
                      value: 'Tự động',
                      onTap: () {}, // Future expansion
                    ),

                    const SizedBox(height: 30),
                    _buildSectionTitle('Thông tin'),
                     _buildSettingItem(
                      title: 'Phiên bản',
                      value: '1.0.0 (Premium)',
                      onTap: null,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTempUnitDialog(BuildContext context) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2e335a),
        title: const Text('Chọn đơn vị nhiệt độ', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TemperatureUnit.values.map((unit) {
             return ListTile(
               title: Text(unit == TemperatureUnit.celsius ? 'Độ C (°C)' : 'Độ F (°F)', style: const TextStyle(color: Colors.white70)),
               onTap: () {
                 context.read<SettingsCubit>().setTempUnit(unit);
                 Navigator.pop(ctx);
               },
             );
          }).toList(),
        ),
      )
    );
  }

  void _showWindUnitDialog(BuildContext context) {
     showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2e335a),
        title: const Text('Chọn đơn vị gió', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: WindSpeedUnit.values.map((unit) {
             return ListTile(
               title: Text(unit == WindSpeedUnit.metersPerSecond ? 'm/s' : 'km/h', style: const TextStyle(color: Colors.white70)),
               onTap: () {
                 context.read<SettingsCubit>().setWindUnit(unit);
                 Navigator.pop(ctx);
               },
             );
          }).toList(),
        ),
      )
    );
  }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassContainer(
        opacity: 0.1,
        borderRadius: BorderRadius.circular(15),
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: ListTile(
          onTap: onTap,
          title: Text(title, style: const TextStyle(color: Colors.white)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: const TextStyle(color: Colors.white70)),
               if (onTap != null)
                const SizedBox(width: 8),
               if (onTap != null)
                const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
