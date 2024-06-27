import 'package:flutter/material.dart';
import 'package:lightsout/on_boarding/onboarding_view.dart';
import 'package:lightsout/pages/home_page.dart';
import 'package:lightsout/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingView(),
    );
  }
}
