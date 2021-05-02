/// Evaluates a polynomal with [coefficients] and one variable [x].
///
/// Example: ```y = 52.45 + (12.34 * x) + (98.98 * x^2) - (34.78 * x^3)``` for ```x = 20```:
/// ```dart
/// var y = evaluatePolynomial(20, [52.45, 12.34, 98.98, -34.78]);
/// ```
///
/// If [coefficients] is empty, the value of [x] is returned.
double evaluatePolynomial(double x, List<double> coefficients) {
  if (coefficients.isEmpty) return x;

  var y = coefficients.last;
  for (var i = coefficients.length - 2; i >= 0; i--) {
    y = (y * x) + coefficients[i];
  }

  return y;
}

/// Splits the floating-point value [x] to an integer part and a fractional part.
///
/// Each part has the same sign as [x].
ModfResult modf(double x) {
  var integerPart = x.truncate();
  return ModfResult(integerPart, x - integerPart);
}

class ModfResult {
  final int integerPart;
  final double fractionalPart;

  ModfResult(this.integerPart, this.fractionalPart);
}
