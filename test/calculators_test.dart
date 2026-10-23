import 'package:flutter_test/flutter_test.dart';
import 'package:polat_rd/calculators/belt_length.dart';
import 'package:polat_rd/calculators/differential_speed.dart';
import 'package:polat_rd/calculators/flow_rate.dart';
import 'package:polat_rd/calculators/g_force.dart';
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
    test('100 GPM, 10 lb/gal, %5, 24 saat', () {
      final r = dryTonsThroughput(
        feedGpm: 100,
        slurryDensityLbPerGal: 10,
        solidsWeightPercent: 5,
        hoursPerDay: 24,
      );
      expect(r.totalGallons, closeTo(144000, 1e-6));
      expect(r.slurryMassLb, closeTo(1440000, 1e-6));
      expect(r.dryMassLb, closeTo(72000, 1e-6));
      expect(r.dryTonsPerDay, closeTo(36, 1e-9));
    });

    test('50 GPM, 8,7 lb/gal, %12, 20 saat', () {
      final r = dryTonsThroughput(
        feedGpm: 50,
        slurryDensityLbPerGal: 8.7,
        solidsWeightPercent: 12,
        hoursPerDay: 20,
      );
      expect(r.totalGallons, closeTo(60000, 1e-6));
      expect(r.dryTonsPerDay, closeTo(31.32, 1e-9));
    });

    test('katı oranı 0-100 dışında olamaz', () {
      expect(
        () => dryTonsThroughput(
          feedGpm: 50,
          slurryDensityLbPerGal: 8.7,
          solidsWeightPercent: 101,
          hoursPerDay: 20,
        ),
        throwsA(isA<CalculationException>()),
      );
    });

    test('günlük saat 24 saati aşamaz', () {
      expect(
        () => dryTonsThroughput(
          feedGpm: 50,
          slurryDensityLbPerGal: 8.7,
          solidsWeightPercent: 10,
          hoursPerDay: 25,
        ),
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
