import 'package:flutter/material.dart';
import 'package:AgriSmart/theme.dart';
import 'package:AgriSmart/screens/main_navigation.dart';
import 'package:AgriSmart/services/storage_service.dart';
import 'package:firebase_core/firebase_core.dart'; // Import de base de Firebase
import 'firebase_options.dart'; // Fichier de configuration généré par FlutterFire

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase avec les options par défaut pour la plateforme
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
