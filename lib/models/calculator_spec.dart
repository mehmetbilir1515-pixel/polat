import 'package:flutter/material.dart';

/// Bir girdi alanı için birim seçeneği; [toBase] değeri hesaplama birimine çevirir.
class UnitOption {
  const UnitOption(this.label, this.toBase);

  final String label;
  final double toBase;
}

/// Sayısal girdi alanı.
class NumberFieldSpec {
  const NumberFieldSpec({
    required this.key,
    required this.label,
    required this.units,
  });

  final String key;
  final String label;
  final List<UnitOption> units;
}

class ChoiceOption {
  const ChoiceOption(this.value, this.label);

  final String value;
  final String label;
}

/// Açılır listeden seçilen girdi (yön, birim, profil vb.).
class ChoiceFieldSpec {
  const ChoiceFieldSpec({
    required this.key,
    required this.label,
    required this.options,
  });

  final String key;
  final String label;
  final List<ChoiceOption> options;
}

class ResultItem {
  const ResultItem(this.label, this.value, {this.primary = false});

  final String label;
  final String value;
  final bool primary;
}

typedef CalculateFn = List<ResultItem> Function(
  Map<String, double> numbers,
  Map<String, String> choices,
);

/// Bir hesaplama aracının arayüz tanımı.
class CalculatorSpec {
  CalculatorSpec({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.numberFields,
    required this.calculate,
    this.choiceFields = const [],
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<NumberFieldSpec> numberFields;
  final List<ChoiceFieldSpec> choiceFields;

  /// Sayısal değerler hesaplama birimine (taban birim) çevrilmiş olarak gelir.
  final CalculateFn calculate;
}
