import 'validation.dart';

/// Şanzıman tipi: ileri = ZS, geri = ZSPN (arka tahrik dönüş yönü).
enum BackDriveRotation { forward, reverse }

/// Tambur (bowl) ile helezon (conveyor) arasındaki diferansiyel hız, RPM.
///
/// İleri yönde: (ana − arka) / oran. Geri yönde: (ana + arka) / oran.
/// Sonuç yalnızca matematikseldir; üretici özelliklerine göre doğrulanmalıdır.
double differentialSpeed({
  required double mainDriveRpm,
  required double backDriveRpm,
  required double gearboxRatio,
  required BackDriveRotation rotation,
}) {
  requirePositive(mainDriveRpm, 'Tambur devri');
  requireNonNegative(backDriveRpm, 'Helezon devri');
  requirePositive(gearboxRatio, 'Dişli kutusu oranı');
  final combined = rotation == BackDriveRotation.forward
      ? mainDriveRpm - backDriveRpm
      : mainDriveRpm + backDriveRpm;
  return combined / gearboxRatio;
}

/// Ters hesap: hedef diferansiyel hızdan gereken helezon (arka tahrik) devri, RPM.
///
/// İleri yönde: ana − fark · oran. Geri yönde: fark · oran − ana.
/// (Düz formülün tersidir; sonuç negatif çıkarsa bu değerlerle o yönde çalışılamaz.)
double backDriveSpeed({
  required double mainDriveRpm,
  required double differentialRpm,
  required double gearboxRatio,
  required BackDriveRotation rotation,
}) {
  requirePositive(mainDriveRpm, 'Tambur devri');
  requireNonNegative(differentialRpm, 'Diferansiyel hız');
  requirePositive(gearboxRatio, 'Dişli kutusu oranı');
  final scaled = differentialRpm * gearboxRatio;
  final back = rotation == BackDriveRotation.forward
      ? mainDriveRpm - scaled
      : scaled - mainDriveRpm;
  // Kayan nokta artığı (ör. -1e-13) sıfır sayılır.
  if (back < 0 && back > -1e-9) {
    return 0;
  }
  if (back < 0) {
    throw CalculationException(
      rotation == BackDriveRotation.forward
          ? 'Bu diferansiyel hız için İleri (ZS) şanzıman tipinde helezon devri negatif çıkıyor '
              '(diferansiyel hız × oran, tambur devrinden büyük olamaz).'
          : 'Bu diferansiyel hız için Geri (ZSPN) şanzıman tipinde helezon devri negatif çıkıyor '
              '(diferansiyel hız × oran, tambur devrinden küçük olamaz).',
    );
  }
  return back;
}
