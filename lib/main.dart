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
      home: const OnBoardingView(),
    );
  }
}
