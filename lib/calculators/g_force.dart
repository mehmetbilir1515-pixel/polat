import 'dart:math' as math;

import 'validation.dart';

/// Standart yerçekimi ivmesi (m/s²).
const double standardGravity = 9.80665;

/// Bağıl santrifüj kuvveti (RCF), g cinsinden.
///
/// [diameterM] tambur iç çapı (metre), [rpm] devir/dakika.
/// RCF = ω² · r / g, ω = 2π·RPM/60, r = çap / 2.
double relativeCentrifugalForce({
  required double diameterM,
  required double rpm,
}) {
  requirePositive(diameterM, 'Tambur iç çapı');
  requirePositive(rpm, 'Devir (RPM)');
  final omega = 2 * math.pi * rpm / 60;
  return omega * omega * (diameterM / 2) / standardGravity;
}

/// Ters hesap: hedef santrifüj kuvvetinden (g) gereken devir, RPM.
///
/// RCF = ω² · r / g  =>  ω = √(RCF · g / r), RPM = ω · 60 / (2π).
double rpmForCentrifugalForce({
  required double diameterM,
  required double rcf,
}) {
  requirePositive(diameterM, 'Tambur iç çapı');
  requirePositive(rcf, 'Santrifüj kuvveti');
  final omega = math.sqrt(rcf * standardGravity / (diameterM / 2));
  return omega * 60 / (2 * math.pi);
}
