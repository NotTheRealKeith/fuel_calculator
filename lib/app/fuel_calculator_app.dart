import 'package:flutter/material.dart';
import '../features/fuel_calculator/presentation/screens/calculator_screen.dart';

class FuelCalculatorApp extends StatelessWidget {
  const FuelCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Fuel Calculator',
      home: CalculatorScreen(),
    );
  }
}
