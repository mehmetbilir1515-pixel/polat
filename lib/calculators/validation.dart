/// Hesaplama girdileri geçersiz olduğunda fırlatılır; mesaj kullanıcıya gösterilir.
class CalculationException implements Exception {
  const CalculationException(this.message);

  final String message;

  @override
  String toString() => message;
}

void requireFinite(double value, String name) {
  if (!value.isFinite) {
    throw CalculationException('$name geçerli bir sayı olmalıdır.');
  }
}

void requirePositive(double value, String name) {
  if (!value.isFinite || value <= 0) {
    throw CalculationException('$name sıfırdan büyük olmalıdır.');
  }
}

void requireNonNegative(double value, String name) {
  if (!value.isFinite || value < 0) {
    throw CalculationException('$name sıfır veya daha büyük olmalıdır.');
  }
}
