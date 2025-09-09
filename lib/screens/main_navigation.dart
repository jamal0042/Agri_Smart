import 'package:flutter/material.dart';
import 'package:AgriSmart/screens/home_screen.dart';
import 'package:AgriSmart/screens/scan_screen.dart';
import 'package:AgriSmart/screens/disease_database_screen.dart';
import 'package:AgriSmart/screens/history_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ScanScreen(),
    const DiseaseDatabaseScreen(),
    const ScanHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_rounded),
              label: 'Scanner',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_florist_rounded),
              label: 'Maladies',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: 'Historique',
            ),
          ],
        ),
      ),
    );
  }
}