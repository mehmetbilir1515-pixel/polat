import 'package:flutter/material.dart';

import '../calculators/validation.dart';
import '../format.dart';
import '../models/calculator_spec.dart';

/// Bir [CalculatorSpec] tanımından otomatik oluşturulan hesaplama ekranı.
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key, required this.spec});

  final CalculatorSpec spec;

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, int> _unitIndex = {};
  final Map<String, String> _choices = {};
  List<ResultItem>? _results;
  String? _error;

  @override
  void initState() {
    super.initState();
    _resetSelections();
  }

  void _resetSelections() {
    for (final field in widget.spec.numberFields) {
      _controllers.putIfAbsent(field.key, TextEditingController.new);
      _unitIndex[field.key] = 0;
    }
    for (final field in widget.spec.choiceFields) {
      _choices[field.key] = field.defaultValue ?? field.options.first.value;
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _showRule(Map<String, String>? rule) {
    if (rule == null) {
      return true;
    }
    return rule.entries.every((e) => _choices[e.key] == e.value);
  }

  bool _isVisible(NumberFieldSpec field) => _showRule(field.showWhen);

  void _calculate() {
    FocusScope.of(context).unfocus();
    final numbers = <String, double>{};
    for (final field in widget.spec.numberFields.where(_isVisible)) {
      final parsed = parseNumber(_controllers[field.key]!.text);
      if (parsed == null) {
        setState(() {
          _results = null;
          _error = '"${field.label}" için geçerli bir sayı girin.';
        });
        return;
      }
      numbers[field.key] = parsed * field.units[_unitIndex[field.key]!].toBase;
    }
    try {
      final results = widget.spec.calculate(numbers, Map.of(_choices));
      setState(() {
        _results = results;
        _error = null;
      });
    } on CalculationException catch (e) {
      setState(() {
        _results = null;
        _error = e.message;
      });
    }
  }

  void _reset() {
    FocusScope.of(context).unfocus();
    setState(() {
      for (final controller in _controllers.values) {
        controller.clear();
      }
      _resetSelections();
      _results = null;
      _error = null;
    });
  }

  Widget _buildChoiceField(ChoiceFieldSpec field) {
    return Padding(
      key: ValueKey('choice-${field.key}'),
      padding: const EdgeInsets.only(bottom: 16),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: field.label,
          border: const OutlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: _choices[field.key],
            items: [
              for (final option in field.options)
                DropdownMenuItem<String>(
                  value: option.value,
                  child: Text(option.label),
                ),
            ],
            onChanged: (value) {
              if (value != null) {
                // Seçim değişince (örn. hesaplama modu) eski sonuç geçersizdir.
                setState(() {
                  _choices[field.key] = value;
                  _results = null;
                  _error = null;
                });
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(NumberFieldSpec field) {
    final hasUnitChoice = field.units.length > 1;
    final singleLabel = field.units.first.label;
    return Padding(
      key: ValueKey('field-${field.key}'),
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: _controllers[field.key],
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: field.label,
                border: const OutlineInputBorder(),
                suffixText:
                    (!hasUnitChoice && singleLabel.isNotEmpty) ? singleLabel : null,
              ),
              onSubmitted: (_) => _calculate(),
            ),
          ),
          if (hasUnitChoice) ...[
            const SizedBox(width: 8),
            SizedBox(
              width: 88,
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: _unitIndex[field.key],
                    items: [
                      for (var i = 0; i < field.units.length; i++)
                        DropdownMenuItem<int>(
                          value: i,
                          child: Text(field.units[i].label),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _unitIndex[field.key] = value);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final item in _results!)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: item.primary
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.label, style: theme.textTheme.labelLarge),
                          Text(
                            item.value,
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.label, style: theme.textTheme.labelMedium),
                          Text(item.value, style: theme.textTheme.bodyMedium),
                        ],
                      ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spec = widget.spec;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(spec.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(spec.description, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              for (final field in spec.choiceFields.where((f) => _showRule(f.showWhen)))
                _buildChoiceField(field),
              for (final field in spec.numberFields.where(_isVisible)) _buildNumberField(field),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _calculate,
                      child: const Text('Hesapla'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: _reset,
                    child: const Text('Sıfırla'),
                  ),
                ],
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              if (_results != null) _buildResults(context),
            ],
          ),
        ),
      ),
    );
  }
}
