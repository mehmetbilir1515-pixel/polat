import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../calculators/gearbox_lubrication_guide.dart';
import '../calculators/lubrication_figures.dart';

const Color _ink = Color(0xFF111111);
const Color _border = Color(0xFF222222);

/// Şanzıman yağlama kılavuzu: yağ banyosu ile yağlama, gres yağlama ve önerilen yağlayıcılar.
/// İçerik `gearbox_lubrication_guide.dart` verisinden (kullanıcının HTML kılavuzu) gelir.
class GearboxLubricationGuide extends StatelessWidget {
  const GearboxLubricationGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _GuideCard(
          title: oilBathTitle,
          children: [
            const _Heading(oilBathSubtitle),
            const Text(oilBathText, style: _bodyStyle),
            const SizedBox(height: 12),
            const _Figure(
              figure: oilBathFigure,
              semanticLabel:
                  'Şekil 2: Yağ banyosu ile yağlama. Üst nokta ve kontrol tapası için işaretleme, yağ girişi ve yağ gözetleme.',
            ),
          ],
        ),
        const SizedBox(height: 16),
        _GuideCard(
          title: greaseTitle,
          children: [
            const _Figure(
              figure: greaseFigure,
              semanticLabel:
                  'Şekil 6: Redüktörün yeniden yağlanması. 1 yüksek hızlı mil, 2 kontrol vidası, 3 halka dişli.',
            ),
            const SizedBox(height: 6),
            const Text(
              greaseFigureCaption,
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF0056B3), fontSize: 13),
            ),
            const SizedBox(height: 14),
            const _Heading(greaseSubtitle),
            const Text(greaseIntro, style: _bodyStyle),
            const SizedBox(height: 8),
            for (final step in greaseSteps)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('☒  ', style: TextStyle(fontSize: 16, color: _ink)),
                    Expanded(child: Text(step, style: _bodyStyle)),
                  ],
                ),
              ),
            const SizedBox(height: 6),
            for (final note in greaseNotes) Text(note, style: _bodyStyle),
          ],
        ),
        const SizedBox(height: 16),
        _GuideCard(
          title: lubricantsTitle,
          children: [
            const _SectionHeader(oilsHeader),
            const _TemperatureChart(),
            const SizedBox(height: 12),
            const _OilTable(),
            const _SectionHeader(greasesHeader),
            const _GreaseTable(),
            const SizedBox(height: 6),
            const Text(
              lubricantsFootnote,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: _ink),
            ),
            const SizedBox(height: 6),
            const Divider(height: 1),
            const SizedBox(height: 6),
            const Text(
              lubricantsTableCaption,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: _ink),
            ),
          ],
        ),
      ],
    );
  }
}

const TextStyle _bodyStyle = TextStyle(fontSize: 14, height: 1.5, color: _ink);

/// Kılavuzdaki bir bölüm: başlık + çizgi + içerik (kılavuzdaki beyaz çerçeveli kutu).
class _GuideCard extends StatelessWidget {
  const _GuideCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: _ink),
          ),
          const Divider(color: _border, thickness: 2, height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _ink),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: const BoxDecoration(
        color: Color(0xFFE0E0E0),
        border: Border(
          top: BorderSide(color: _border),
          left: BorderSide(color: _border),
          right: BorderSide(color: _border),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: _ink),
      ),
    );
  }
}

Widget _cell(
  String text, {
  bool bold = false,
  bool italic = false,
  TextAlign align = TextAlign.center,
  Color? color,
  Color? textColor,
}) {
  return Container(
    color: color,
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
    alignment: align == TextAlign.left ? Alignment.centerLeft : Alignment.center,
    child: Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontSize: 13,
        color: textColor ?? _ink,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      ),
    ),
  );
}

/// DIN 51517 yağlayıcı sıcaklık tablosu: ortam ve çalışma sıcaklığı hücreleri.
class _TemperatureChart extends StatelessWidget {
  const _TemperatureChart();

  static const double _labelWidth = 100;
  static const double _rowHeight = 28;
  static const Color _ambient = Color(0xFFA0A0A0);
  static const Color _operating = Color(0xFFD0D0D0);

