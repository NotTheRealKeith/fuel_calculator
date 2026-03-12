import 'package:flutter/material.dart';

// App entry point.
void main() {
  runApp(const FuelCalculatorApp());
}

// Root widget that configures the app shell.
class FuelCalculatorApp extends StatelessWidget {
  const FuelCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Fuel Calculator',
      home: const CalculatorScreen(),
    );
  }
}

// Main screen for collecting fuel calculation inputs.
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Controllers to manage the input from the text fields.
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController consumptionController = TextEditingController();
  final TextEditingController fuelPriceController = TextEditingController();

  // Stores the calculated trip values shown below the button.
  double fuelUsed = 0;
  double tripCost = 0;

  // Reads the current inputs and updates the calculated totals.
  void calculateFuelCost() {
    // Fallback to zero if any field is empty or invalid.
    final double distance = double.tryParse(distanceController.text) ?? 0;
    final double consumption = double.tryParse(consumptionController.text) ?? 0;
    final double fuelPrice = double.tryParse(fuelPriceController.text) ?? 0;

    FocusScope.of(context).unfocus();

    setState(() {
      fuelUsed = (distance / 100) * consumption;
      tripCost = fuelUsed * fuelPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Fuel Calculator')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Distance input used by the calculator.
              TextField(
                controller: distanceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Distance (km)',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16.0),

              // Fuel efficiency input used by the calculator.
              TextField(
                controller: consumptionController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Fuel Consumption (l/100km)',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16.0),

              // Price of fuel input used by the calculator.
              TextField(
                controller: fuelPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Fuel Price (\$ per liter)',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24.0),

              // Button to trigger the fuel cost calculation.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: calculateFuelCost,
                  child: const Text('Calculate Fuel Cost'),
                ),
              ),

              const SizedBox(height: 24),

              // Displays the calculated fuel needed for the trip.
              Text(
                'Fuel Used: ${fuelUsed.toStringAsFixed(2)} L',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 8),

              // Displays the estimated fuel cost for the trip.
              Text(
                'Trip Cost: \$${tripCost.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
