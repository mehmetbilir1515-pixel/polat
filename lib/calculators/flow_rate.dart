import 'validation.dart';

/// Desteklenen debi birimleri. Sıra, listelerde gösterilen sıradır (ilk: m³/h).
enum FlowUnit {
  m3h,
  lpm,
  m3s,
  m3min,
  m3day,
  ls,
  lh,
  gpm,
  gph,
  gpd,
  bpd,
  cfm,
  cfh,
}

const double _litersPerUsGallon = 3.785411784;
const double _litersPerBarrel = 42 * _litersPerUsGallon; // petrol varili
const double _litersPerCubicFoot = 28.316846592;

/// 1 birim debinin litre/dakika karşılığı.
double _lpmPerUnit(FlowUnit unit) {
  return switch (unit) {
    FlowUnit.m3h => 1000 / 60,
    FlowUnit.lpm => 1.0,
    FlowUnit.m3s => 60000,
    FlowUnit.m3min => 1000,
    FlowUnit.m3day => 1000 / 1440,
    FlowUnit.ls => 60,
    FlowUnit.lh => 1 / 60,
    FlowUnit.gpm => _litersPerUsGallon, // ABD galonu / dakika
    FlowUnit.gph => _litersPerUsGallon / 60,
    FlowUnit.gpd => _litersPerUsGallon / 1440,
    FlowUnit.bpd => _litersPerBarrel / 1440, // varil / gün
    FlowUnit.cfm => _litersPerCubicFoot, // ft³ / dakika
    FlowUnit.cfh => _litersPerCubicFoot / 60,
  };
}

String flowUnitLabel(FlowUnit unit) {
  return switch (unit) {
    FlowUnit.m3h => 'm³/h',
    FlowUnit.lpm => 'L/dk (LPM)',
    FlowUnit.m3s => 'm³/s',
    FlowUnit.m3min => 'm³/dk',
    FlowUnit.m3day => 'm³/gün',
    FlowUnit.ls => 'L/s',
    FlowUnit.lh => 'L/h',
    FlowUnit.gpm => 'GPM (ABD gal/dk)',
    FlowUnit.gph => 'GPH (ABD gal/h)',
    FlowUnit.gpd => 'GPD (ABD gal/gün)',
    FlowUnit.bpd => 'BPD (varil/gün)',
    FlowUnit.cfm => 'CFM (ft³/dk)',
    FlowUnit.cfh => 'ft³/h',
  };
}

/// [value] debisini [from] biriminden [to] birimine çevirir.
double convertFlowRate(double value, FlowUnit from, FlowUnit to) {
  requireNonNegative(value, 'Debi');
  return value * _lpmPerUnit(from) / _lpmPerUnit(to);
}
