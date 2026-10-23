import 'validation.dart';

/// Hangi kasnağın çapı hesaplanacak.
enum PulleySolveFor { drivenPulley, motorPulley }

/// Çıkış mili (tahrik edilen) devri: N2 = N1 · D1 / D2.
///
/// Kasnak çapları aynı birimde olmalıdır.
double drivenSpeedRpm({
  required double motorRpm,
  required double motorPulleyDiameter,
  required double drivenPulleyDiameter,
}) {
  requirePositive(motorRpm, 'Motor devri');
  requirePositive(motorPulleyDiameter, 'Motor kasnağı çapı');
  requirePositive(drivenPulleyDiameter, 'Tahrik edilen kasnak çapı');
  return motorRpm * motorPulleyDiameter / drivenPulleyDiameter;
}

/// Hedef devir için gereken kasnak çapı (girdiyle aynı birimde).
///
/// [PulleySolveFor.drivenPulley]: D2 = D1 · N1 / N2 ([otherPulleyDiameter] = motor kasnağı).
/// [PulleySolveFor.motorPulley]: D1 = D2 · N2 / N1 ([otherPulleyDiameter] = tahrik edilen kasnak).
double requiredPulleyDiameter({
  required PulleySolveFor solveFor,
  required double otherPulleyDiameter,
  required double motorRpm,
  required double drivenRpm,
}) {
  requirePositive(otherPulleyDiameter, 'Bilinen kasnak çapı');
  requirePositive(motorRpm, 'Motor devri');
  requirePositive(drivenRpm, 'Hedef devir');
  return switch (solveFor) {
    PulleySolveFor.drivenPulley => otherPulleyDiameter * motorRpm / drivenRpm,
    PulleySolveFor.motorPulley => otherPulleyDiameter * drivenRpm / motorRpm,
  };
}
