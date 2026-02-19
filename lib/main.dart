import 'package:flutter/material.dart';
import 'package:lightsout/on_boarding/onboarding_view.dart';
import 'package:lightsout/pages/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: RiveAppTheme.lightTheme(),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: RiveAppTheme.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: RiveAppTheme.accentColor,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: Color(0xFF1D1D1F),
          ),
          bodyMedium: TextStyle(
            color: Color(0xFF3A3A3C),
          ),
        ),
      ),
      home: const OnBoardingView(),
    );
  }
}
