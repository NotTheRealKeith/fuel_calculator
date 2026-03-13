import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController consumptionController = TextEditingController();
  final TextEditingController fuelPriceController = TextEditingController();

  double fuelUsed = 0;
  double tripCost = 0;

  bool isReturnTrip = false;

  String? distanceError;
  String? consumptionError;
  String? fuelPriceError;

  void calculateFuelCost() {
    FocusScope.of(context).unfocus();

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
  void dispose() {
    distanceController.dispose();
    consumptionController.dispose();
    fuelPriceController.dispose();
    super.dispose();
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
              Text(
                'Fuel Used: ${fuelUsed.toStringAsFixed(2)} L',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Trip Cost: \$${tripCost.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: distanceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Distance (km)',
                  border: const OutlineInputBorder(),
                  errorText: distanceError,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: consumptionController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Fuel Consumption (L/100km)',
                  border: const OutlineInputBorder(),
                  errorText: consumptionError,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: fuelPriceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Fuel Price (\$ per litre)',
                  border: const OutlineInputBorder(),
                  errorText: fuelPriceError,
                ),
              ),
              SwitchListTile(
                title: const Text('Return Trip'),
                value: isReturnTrip,
                onChanged: (value) {
                  setState(() {
                    isReturnTrip = value;
                  });
                },
              ),
              const SizedBox(height: 24),
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
