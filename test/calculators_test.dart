import 'package:flutter_test/flutter_test.dart';
import 'package:polat_rd/calculators/belt_length.dart';
import 'package:polat_rd/calculators/differential_speed.dart';
import 'package:polat_rd/calculators/flow_rate.dart';
import 'package:polat_rd/calculators/g_force.dart';
import 'package:polat_rd/calculators/mass_balance.dart';
import 'package:polat_rd/calculators/pulley.dart';
import 'package:polat_rd/calculators/throughput.dart';
import 'package:polat_rd/calculators/validation.dart';
import 'package:polat_rd/format.dart';

// Beklenen değerler, bağımsız bir Python referans hesabından alınmıştır.
void main() {
  group('G-Force (RCF)', () {
    test('0,5 m çap, 3000 RPM', () {
      expect(
        relativeCentrifugalForce(diameterM: 0.5, rpm: 3000),
        closeTo(2516.0489, 0.001),
      );
    });

    test('0,3 m çap, 1000 RPM', () {
      expect(
        relativeCentrifugalForce(diameterM: 0.3, rpm: 1000),
        closeTo(167.7366, 0.001),
      );
    });

    test('geçersiz girdi hata verir', () {
      expect(
        () => relativeCentrifugalForce(diameterM: 0, rpm: 3000),
        throwsA(isA<CalculationException>()),
      );
      expect(
        () => relativeCentrifugalForce(diameterM: 0.5, rpm: -1),
        throwsA(isA<CalculationException>()),
      );
    });
  });

  group('Diferansiyel hız', () {
    test('ileri yön: (ana - arka) / oran', () {
      expect(
        differentialSpeed(
          mainDriveRpm: 3000,
          backDriveRpm: 2900,
          gearboxRatio: 30,
          rotation: BackDriveRotation.forward,
        ),
        closeTo(3.3333, 0.0001),
      );
    });

    test('geri yön: (ana + arka) / oran', () {
      expect(
        differentialSpeed(
          mainDriveRpm: 3000,
          backDriveRpm: 2900,
          gearboxRatio: 30,
          rotation: BackDriveRotation.reverse,
        ),
        closeTo(196.6667, 0.0001),
      );
    });

    test('oran sıfır olamaz', () {
      expect(
        () => differentialSpeed(
          mainDriveRpm: 3000,
          backDriveRpm: 2900,
          gearboxRatio: 0,
          rotation: BackDriveRotation.forward,
        ),
        throwsA(isA<CalculationException>()),
      );
    });
  });

  group('Debi dönüştürücü', () {
    test('100 GPM -> LPM', () {
      expect(
        convertFlowRate(100, FlowUnit.gpm, FlowUnit.lpm),
        closeTo(378.5411784, 1e-6),
      );
    });

    test('100 GPM -> m3/saat', () {
      expect(
        convertFlowRate(100, FlowUnit.gpm, FlowUnit.m3h),
        closeTo(22.712470704, 1e-6),
      );
    });

    test('100 GPM -> BPD', () {
      expect(
        convertFlowRate(100, FlowUnit.gpm, FlowUnit.bpd),
        closeTo(3428.5714, 0.001),
      );
    });

    test('1000 BPD -> GPM', () {
      expect(
        convertFlowRate(1000, FlowUnit.bpd, FlowUnit.gpm),
        closeTo(29.1667, 0.001),
      );
    });

    test('60 m3/saat -> LPM', () {
      expect(
        convertFlowRate(60, FlowUnit.m3h, FlowUnit.lpm),
        closeTo(1000, 1e-9),
      );
    });

    test('aynı birime çevirme değeri değiştirmez', () {
      expect(convertFlowRate(42, FlowUnit.lpm, FlowUnit.lpm), closeTo(42, 1e-12));
    });
  });

  group('Kasnak hızı ve boyutu', () {
    test('çıkış mili devri', () {
      expect(
        drivenSpeedRpm(
          motorRpm: 1750,
          motorPulleyDiameter: 150,
          drivenPulleyDiameter: 300,
        ),
        closeTo(875, 1e-9),
      );
    });

    test('tahrik edilen kasnak çapı', () {
      expect(
        requiredPulleyDiameter(
          solveFor: PulleySolveFor.drivenPulley,
          otherPulleyDiameter: 150,
          motorRpm: 1750,
          drivenRpm: 3500,
        ),
        closeTo(75, 1e-9),
      );
    });

    test('motor kasnağı çapı', () {
      expect(
        requiredPulleyDiameter(
          solveFor: PulleySolveFor.motorPulley,
          otherPulleyDiameter: 300,
          motorRpm: 1750,
          drivenRpm: 3500,
        ),
        closeTo(600, 1e-9),
      );
    });
  });

  group('Kayış uzunluğu', () {
    test('300 mm / 150 mm kasnak, 600 mm eksen mesafesi', () {
      final mm = openBeltLengthMm(
        pulleyAMm: 300,
        pulleyBMm: 150,
        centerDistanceMm: 600,
      );
      expect(mm, closeTo(1916.2333, 0.001));
      expect(mmToInches(mm), closeTo(75.4423, 0.001));
      expect(mmToFeet(mm), closeTo(6.2869, 0.001));
    });

    test('kasnakların sırası sonucu değiştirmez', () {
      final a = openBeltLengthMm(
        pulleyAMm: 300,
        pulleyBMm: 150,
        centerDistanceMm: 600,
      );
      final b = openBeltLengthMm(
        pulleyAMm: 150,
        pulleyBMm: 300,
        centerDistanceMm: 600,
      );
      expect(a, closeTo(b, 1e-9));
    });

    test('çok kısa eksen mesafesi hata verir', () {
      expect(
        () => openBeltLengthMm(
          pulleyAMm: 300,
          pulleyBMm: 100,
          centerDistanceMm: 50,
        ),
        throwsA(isA<CalculationException>()),
      );
    });

    test('dar profilde olası kayış kodu üretilir', () {
      expect(possibleBeltDesignation('3V', 1916.2333), '3V754');
      expect(possibleBeltDesignation('5VX', 2540), '5VX1000');
    });

    test('A/B/C profillerinde kod üretilmez', () {
      expect(possibleBeltDesignation('B', 1916.2333), isNull);
      expect(possibleBeltDesignation('none', 1916.2333), isNull);
    });
  });

  group('Throughput', () {
    test('100 m³/h, 1000 kg/m³, %5, 24 saat', () {
      final r = dryTonsThroughput(
        feedM3h: 100,
        slurryDensityKgPerM3: 1000,
        solidsWeightPercent: 5,
        hoursPerDay: 24,
      );
      expect(r.totalVolumeM3, closeTo(2400, 1e-6));
      expect(r.slurryMassKg, closeTo(2400000, 1e-6));
      expect(r.dryMassKg, closeTo(120000, 1e-6));
      expect(r.dryTonsPerDay, closeTo(120, 1e-9));
    });

    test('20 m³/h, 1050 kg/m³, %4, 20 saat', () {
      final r = dryTonsThroughput(
        feedM3h: 20,
        slurryDensityKgPerM3: 1050,
        solidsWeightPercent: 4,
        hoursPerDay: 20,
      );
      expect(r.totalVolumeM3, closeTo(400, 1e-6));
      expect(r.slurryMassKg, closeTo(420000, 1e-6));
      expect(r.dryTonsPerDay, closeTo(16.8, 1e-9));
    });

    test('katı oranı 0-100 dışında olamaz', () {
      expect(
        () => dryTonsThroughput(
          feedM3h: 20,
          slurryDensityKgPerM3: 1050,
          solidsWeightPercent: 101,
          hoursPerDay: 20,
        ),
        throwsA(isA<CalculationException>()),
      );
    });

    test('günlük saat 24 saati aşamaz', () {
      expect(
        () => dryTonsThroughput(
          feedM3h: 20,
          slurryDensityKgPerM3: 1050,
          solidsWeightPercent: 10,
          hoursPerDay: 25,
        ),
        throwsA(isA<CalculationException>()),
      );
    });
  });

  group('Dekantör kütle denkliği', () {
    // Ekran görüntüsündeki hesap sayfasının değerleri.
    MassBalanceResult sheet() => decanterMassBalance(
          feedFlowM3h: 7,
          feedDensityKgPerM3: 1000,
          feedSolidsPercent: 1.13,
          cakeSolidsPercent: 18,
          centrateSolidsPercent: 0.05,
          polymerConcentrationPercent: 0.1,
          polymerSolutionLph: 800,
        );

    test('besleme: 7000 kg/h, 79,1 kg/h kuru katı, 6920,9 kg/h su', () {
      final r = sheet();
      expect(r.feedMassKgH, closeTo(7000, 1e-9));
      expect(r.feedSolidsKgH, closeTo(79.1, 1e-9));
      expect(r.feedWaterPercent, closeTo(98.87, 1e-9));
      expect(r.feedWaterKgH, closeTo(6920.9, 1e-9));
    });

    test('kek çıkışı: 421,17 kg/h, 75,81 kg/h kuru katı, 345,36 kg/h su', () {
      final r = sheet();
      expect(r.cakeMassKgH, closeTo(421.16992, 1e-4));
      expect(r.cakeSolidsKgH, closeTo(75.81058, 1e-4));
      expect(r.cakeWaterPercent, closeTo(82, 1e-9));
      expect(r.cakeWaterKgH, closeTo(345.35933, 1e-4));
    });

    test('sentrat çıkışı: 6578,83 kg/h, 3,29 kg/h kuru katı, 6575,54 kg/h su', () {
      final r = sheet();
      expect(r.centrateMassKgH, closeTo(6578.83008, 1e-4));
      expect(r.centrateSolidsKgH, closeTo(3.28942, 1e-4));
      expect(r.centrateWaterPercent, closeTo(99.95, 1e-9));
      expect(r.centrateWaterKgH, closeTo(6575.54067, 1e-4));
      expect(r.centrateAkmMgL, closeTo(500, 1e-9));
    });

    test('toplam kütle ve katı kütlesi korunur', () {
      final r = sheet();
      expect(r.cakeMassKgH + r.centrateMassKgH, closeTo(r.feedMassKgH, 1e-9));
      expect(
        r.cakeSolidsKgH + r.centrateSolidsKgH,
        closeTo(r.feedSolidsKgH, 1e-9),
      );
    });

    test('yakalama verimi %95,58 (konsantrasyon bazlı), katı geri kazanımı %95,84', () {
      final r = sheet();
      expect(r.captureEfficiencyPercent, closeTo(95.57522, 1e-4));
      expect(r.solidsRecoveryPercent, closeTo(95.84145, 1e-4));
    });

    test('polimer: 0,8 kg/h ve 10,11 kg/tKM', () {
      final r = sheet();
      expect(r.polymerKgH, closeTo(0.8, 1e-9));
      expect(r.polymerKgPerTonDs, closeTo(10.11378, 1e-4));
    });

    test('günlük değerler: 168 m³, 10,11 ton kek, 157,89 m³ sentrat', () {
      final r = sheet();
      expect(r.dailyFeedM3, closeTo(168, 1e-9));
      expect(r.dailyCakeTons, closeTo(10.10808, 1e-4));
      expect(r.dailyCentrateM3, closeTo(157.89192, 1e-4));
    });

    test('farklı yoğunluk ve çalışma süresi', () {
      final r = decanterMassBalance(
        feedFlowM3h: 20,
        feedDensityKgPerM3: 1030,
        feedSolidsPercent: 3,
        cakeSolidsPercent: 22,
        centrateSolidsPercent: 0.2,
        polymerConcentrationPercent: 0.2,
        polymerSolutionLph: 500,
        hoursPerDay: 20,
      );
      expect(r.feedMassKgH, closeTo(20600, 1e-9));
      expect(r.cakeMassKgH, closeTo(2645.87156, 1e-4));
      expect(r.centrateMassKgH, closeTo(17954.12844, 1e-4));
      expect(r.captureEfficiencyPercent, closeTo(93.33333, 1e-4));
      expect(r.polymerKgPerTonDs, closeTo(1.61812, 1e-4));
      expect(r.dailyCakeTons, closeTo(52.91743, 1e-4));
      expect(r.dailyFeedM3, closeTo(400, 1e-9));
    });

    test('kek katı oranı beslemeden büyük olmalı', () {
      expect(
        () => decanterMassBalance(
          feedFlowM3h: 7,
          feedDensityKgPerM3: 1000,
          feedSolidsPercent: 5,
          cakeSolidsPercent: 4,
          centrateSolidsPercent: 0.05,
          polymerConcentrationPercent: 0.1,
          polymerSolutionLph: 800,
        ),
        throwsA(isA<CalculationException>()),
      );
    });

    test('besleme katı oranı sentrattan büyük olmalı', () {
      expect(
        () => decanterMassBalance(
          feedFlowM3h: 7,
          feedDensityKgPerM3: 1000,
          feedSolidsPercent: 0.04,
          cakeSolidsPercent: 18,
          centrateSolidsPercent: 0.05,
          polymerConcentrationPercent: 0.1,
          polymerSolutionLph: 800,
        ),
        throwsA(isA<CalculationException>()),
      );
    });

    test('% orandan AKM (mg/L): 0,10 % = 1000 mg/L', () {
      expect(percentToAkmMgL(0.10), closeTo(1000, 1e-9));
      expect(percentToAkmMgL(1), closeTo(10000, 1e-9));
      expect(
        () => percentToAkmMgL(101),
        throwsA(isA<CalculationException>()),
      );
    });
  });

  group('Sayı biçimi ve ayrıştırma', () {
    test('formatNumber Türkçe biçim kullanır', () {
      expect(formatNumber(1234567.891), '1.234.567,89');
      expect(formatNumber(0.5), '0,50');
      expect(formatNumber(-3.5, decimals: 1), '-3,5');
      expect(formatNumber(144000, decimals: 0), '144.000');
    });

    test('parseNumber farklı yazımları kabul eder', () {
      expect(parseNumber('3000'), 3000);
      expect(parseNumber('12,5'), 12.5);
      expect(parseNumber('12.5'), 12.5);
      expect(parseNumber('1.234,5'), 1234.5);
      expect(parseNumber(' 7 '), 7);
    });

    test('parseNumber geçersiz girdide null döner', () {
      expect(parseNumber(''), isNull);
      expect(parseNumber('abc'), isNull);
    });
  });
}
