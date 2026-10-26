import 'package:flutter/material.dart';

import 'calculators/belt_length.dart';
import 'calculators/differential_speed.dart';
import 'calculators/flow_rate.dart';
import 'calculators/g_force.dart';
import 'calculators/pulley.dart';
import 'calculators/throughput.dart';
import 'format.dart';
import 'models/calculator_spec.dart';

const _single = UnitOption('', 1);

const _lengthUnits = [
  UnitOption('mm', 1),
  UnitOption('inç', 25.4),
];

const _pulleyUnits = [
  UnitOption('mm', 1),
  UnitOption('inç', 25.4),
  UnitOption('cm', 10),
];

/// Uygulamadaki tüm hesaplama araçları (ana ekranda bu sırayla listelenir).
final List<CalculatorSpec> calculatorSpecs = [
  // 1) G-Force (RCF)
  CalculatorSpec(
    id: 'g-force',
    title: 'G-Force (RCF) Hesaplayıcı',
    description: 'Tambur iç çapı ve devirden santrifüj kuvvetini (g) hesaplar.',
    icon: Icons.rotate_right,
    numberFields: const [
      NumberFieldSpec(
        key: 'diameter',
        label: 'Tambur iç çapı',
        units: [
          UnitOption('mm', 0.001),
          UnitOption('cm', 0.01),
          UnitOption('inç', 0.0254),
          UnitOption('m', 1),
        ],
      ),
      NumberFieldSpec(
        key: 'rpm',
        label: 'Devir (RPM)',
        units: [UnitOption('RPM', 1)],
      ),
    ],
    calculate: (n, c) {
      final rcf = relativeCentrifugalForce(
        diameterM: n['diameter']!,
        rpm: n['rpm']!,
      );
      return [
        ResultItem(
          'Santrifüj kuvveti (RCF)',
          '${formatNumber(rcf, decimals: 1)} × g',
          primary: true,
        ),
      ];
    },
  ),

  // 2) Diferansiyel hız
  CalculatorSpec(
    id: 'differential-speed',
    title: 'Diferansiyel Hız Hesaplayıcı',
    description: 'Tambur ile helezon arasındaki hız farkını hesaplar.',
    icon: Icons.compare_arrows,
    choiceFields: const [
      ChoiceFieldSpec(
        key: 'rotation',
        label: 'Arka tahrik dönüş yönü',
        options: [
          ChoiceOption('forward', 'İleri'),
          ChoiceOption('reverse', 'Geri'),
        ],
      ),
    ],
    numberFields: const [
      NumberFieldSpec(
        key: 'main',
        label: 'Ana tahrik devri',
        units: [UnitOption('RPM', 1)],
      ),
      NumberFieldSpec(
        key: 'back',
        label: 'Arka tahrik devri',
        units: [UnitOption('RPM', 1)],
      ),
      NumberFieldSpec(
        key: 'ratio',
        label: 'Dişli kutusu oranı (x : 1)',
        units: [_single],
      ),
    ],
    calculate: (n, c) {
      final diff = differentialSpeed(
        mainDriveRpm: n['main']!,
        backDriveRpm: n['back']!,
        gearboxRatio: n['ratio']!,
        rotation: c['rotation'] == 'reverse'
            ? BackDriveRotation.reverse
            : BackDriveRotation.forward,
      );
      return [
        ResultItem(
          'Diferansiyel hız',
          '${formatNumber(diff, decimals: 2)} RPM',
          primary: true,
        ),
      ];
    },
  ),

  // 3) Debi dönüştürücü
  CalculatorSpec(
    id: 'flow-rate',
    title: 'Debi Dönüştürücü',
    description: 'GPM, LPM, m³/saat ve BPD arasında çeviri yapar.',
    icon: Icons.water_drop_outlined,
    choiceFields: [
      ChoiceFieldSpec(
        key: 'from',
        label: 'Çevrilecek birim',
        options: [
          for (final u in FlowUnit.values) ChoiceOption(u.name, flowUnitLabel(u)),
        ],
      ),
      ChoiceFieldSpec(
        key: 'to',
        label: 'Hedef birim',
        options: [
          for (final u in FlowUnit.values) ChoiceOption(u.name, flowUnitLabel(u)),
        ],
      ),
    ],
    numberFields: const [
      NumberFieldSpec(key: 'value', label: 'Değer', units: [_single]),
    ],
    calculate: (n, c) {
      final from = FlowUnit.values.byName(c['from']!);
      final to = FlowUnit.values.byName(c['to']!);
      final converted = convertFlowRate(n['value']!, from, to);
      return [
        ResultItem(
          'Sonuç',
          '${formatNumber(converted, decimals: 3)} ${flowUnitLabel(to)}',
          primary: true,
        ),
        for (final u in FlowUnit.values)
          ResultItem(
            'Eşdeğer: ${flowUnitLabel(u)}',
            formatNumber(convertFlowRate(n['value']!, from, u), decimals: 3),
          ),
      ];
    },
  ),

  // 4) Kasnak hızı
  CalculatorSpec(
    id: 'pulley-speed',
    title: 'Kasnak Hızı Hesaplayıcı',
    description: 'Motor devri ve kasnak çaplarından çıkış mili devrini hesaplar.',
    icon: Icons.settings_outlined,
    numberFields: const [
      NumberFieldSpec(
        key: 'motorRpm',
        label: 'Motor devri',
        units: [UnitOption('RPM', 1)],
      ),
      NumberFieldSpec(
        key: 'motorPulley',
        label: 'Motor kasnağı çapı',
        units: _pulleyUnits,
      ),
      NumberFieldSpec(
        key: 'drivenPulley',
        label: 'Tahrik edilen kasnak çapı',
        units: _pulleyUnits,
      ),
    ],
    calculate: (n, c) {
      final speed = drivenSpeedRpm(
        motorRpm: n['motorRpm']!,
        motorPulleyDiameter: n['motorPulley']!,
        drivenPulleyDiameter: n['drivenPulley']!,
      );
      final ratio = n['motorPulley']! / n['drivenPulley']!;
      return [
        ResultItem(
          'Çıkış mili devri',
          '${formatNumber(speed, decimals: 1)} RPM',
          primary: true,
        ),
        ResultItem('Hız oranı (çıkış / motor)', formatNumber(ratio, decimals: 3)),
      ];
    },
  ),

  // 5) Kayış uzunluğu
  CalculatorSpec(
    id: 'belt-length',
    title: 'Kayış Uzunluğu Hesaplayıcı',
    description: 'Kasnak çapları ve eksen mesafesinden tahmini kayış uzunluğunu bulur.',
    icon: Icons.sync_alt,
    choiceFields: const [
      ChoiceFieldSpec(
        key: 'profile',
        label: 'Kayış profili (isteğe bağlı)',
        options: [
          ChoiceOption('none', 'Emin değilim'),
          ChoiceOption('3V', '3V'),
          ChoiceOption('3VX', '3VX'),
          ChoiceOption('5V', '5V'),
          ChoiceOption('5VX', '5VX'),
          ChoiceOption('8V', '8V'),
          ChoiceOption('8VX', '8VX'),
          ChoiceOption('A', 'A'),
          ChoiceOption('AX', 'AX'),
          ChoiceOption('B', 'B'),
          ChoiceOption('BX', 'BX'),
          ChoiceOption('C', 'C'),
          ChoiceOption('CX', 'CX'),
        ],
      ),
    ],
    numberFields: const [
      NumberFieldSpec(key: 'motor', label: 'Motor kasnağı çapı', units: _lengthUnits),
      NumberFieldSpec(
        key: 'driven',
        label: 'Tahrik edilen kasnak çapı',
        units: _lengthUnits,
      ),
      NumberFieldSpec(
        key: 'center',
        label: 'Eksenler arası mesafe',
        units: _lengthUnits,
      ),
    ],
    calculate: (n, c) {
      final mm = openBeltLengthMm(
        pulleyAMm: n['motor']!,
        pulleyBMm: n['driven']!,
        centerDistanceMm: n['center']!,
      );
      final profile = c['profile'] ?? 'none';
      final designation = possibleBeltDesignation(profile, mm);
      return [
        ResultItem(
          'Tahmini kayış uzunluğu',
          '${formatNumber(mmToInches(mm), decimals: 2)} inç',
          primary: true,
        ),
        ResultItem('Milimetre', '${formatNumber(mm, decimals: 1)} mm'),
        ResultItem('Feet', '${formatNumber(mmToFeet(mm), decimals: 2)} ft'),
        if (profile != 'none')
          ResultItem(
            'Olası kayış kodu',
            designation ?? 'Bu profil için katalogdan doğrulayın',
          ),
        const ResultItem(
          'Not',
          'Tahmindir. Kayış numarası üreticiye göre değişir; sipariş öncesi tedarikçiyle doğrulayın.',
        ),
      ];
    },
  ),

  // 6) Santrifüj throughput
  CalculatorSpec(
    id: 'throughput',
    title: 'Santrifüj Throughput Hesaplayıcı',
    description: 'Giren kuru katı miktarını (ton/gün) tahmin eder.',
    icon: Icons.scale_outlined,
    numberFields: const [
      NumberFieldSpec(
        key: 'flow',
        label: 'Besleme debisi',
        units: [UnitOption('m³/h', 1)],
      ),
      NumberFieldSpec(
        key: 'density',
        label: 'Bulamaç yoğunluğu',
        units: [UnitOption('kg/m³', 1)],
      ),
      NumberFieldSpec(
        key: 'solids',
        label: 'Katı oranı (ağırlıkça)',
        units: [UnitOption('wt%', 1)],
      ),
      NumberFieldSpec(
        key: 'hours',
        label: 'Günlük çalışma saati',
        units: [UnitOption('saat', 1)],
      ),
    ],
    calculate: (n, c) {
      final r = dryTonsThroughput(
        feedM3h: n['flow']!,
        slurryDensityKgPerM3: n['density']!,
        solidsWeightPercent: n['solids']!,
        hoursPerDay: n['hours']!,
      );
      return [
        ResultItem(
          'Kuru katı',
          '${formatNumber(r.dryTonsPerDay, decimals: 2)} ton/gün',
          primary: true,
        ),
        ResultItem('Toplam hacim', '${formatNumber(r.totalVolumeM3, decimals: 1)} m³'),
        ResultItem('Bulamaç kütlesi', '${formatNumber(r.slurryMassKg, decimals: 0)} kg'),
        ResultItem('Kuru katı kütlesi', '${formatNumber(r.dryMassKg, decimals: 0)} kg'),
        const ResultItem(
          'Not',
          'Yalnızca giren katı yükünü tahmin eder; geri kazanım, kek kuruluğu veya makine performansını öngörmez.',
        ),
      ];
    },
  ),

  // 7) Kasnak boyutu
  CalculatorSpec(
    id: 'pulley-size',
    title: 'Kasnak Boyutu Hesaplayıcı',
    description: 'Hedef devir için gereken kasnak çapını hesaplar.',
    icon: Icons.straighten,
    choiceFields: const [
      ChoiceFieldSpec(
        key: 'solveFor',
        label: 'Hesaplanacak kasnak',
        options: [
          ChoiceOption('drivenPulley', 'Tahrik edilen kasnak'),
          ChoiceOption('motorPulley', 'Motor kasnağı'),
        ],
      ),
    ],
    numberFields: const [
      NumberFieldSpec(
        key: 'other',
        label: 'Diğer kasnağın çapı',
        units: _pulleyUnits,
      ),
      NumberFieldSpec(
        key: 'motorRpm',
        label: 'Motor devri',
        units: [UnitOption('RPM', 1)],
      ),
      NumberFieldSpec(
        key: 'drivenRpm',
        label: 'Hedef devir (ekipman)',
        units: [UnitOption('RPM', 1)],
      ),
    ],
    calculate: (n, c) {
      final solveFor = c['solveFor'] == 'motorPulley'
          ? PulleySolveFor.motorPulley
          : PulleySolveFor.drivenPulley;
      final mm = requiredPulleyDiameter(
        solveFor: solveFor,
        otherPulleyDiameter: n['other']!,
        motorRpm: n['motorRpm']!,
        drivenRpm: n['drivenRpm']!,
      );
      return [
        ResultItem(
          solveFor == PulleySolveFor.motorPulley
              ? 'Gereken motor kasnağı çapı'
              : 'Gereken tahrik edilen kasnak çapı',
          '${formatNumber(mm, decimals: 1)} mm',
          primary: true,
        ),
        ResultItem('İnç', '${formatNumber(mm / 25.4, decimals: 2)} inç'),
      ];
    },
  ),
];
