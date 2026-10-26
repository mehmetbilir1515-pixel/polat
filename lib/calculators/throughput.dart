import 'validation.dart';

/// Santrifüje giren kuru katı yükünün tahmini (SI birimleri).
class ThroughputResult {
  const ThroughputResult({
    required this.totalVolumeM3,
    required this.slurryMassKg,
    required this.dryMassKg,
    required this.dryTonsPerDay,
  });

  /// Çalışma süresince işlenen toplam hacim (m³).
  final double totalVolumeM3;

  /// Bulamaç kütlesi (kg).
  final double slurryMassKg;

  /// Kuru katı kütlesi (kg).
  final double dryMassKg;

  /// Kuru katı, ton/gün (1 ton = 1000 kg).
  final double dryTonsPerDay;
}

/// Kuru katı yükü: kg/saat = debi (m³/h) × yoğunluk (kg/m³) × katı oranı.
///
/// [solidsWeightPercent] ağırlıkça yüzde (hacimce değil), 0–100 aralığında.
ThroughputResult dryTonsThroughput({
  required double feedM3h,
  required double slurryDensityKgPerM3,
  required double solidsWeightPercent,
  required double hoursPerDay,
}) {
  requirePositive(feedM3h, 'Besleme debisi');
  requirePositive(slurryDensityKgPerM3, 'Bulamaç yoğunluğu');
  requirePositive(hoursPerDay, 'Günlük çalışma saati');
  if (hoursPerDay > 24) {
    throw const CalculationException('Günlük çalışma saati 24 saatten büyük olamaz.');
  }
  if (!solidsWeightPercent.isFinite ||
      solidsWeightPercent < 0 ||
      solidsWeightPercent > 100) {
    throw const CalculationException('Katı oranı 0 ile 100 arasında olmalıdır.');
  }
  final totalVolumeM3 = feedM3h * hoursPerDay;
  final slurryMassKg = totalVolumeM3 * slurryDensityKgPerM3;
  final dryMassKg = slurryMassKg * solidsWeightPercent / 100;
  return ThroughputResult(
    totalVolumeM3: totalVolumeM3,
    slurryMassKg: slurryMassKg,
    dryMassKg: dryMassKg,
    dryTonsPerDay: dryMassKg / 1000,
  );
}
