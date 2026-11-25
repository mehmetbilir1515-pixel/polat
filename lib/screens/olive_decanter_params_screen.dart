import 'package:flutter/material.dart';

import '../calculators/olive_decanter_figures.dart';
import '../calculators/olive_decanter_filter.dart';
import '../calculators/olive_decanter_params.dart';
import '../theme.dart';
import '../widgets/gearbox_lubrication_guide.dart' show FigureView;
import '../widgets/model_selector.dart';

/// Zeytinyağı Dekantör Çalışma Parametreleri: önce PX / PXZ serisi seçilir.
class OliveDecanterParamsScreen extends StatelessWidget {
  const OliveDecanterParamsScreen({super.key});

  Widget _choice(
    BuildContext context, {
    required String title,
    required String subtitle,
    required OliveParamSheet sheet,
  }) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => OliveDecanterSeriesScreen(title: title, sheet: sheet),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.opacity,
                  size: 30,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(color: mutedColor(context)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Zeytinyağı Dekantör Çalışma Parametreleri')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Dekantör serisini seçin; ardından model ve faza göre çalışma parametrelerini filtreleyin.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: mutedColor(context)),
              ),
              const SizedBox(height: 20),
              _choice(
                context,
                title: 'PX Serisi Dekantörler',
                subtitle: pxParamSheet.sheetName,
                sheet: pxParamSheet,
              ),
              _choice(
                context,
                title: 'PXZ Serisi Dekantörler',
                subtitle: pxzParamSheet.sheetName,
                sheet: pxzParamSheet,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Seçilen serinin tüm çalışma parametreleri; "Dekantör Modeli" ve "Faz" ile süzülebilir.
class OliveDecanterSeriesScreen extends StatefulWidget {
  const OliveDecanterSeriesScreen({super.key, required this.title, required this.sheet});

  final String title;
  final OliveParamSheet sheet;

  @override
  State<OliveDecanterSeriesScreen> createState() => _OliveDecanterSeriesScreenState();
}

class _OliveDecanterSeriesScreenState extends State<OliveDecanterSeriesScreen> {
  /// Açılır listede süzmeyi kaldıran ilk seçenek.
  static const String _all = 'Tümü';

  String? _model;
  String? _phase;

  Widget _row(BuildContext context, String label, String value, {bool note = false}) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodySmall?.copyWith(color: mutedColor(context), height: 1.3);
    final valueStyle = theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, height: 1.3);
    final line = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: Text(label, style: labelStyle)),
        const SizedBox(width: 12),
        Expanded(flex: 6, child: Text(value, style: valueStyle)),
      ],
    );
    if (!note) {
      return Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: line);
    }
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: line,
    );
  }

  Widget _card(BuildContext context, List<String?> row) {
    final sheet = widget.sheet;
    final theme = Theme.of(context);
    final modelCol = sheet.column(oliveModelHeader);
    final noteCol = sheet.headers.length - 1; // son sütun: "Not"
    final rows = <Widget>[];
    for (var i = 0; i < sheet.headers.length; i++) {
      final v = row[i];
      if (v == null || i == modelCol) continue;
      rows.add(_row(context, sheet.headers[i], v, note: i == noteCol));
    }
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              row[modelCol] ?? '',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const Divider(height: 16),
            ...rows,
          ],
        ),
      ),
    );
  }

  Widget _figureCard(BuildContext context, String title, Widget figure) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ClipRRect(borderRadius: BorderRadius.circular(10), child: figure),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sheet = widget.sheet;
    final theme = Theme.of(context);
    final rows = filterOliveRows(sheet, model: _model, phase: _phase);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                sheet.sheetName,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              ModelSelector(
                title: 'DEKANTÖR MODELİ SEÇİNİZ',
                models: [_all, ...oliveModels(sheet)],
                value: _model,
                onChanged: (v) => setState(() => _model = v == _all ? null : v),
              ),
              const SizedBox(height: 12),
              ModelSelector(
                title: 'FAZ SEÇİNİZ',
                models: [_all, ...olivePhases(sheet)],
                labelFor: (v) => v == _all ? v : olivePhaseLabel(v),
                value: _phase,
                onChanged: (v) => setState(() => _phase = v == _all ? null : v),
              ),
              const SizedBox(height: 20),
              Text(
                '${rows.length} kayıt',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: mutedColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (rows.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded, size: 36, color: subtleColor(context)),
                        const SizedBox(height: 8),
                        const Text(
                          'Seçilen model ve faz için kayıt bulunamadı.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                for (final row in rows) _card(context, row),
              _figureCard(
                context,
                'Ürün Giriş Borusu Ölçü Gösterimi',
                const FigureView(
                  figure: productInletPipeFigure,
                  semanticLabel:
                      'Ürün giriş borusu ölçü gösterimi: kırmızı ok, dirsek ile flanş arasındaki boru boyunu gösterir.',
                ),
              ),
              _figureCard(
                context,
                'Su Ayar Sacı Ölçü Gösterimi',
                const FigureView(
                  figure: waterAdjustPlateFigure,
                  semanticLabel:
                      'Su ayar sacı ölçü gösterimi: kırmızı çift yönlü ok, saç ölçüsünü gösterir.',
                ),
              ),
              SizedBox(height: MediaQuery.paddingOf(context).bottom),
            ],
          ),
        ),
      ),
    );
  }
}
