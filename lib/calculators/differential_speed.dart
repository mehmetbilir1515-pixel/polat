import 'validation.dart';

/// Arka tahrik dönüş yönü.
enum BackDriveRotation { forward, reverse }

/// Kasa (bowl) ile helezon (conveyor) arasındaki diferansiyel hız, RPM.
///
/// İleri yönde: (ana − arka) / oran. Geri yönde: (ana + arka) / oran.
/// Sonuç yalnızca matematikseldir; üretici özelliklerine göre doğrulanmalıdır.
double differentialSpeed({
  required double mainDriveRpm,
  required double backDriveRpm,
  required double gearboxRatio,
  required BackDriveRotation rotation,
}) {
  requirePositive(mainDriveRpm, 'Ana tahrik devri');
  requireNonNegative(backDriveRpm, 'Arka tahrik devri');
  requirePositive(gearboxRatio, 'Dişli kutusu oranı');
  final combined = rotation == BackDriveRotation.forward
      ? mainDriveRpm - backDriveRpm
      : mainDriveRpm + backDriveRpm;
  return combined / gearboxRatio;
}
