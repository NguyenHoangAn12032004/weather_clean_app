
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'glass_container.dart';

class FloatingNavBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onListTap;
  final VoidCallback onMapTap;
  final VoidCallback onSettingsTap;

  const FloatingNavBar({
    super.key,
    required this.onSearchTap,
    required this.onListTap,
    required this.onMapTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: GlassContainer(
        opacity: 0.3, // Darker for visibility on bright backgrounds
        color: Colors.black.withOpacity(0.4), // Distinct dark glass
        borderRadius: BorderRadius.circular(50),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute evenly
          children: [
             _NavButton(icon: Icons.map_outlined, onPressed: onMapTap),
             _NavButton(icon: Icons.settings_outlined, onPressed: onSettingsTap),
             _NavButton(icon: Icons.search, onPressed: onSearchTap, isMain: true),
             _NavButton(icon: Icons.list, onPressed: onListTap),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isMain;

  const _NavButton({
    required this.icon, 
    required this.onPressed,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      color: Colors.white,
      iconSize: isMain ? 28 : 24,
      onPressed: onPressed,
      style: isMain ? IconButton.styleFrom(
        backgroundColor: Colors.white24,
        padding: const EdgeInsets.all(12),
      ) : null,
    );
  }
}
