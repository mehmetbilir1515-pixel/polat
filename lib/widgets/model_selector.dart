import 'package:flutter/material.dart';

import '../theme.dart';

/// Koyu zeminli açılır liste kutusu (varsayılan başlık: "DEKANTÖR MODELİ SEÇİNİZ").
class ModelSelector extends StatelessWidget {
  const ModelSelector({
    super.key,
    required this.models,
    required this.value,
    required this.onChanged,
    this.title = 'DEKANTÖR MODELİ SEÇİNİZ',
  });

  final List<String> models;
  final String? value;
  final ValueChanged<String?> onChanged;

  /// Kutunun üstündeki başlık.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ral5004,
        borderRadius: BorderRadius.circular(18),
        border: isDark(context) ? Border.all(color: Colors.white.withValues(alpha: 0.10)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                borderRadius: BorderRadius.circular(14),
                // Koyu temada menü zemini açık kalır; metin rengi RAL 5004 olduğu için okunur.
                dropdownColor: isDark(context) ? Colors.white : null,
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
