import 'validation.dart';

/// Santrifüje giren kuru katı yükünün tahmini.
class ThroughputResult {
  const ThroughputResult({
    required this.totalGallons,
    required this.slurryMassLb,
    required this.dryMassLb,
    required this.dryTonsPerDay,
  });

  /// Çalışma süresince işlenen toplam hacim (ABD galonu).
  final double totalGallons;

  /// Bulamaç kütlesi (lb).
  final double slurryMassLb;

  /// Kuru katı kütlesi (lb).
  final double dryMassLb;

  /// Kuru katı, kısa ton/gün (1 ton = 2000 lb).
  final double dryTonsPerDay;
}

/// Kuru katı yükü: lb/saat = GPM × 60 × yoğunluk × katı oranı.
///
/// [solidsWeightPercent] ağırlıkça yüzde (hacimce değil), 0–100 aralığında.
ThroughputResult dryTonsThroughput({
  required double feedGpm,
  required double slurryDensityLbPerGal,
  required double solidsWeightPercent,
  required double hoursPerDay,
}) {
  requirePositive(feedGpm, 'Besleme debisi');
  requirePositive(slurryDensityLbPerGal, 'Bulamaç yoğunluğu');
  requirePositive(hoursPerDay, 'Günlük çalışma saati');
  if (hoursPerDay > 24) {
    throw const CalculationException('Günlük çalışma saati 24 saatten büyük olamaz.');
  }
  if (!solidsWeightPercent.isFinite ||
      solidsWeightPercent < 0 ||
      solidsWeightPercent > 100) {
    throw const CalculationException('Katı oranı 0 ile 100 arasında olmalıdır.');
  }
  final totalGallons = feedGpm * 60 * hoursPerDay;
  final slurryMassLb = totalGallons * slurryDensityLbPerGal;
  final dryMassLb = slurryMassLb * solidsWeightPercent / 100;
  return ThroughputResult(
    totalGallons: totalGallons,
    slurryMassLb: slurryMassLb,
    dryMassLb: dryMassLb,
    dryTonsPerDay: dryMassLb / 2000,
  );
}
