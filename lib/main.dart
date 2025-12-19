import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_screen.dart';

import 'services/collection_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Note: Firebase setup requires 'google-services.json' in android/app
  // We wrap this in a try-catch so the app doesn't crash on simple run if config is missing
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print(
        'Warning: Firebase failed to initialize. Make sure google-services.json is present. $e');
  }

  await CollectionService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NBA Classifier',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor:
            const Color(0xFF0F172A), // Dark slate blue background
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF4B1F), // Vibrant orange-red
          secondary: Color(0xFF1F2937), // Dark grey surface
          surface: Color(0xFF1E293B),
          onSurface: Colors.white,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
