import 'package:flutter/material.dart';
import 'Splash_Screen.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CUTIS-AI',
      themeMode: ThemeMode.system,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 7, 104, 79),
        ).copyWith(
          primary: const Color.fromARGB(255, 7, 104, 79),
          onPrimary: const Color.fromARGB(255, 255, 255, 255),
          secondary: const Color.fromARGB(255, 0, 141, 105),
          onSecondary: const Color.fromARGB(255, 3, 100, 76),
          surface: const Color.fromARGB(255, 255, 255, 255),
          onSurface: const Color.fromARGB(255, 7, 104, 79),
          background: const Color.fromARGB(255, 247, 247, 247),
          onBackground: const Color.fromARGB(255, 7, 104, 79),
          error: const Color.fromARGB(255, 255, 24, 24),
          onError: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 7, 104, 79),
        ).copyWith(
          primary: const Color.fromARGB(255, 7, 104, 79),
          onPrimary: const Color.fromARGB(255, 255, 255, 255),
          secondary: const Color.fromARGB(255, 0, 141, 105),
          onSecondary: const Color.fromARGB(255, 3, 100, 76),
          surface: const Color.fromARGB(255, 0, 0, 0),
          onSurface: const Color.fromARGB(255, 255, 255, 255),
          background: const Color.fromARGB(255, 24, 24, 24),
          onBackground: const Color.fromARGB(255, 255, 255, 255),
          error: const Color.fromARGB(255, 255, 24, 24),
          onError: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      home: Splash_screen(),
    );
  }
}
