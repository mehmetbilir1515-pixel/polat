import 'dart:math' as math;

import 'validation.dart';

/// Standart yerçekimi ivmesi (m/s²).
const double standardGravity = 9.80665;

/// Bağıl santrifüj kuvveti (RCF), g cinsinden.
///
/// [diameterM] kasa çapı (metre), [rpm] devir/dakika.
/// RCF = ω² · r / g, ω = 2π·RPM/60, r = çap / 2.
double relativeCentrifugalForce({
  required double diameterM,
  required double rpm,
}) {
  requirePositive(diameterM, 'Kasa çapı');
  requirePositive(rpm, 'Devir (RPM)');
  final omega = 2 * math.pi * rpm / 60;
  return omega * omega * (diameterM / 2) / standardGravity;
}
