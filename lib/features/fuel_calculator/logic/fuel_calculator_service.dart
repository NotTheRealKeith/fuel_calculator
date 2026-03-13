class FuelCalculatorService {
  static Map<String, double> calculateTrip({
    required double distance,
    required double consumption,
    required double fuelPrice,
    required bool isReturnTrip,
  }) {
    double fuelUsed = (distance / 100) * consumption;
    double tripCost = fuelUsed * fuelPrice;

    if (isReturnTrip) {
      fuelUsed *= 2;
      tripCost *= 2;
    }

    return {'fuelUsed': fuelUsed, 'tripCost': tripCost};
  }
}
