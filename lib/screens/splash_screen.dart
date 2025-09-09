import 'package:flutter/material.dart';
import 'package:flutter_load_kit/flutter_load_kit.dart';

import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState(); // ✅ Appel super.initState() EN PREMIER
    Future.delayed(const Duration(seconds: 4), () {
      // ✅ Vérification que le widget est toujours monté
      if (mounted) {
        Navigator.pushReplacement( // ✅ Utilisation de pushReplacement au lieu de push
          context, 
          MaterialPageRoute(builder: (context) => const MainNavigation())
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: LoadKitSpinningArcs(
            size: 32.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}