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

  // Tracks whether the user wants the calculator to include the return leg.
  bool isReturnTrip = false;

  String? distanceError;
  String? consumptionError;
  String? fuelPriceError;

  void calculateFuelCost() {
    FocusScope.of(context).unfocus();

    // Clear previous errors
    distanceError = null;
    consumptionError = null;
    fuelPriceError = null;

    final String distanceText = distanceController.text.trim();
    final String consumptionText = consumptionController.text.trim();
    final String fuelPriceText = fuelPriceController.text.trim();

    bool hasError = false;

    if (distanceText.isEmpty) {
      distanceError = 'Please enter a distance';
      hasError = true;
    }

    if (consumptionText.isEmpty) {
      consumptionError = 'Please enter fuel consumption';
      hasError = true;
    }

    if (fuelPriceText.isEmpty) {
      fuelPriceError = 'Please enter a fuel price';
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    // Parse values after validation
    final double? distance = double.tryParse(distanceText);
    final double? consumption = double.tryParse(consumptionText);
    final double? fuelPrice = double.tryParse(fuelPriceText);

    if (distance == null) {
      distanceError = 'Enter a valid number';
      hasError = true;
    }

    if (consumption == null) {
      consumptionError = 'Enter a valid number';
      hasError = true;
    }

    if (fuelPrice == null) {
      fuelPriceError = 'Enter a valid number';
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    setState(() {
      double calculatedFuelUsed = (distance! / 100) * consumption!;
      double calculatedTripCost = calculatedFuelUsed * fuelPrice!;

      if (isReturnTrip) {
        calculatedFuelUsed *= 2;
        calculatedTripCost *= 2;
      }

      fuelUsed = calculatedFuelUsed;
      tripCost = calculatedTripCost;
    });
  }

  void resetFields() {
    distanceController.clear();
    consumptionController.clear();
    fuelPriceController.clear();

    setState(() {
      fuelUsed = 0;
      tripCost = 0;
      isReturnTrip = false;

      distanceError = null;
      consumptionError = null;
      fuelPriceError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Fuel Calculator')),
      // Keeps the full form accessible when the keyboard is open or space is tight.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Shows the latest calculation summary before the editable fields.
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

              const SizedBox(height: 24),

              // Distance input used by the calculator.
              TextField(
                controller: distanceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Distance (km)',
                  border: OutlineInputBorder(),
                  errorText: distanceError,
                ),
              ),

              const SizedBox(height: 16.0),

              // Fuel efficiency input used by the calculator.
              TextField(
                controller: consumptionController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Fuel Consumption (l/100km)',
                  border: OutlineInputBorder(),
                  errorText: consumptionError,
                ),
              ),

              const SizedBox(height: 16.0),

              // Price of fuel input used by the calculator.
              TextField(
                controller: fuelPriceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Fuel Price (\$ per liter)',
                  border: OutlineInputBorder(),
                  errorText: fuelPriceError,
                ),
              ),

              // Lets the user double the totals for a round trip.
              SwitchListTile(
                title: const Text('Return Trip'),
                value: isReturnTrip,
                onChanged: (value) {
                  setState(() {
                    isReturnTrip = value;
                  });
                },
              ),

              const SizedBox(height: 24.0),

              // Button to trigger the fuel cost calculation.
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: calculateFuelCost,
                      child: const Text('Calculate'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: resetFields,
                      child: const Text('Reset'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
