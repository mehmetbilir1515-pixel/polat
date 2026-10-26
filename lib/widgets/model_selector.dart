import 'package:flutter/material.dart';

import '../theme.dart';

/// Koyu zeminli "DEKANTÖR MODELİ SEÇİNİZ" açılır liste kutusu.
class ModelSelector extends StatelessWidget {
  const ModelSelector({
    super.key,
    required this.models,
    required this.value,
    required this.onChanged,
  });

  final List<String> models;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ral5004,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'DEKANTÖR MODELİ SEÇİNİZ',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value,
                hint: const Text('-- Listeden Seçin --'),
                style: const TextStyle(
                  color: ral5004,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                items: [
                  for (final name in models)
                    DropdownMenuItem<String>(value: name, child: Text(name)),
                ],
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