  Widget _box(Widget child, {Color? color, Alignment alignment = Alignment.center}) {
    return Container(
      height: _rowHeight,
      alignment: alignment,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: _border, width: 0.6),
      ),
      child: child,
    );
  }

  Text _label(String text, {bool bold = false, Color color = _ink}) => Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: color, fontWeight: bold ? FontWeight.bold : null),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 600,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: _labelWidth,
                  height: _rowHeight * 2,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border.all(color: _border, width: 0.6)),
                  child: _label(tempChartTitle, bold: true),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _box(_label(tempChartTop, bold: true)),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: _box(
                              _label(tempChartAmbient, bold: true, color: Colors.white),
                              color: const Color(0xFF888888),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: _box(
                              _label(tempChartOperating, bold: true),
                              color: const Color(0xFFCCCCCC),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: _labelWidth, child: _box(const SizedBox.shrink())),
                for (final t in tempChartTemps) Expanded(child: _box(_label(t))),
              ],
            ),
            for (final row in tempChartRows)
              Row(
                children: [
                  SizedBox(
                    width: _labelWidth,
                    child: _box(
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _label(row.label, bold: true),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  for (final c in row.cells)
                    Expanded(
                      child: _box(
                        const SizedBox.shrink(),
                        color: switch (c) {
                          TempCell.ambient => _ambient,
                          TempCell.operating => _operating,
                          TempCell.none => null,
                        },
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Mineral ve sentetik yağ tablosu.
class _OilTable extends StatelessWidget {
  const _OilTable();

  static const double _labelWidth = 92;

  @override
  Widget build(BuildContext context) {
    final border = Border.all(color: _border, width: 0.8);
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: _labelWidth,
                decoration: BoxDecoration(border: border),
                child: _cell(mineralOilLabel, bold: true),
              ),
              Expanded(
                child: Table(
                  border: TableBorder.all(color: _border, width: 0.8),
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFFF4F4F4)),
                      children: [for (final h in oilTableHeads) _cell(h, bold: true)],
                    ),
                    for (final r in mineralOils)
                      TableRow(children: [for (final v in r) _cell(v)]),
                  ],
                ),
              ),
            ],
          ),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: _labelWidth,
                decoration: BoxDecoration(border: border),
                child: _cell(syntheticOilLabel, bold: true),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(border: border),
                  child: _cell(syntheticOil, align: TextAlign.left),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Gres tipleri tablosu: iki üretici yan yana, her üreticinin tipleri alt alta.
class _GreaseTable extends StatelessWidget {
  const _GreaseTable();

  Widget _types(List<String> types) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final t in types)
            Text(t, style: const TextStyle(fontSize: 13, color: _ink)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = <TableRow>[
      TableRow(
        decoration: const BoxDecoration(color: Color(0xFFF4F4F4)),
        children: [for (final h in greaseTableHeads) _cell(h, bold: true)],
      ),
    ];
    for (var i = 0; i < greaseTypes.length; i += 2) {
      final a = greaseTypes[i];
      final b = i + 1 < greaseTypes.length ? greaseTypes[i + 1] : null;
      rows.add(
        TableRow(
          children: [
            _cell(a.maker),
            _types(a.types),
            b == null ? const SizedBox.shrink() : _cell(b.maker),
            b == null ? const SizedBox.shrink() : _types(b.types),
          ],
        ),
      );
    }
    return Table(
      border: TableBorder.all(color: _border, width: 0.8),
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: rows,
    );
  }
}

/// Kılavuzdaki teknik çizim (Şekil 2 ve Şekil 6). Çizim, HTML'deki SVG'den üretilen
/// `lubrication_figures.dart` verisiyle yeniden çizilir; her genişlikte oranı korur.
class _Figure extends StatelessWidget {
  const _Figure({required this.figure, required this.semanticLabel});

  final LubricationFigure figure;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Container(
          color: Colors.white,
          child: AspectRatio(
            aspectRatio: figure.width / figure.height,
            child: CustomPaint(painter: _FigurePainter(figure)),
          ),
        ),
      ),
    );
  }
}

class _FigurePainter extends CustomPainter {
  const _FigurePainter(this.figure);

  final LubricationFigure figure;

  Paint _stroke(double width) => Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeJoin = StrokeJoin.miter;

  Paint get _fill => Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  void _closed(Canvas c, FigureShape s, void Function(Canvas, Paint) draw) {
    if (s.filled) draw(c, _fill);
    if (s.strokeWidth > 0) draw(c, _stroke(s.strokeWidth));
  }

  void _dashed(Canvas c, Offset a, Offset b, double sw, List<double> pattern) {
    final length = (b - a).distance;
    final dir = (b - a) / length;
    final paint = _stroke(sw);
    var pos = 0.0;
    var i = 0;
    while (pos < length) {
      final step = pattern[i % pattern.length];
      if (i.isEven) {
        c.drawLine(a + dir * pos, a + dir * math.min(pos + step, length), paint);
      }
      pos += step;
      i++;
    }
  }

  void _text(Canvas c, FigureShape s) {
    final tp = TextPainter(
      text: TextSpan(
        text: s.text,
        style: TextStyle(
          color: Colors.black,
          fontSize: s.fontSize,
          fontWeight: s.bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final baseline = tp.computeDistanceToActualBaseline(TextBaseline.alphabetic);
    tp.paint(c, Offset(s.values[0], s.values[1] - baseline));
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / figure.width);
    for (final s in figure.shapes) {
      final v = s.values;
      switch (s.kind) {
        case FigureKind.rect:
          final r = Rect.fromLTWH(v[0], v[1], v[2], v[3]);
          _closed(canvas, s, (c, p) => c.drawRect(r, p));
        case FigureKind.polygon:
          final path = Path()
            ..addPolygon([for (var i = 0; i < v.length; i += 2) Offset(v[i], v[i + 1])], true);
          _closed(canvas, s, (c, p) => c.drawPath(path, p));
        case FigureKind.ellipse:
          final r = Rect.fromCenter(center: Offset(v[0], v[1]), width: v[2] * 2, height: v[3] * 2);
          _closed(canvas, s, (c, p) => c.drawOval(r, p));
        case FigureKind.circle:
          _closed(canvas, s, (c, p) => c.drawCircle(Offset(v[0], v[1]), v[2], p));
        case FigureKind.line:
          final a = Offset(v[0], v[1]);
          final b = Offset(v[2], v[3]);
          final dash = s.dash;
          if (dash == null) {
            canvas.drawLine(a, b, _stroke(s.strokeWidth));
          } else {
            _dashed(canvas, a, b, s.strokeWidth, dash);
          }
        case FigureKind.text:
          _text(canvas, s);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FigurePainter oldDelegate) => oldDelegate.figure != figure;
}
