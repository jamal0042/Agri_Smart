import 'package:flutter/material.dart';
import 'package:AgriSmart/theme.dart';
import 'package:AgriSmart/screens/main_navigation.dart';
import 'package:AgriSmart/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriSmart',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const MainNavigation(), // ← ici on démarre sur ton app
    );
  }
}
