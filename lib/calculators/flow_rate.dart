import 'validation.dart';

/// Desteklenen debi birimleri.
enum FlowUnit { gpm, lpm, m3h, bpd }

const double _litersPerUsGallon = 3.785411784;
const double _litersPerBarrel = 42 * _litersPerUsGallon; // petrol varili

/// 1 birim debinin litre/dakika karşılığı.
double _lpmPerUnit(FlowUnit unit) {
  return switch (unit) {
    FlowUnit.gpm => _litersPerUsGallon, // ABD galonu / dakika
    FlowUnit.lpm => 1.0,
    FlowUnit.m3h => 1000 / 60,
    FlowUnit.bpd => _litersPerBarrel / 1440, // varil / gün
  };
}

String flowUnitLabel(FlowUnit unit) {
  return switch (unit) {
    FlowUnit.gpm => 'GPM',
    FlowUnit.lpm => 'LPM',
    FlowUnit.m3h => 'm³/saat',
    FlowUnit.bpd => 'BPD',
  };
}

/// [value] debisini [from] biriminden [to] birimine çevirir.
double convertFlowRate(double value, FlowUnit from, FlowUnit to) {
  requireNonNegative(value, 'Debi');
  return value * _lpmPerUnit(from) / _lpmPerUnit(to);
}
