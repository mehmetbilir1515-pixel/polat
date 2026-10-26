import 'validation.dart';

/// Dekantör kütle denkliği sonuçları. Kütle akışları kg/h, günlük değerler 24 saat için.
class MassBalanceResult {
  const MassBalanceResult({
    required this.feedMassKgH,
    required this.feedSolidsKgH,
    required this.feedWaterPercent,
    required this.feedWaterKgH,
    required this.cakeMassKgH,
    required this.cakeSolidsKgH,
    required this.cakeWaterPercent,
    required this.cakeWaterKgH,
    required this.centrateMassKgH,
    required this.centrateSolidsKgH,
    required this.centrateWaterPercent,
    required this.centrateWaterKgH,
    required this.centrateAkmMgL,
    required this.captureEfficiencyPercent,
    required this.solidsRecoveryPercent,
    required this.polymerKgH,
    required this.polymerKgPerTonDs,
    required this.dailyFeedM3,
    required this.dailyCakeTons,
    required this.dailyCentrateM3,
  });

  final double feedMassKgH;
  final double feedSolidsKgH;
  final double feedWaterPercent;
  final double feedWaterKgH;

  final double cakeMassKgH;
  final double cakeSolidsKgH;
  final double cakeWaterPercent;
  final double cakeWaterKgH;

  final double centrateMassKgH;
  final double centrateSolidsKgH;
  final double centrateWaterPercent;
  final double centrateWaterKgH;

  /// Sentrat askıda katı madde, mg/L (yoğunluk 1 kg/L varsayımıyla).
  final double centrateAkmMgL;

  /// Yakalama verimi (%), konsantrasyondan: (besleme − sentrat) / besleme.
  final double captureEfficiencyPercent;

  /// Kütle bazlı katı geri kazanımı (%): kekteki katı / beslemedeki katı.
  final double solidsRecoveryPercent;

  /// Polimer dozajı, kg/h (çözelti yoğunluğu 1 kg/L varsayımıyla).
  final double polymerKgH;

  /// Polimer tüketimi, kg polimer / ton kuru katı (beslemedeki kuru katıya göre).
  final double polymerKgPerTonDs;

  final double dailyFeedM3;
  final double dailyCakeTons;
  final double dailyCentrateM3;
}

/// Santrifüj dekantör için kütle denkliği.
///
/// Toplam kütle: F = C + S. Katı kütlesi: F·f = C·c + S·s.
/// Buradan kek kütlesi C = F·(f − s) / (c − s) bulunur.
/// Yüzdeler ağırlıkça (w/w) kuru katı madde oranıdır.
/// Polimer dozajı kütle denkliğinde ihmal edilir.
MassBalanceResult decanterMassBalance({
  required double feedFlowM3h,
  required double feedDensityKgPerM3,
  required double feedSolidsPercent,
  required double cakeSolidsPercent,
  required double centrateSolidsPercent,
  required double polymerConcentrationPercent,
  required double polymerSolutionLph,
  double hoursPerDay = 24,
}) {
  requirePositive(feedFlowM3h, 'Ürün debisi');
  requirePositive(feedDensityKgPerM3, 'Ürün yoğunluğu');
  requirePositive(feedSolidsPercent, 'Besleme kuru katı oranı');
  requirePositive(cakeSolidsPercent, 'Kek kuru katı oranı');
  requireNonNegative(centrateSolidsPercent, 'Sentrat kuru katı oranı');
  requireNonNegative(polymerConcentrationPercent, 'Polimer hazırlama oranı');
  requireNonNegative(polymerSolutionLph, 'Çözelti debisi');
  requirePositive(hoursPerDay, 'Günlük çalışma saati');

  if (feedSolidsPercent >= 100 || cakeSolidsPercent > 100 || centrateSolidsPercent >= 100) {
    throw const CalculationException('Katı oranları 100 değerinin altında olmalıdır.');
  }
  if (polymerConcentrationPercent > 100) {
    throw const CalculationException('Polimer hazırlama oranı 100 değerini aşamaz.');
  }
  if (feedSolidsPercent <= centrateSolidsPercent) {
    throw const CalculationException(
      'Besleme kuru katı oranı, sentrat kuru katı oranından büyük olmalıdır.',
    );
  }
  if (cakeSolidsPercent <= feedSolidsPercent) {
    throw const CalculationException(
      'Kek kuru katı oranı, besleme kuru katı oranından büyük olmalıdır.',
    );
  }

  final f = feedSolidsPercent;
  final c = cakeSolidsPercent;
  final s = centrateSolidsPercent;

  final feedMass = feedFlowM3h * feedDensityKgPerM3;
  final feedSolids = feedMass * f / 100;
  final cakeMass = feedMass * (f - s) / (c - s);
  final cakeSolids = cakeMass * c / 100;
  final centrateMass = feedMass - cakeMass;
  final centrateSolids = centrateMass * s / 100;
  final polymerKgH = polymerSolutionLph * polymerConcentrationPercent / 100;

  return MassBalanceResult(
    feedMassKgH: feedMass,
    feedSolidsKgH: feedSolids,
    feedWaterPercent: 100 - f,
    feedWaterKgH: feedMass - feedSolids,
    cakeMassKgH: cakeMass,
    cakeSolidsKgH: cakeSolids,
    cakeWaterPercent: 100 - c,
    cakeWaterKgH: cakeMass - cakeSolids,
    centrateMassKgH: centrateMass,
    centrateSolidsKgH: centrateSolids,
    centrateWaterPercent: 100 - s,
    centrateWaterKgH: centrateMass - centrateSolids,
    centrateAkmMgL: percentToAkmMgL(s),
    captureEfficiencyPercent: (f - s) / f * 100,
    solidsRecoveryPercent: cakeSolids / feedSolids * 100,
    polymerKgH: polymerKgH,
    polymerKgPerTonDs: polymerKgH / (feedSolids / 1000),
    dailyFeedM3: feedFlowM3h * hoursPerDay,
    dailyCakeTons: cakeMass * hoursPerDay / 1000,
    dailyCentrateM3: centrateMass * hoursPerDay / 1000,
  );
}

/// Ağırlıkça yüzde kuru maddeyi AKM'ye (mg/L) çevirir; 1 % = 10.000 mg/L (yoğunluk 1 kg/L).
double percentToAkmMgL(double percent) {
  requireNonNegative(percent, 'Kuru madde oranı');
  if (percent > 100) {
    throw const CalculationException('Kuru madde oranı 100 değerini aşamaz.');
  }
  return percent * 10000;
}
