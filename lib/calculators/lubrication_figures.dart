// Şanzıman yağlama kılavuzundaki şekiller (Şekil 2 ve Şekil 6).
//
// Şekiller kullanıcının "Teknik Kılavuz ve Yağlayıcılar" HTML'indeki SVG çizimlerinden
// betikle üretilmiştir (koordinatlar elle yazılmaz); uygulama içinde CustomPaint ile çizilir.
// Veri değişirse HTML'deki SVG kaynak alınıp bu dosya yeniden üretilir.

/// Çizim öğesinin türü.
enum FigureKind { rect, polygon, ellipse, circle, line, text }

/// Tek bir çizim öğesi. [values] türe göre koordinatlardır:
/// rect: x, y, genişlik, yükseklik; polygon: x1, y1, x2, y2, ...;
/// ellipse: cx, cy, rx, ry; circle: cx, cy, r; line: x1, y1, x2, y2; text: x, y (taban çizgisi).
class FigureShape {
  const FigureShape(
    this.kind,
    this.values, {
    this.strokeWidth = 0,
    this.filled = false,
    this.dash,
    this.text,
    this.fontSize = 0,
    this.bold = false,
  });

  final FigureKind kind;
  final List<double> values;

  /// Çizgi kalınlığı; 0 ise çizgi çizilmez.
  final double strokeWidth;

  /// Beyaz dolgu var mı.
  final bool filled;

  /// Kesikli çizgi deseni (çizgi, boşluk, ...); yoksa düz çizgi.
  final List<double>? dash;

  final String? text;
  final double fontSize;
  final bool bold;
}

/// Görünüm kutusu (viewBox) boyutlarıyla birlikte bir şekil.
class LubricationFigure {
  const LubricationFigure(this.width, this.height, this.shapes);

  final double width;
  final double height;
  final List<FigureShape> shapes;
}

const oilBathFigure = LubricationFigure(1150.0, 420.0, [
    FigureShape(FigureKind.rect, [10.0, 180.0, 100.0, 40.0], strokeWidth: 3.0, filled: true),
    FigureShape(FigureKind.rect, [110.0, 150.0, 110.0, 100.0], strokeWidth: 3.0, filled: true),
    FigureShape(FigureKind.polygon, [220.0, 150.0, 260.0, 110.0, 260.0, 290.0, 220.0, 250.0], strokeWidth: 3.0, filled: true),
    FigureShape(FigureKind.rect, [260.0, 80.0, 110.0, 240.0], strokeWidth: 3.0, filled: true),
    FigureShape(FigureKind.rect, [250.0, 110.0, 10.0, 180.0], strokeWidth: 3.0, filled: true),
    FigureShape(FigureKind.rect, [370.0, 110.0, 10.0, 180.0], strokeWidth: 3.0, filled: true),
    FigureShape(FigureKind.rect, [380.0, 150.0, 110.0, 100.0], strokeWidth: 3.0, filled: true),
    FigureShape(FigureKind.rect, [490.0, 175.0, 60.0, 50.0], strokeWidth: 3.0, filled: true),
    FigureShape(FigureKind.ellipse, [315.0, 110.0, 14.0, 5.0], strokeWidth: 3.0, filled: true),
    FigureShape(FigureKind.ellipse, [315.0, 160.0, 14.0, 5.0], strokeWidth: 3.0, filled: true),
    FigureShape(FigureKind.line, [0.0, 200.0, 550.0, 200.0], strokeWidth: 2.5, dash: [25.0, 8.0, 6.0, 8.0]),
    FigureShape(FigureKind.line, [329.0, 110.0, 420.0, 60.0], strokeWidth: 2.5),
    FigureShape(FigureKind.line, [329.0, 160.0, 420.0, 85.0], strokeWidth: 2.5),
    FigureShape(FigureKind.text, [430.0, 60.0], text: 'Üst nokta ve kontrol', fontSize: 24.0),
    FigureShape(FigureKind.text, [430.0, 90.0], text: 'tapası için işaretleme', fontSize: 24.0),
    FigureShape(FigureKind.line, [550.0, 200.0, 1120.0, 200.0], strokeWidth: 2.5, dash: [25.0, 8.0, 6.0, 8.0]),
    FigureShape(FigureKind.line, [850.0, 20.0, 850.0, 390.0], strokeWidth: 2.5, dash: [25.0, 8.0, 6.0, 8.0]),
    FigureShape(FigureKind.circle, [850.0, 200.0, 150.0], strokeWidth: 4.0),
    FigureShape(FigureKind.circle, [850.0, 200.0, 100.0], strokeWidth: 4.0),
    FigureShape(FigureKind.line, [900.0, 95.0, 930.0, 55.0], strokeWidth: 2.5),
    FigureShape(FigureKind.line, [1030.0, 90.0, 950.0, 125.0], strokeWidth: 2.5),
    FigureShape(FigureKind.text, [930.0, 45.0], text: 'yağ girişi', fontSize: 24.0),
    FigureShape(FigureKind.text, [990.0, 80.0], text: 'yağ gözetleme', fontSize: 24.0),
]);

const greaseFigure = LubricationFigure(850.0, 400.0, [
    FigureShape(FigureKind.rect, [30.0, 180.0, 160.0, 40.0], strokeWidth: 2.5, filled: true),
    FigureShape(FigureKind.rect, [190.0, 150.0, 80.0, 100.0], strokeWidth: 2.5, filled: true),
    FigureShape(FigureKind.polygon, [270.0, 150.0, 340.0, 100.0, 340.0, 300.0, 270.0, 250.0], strokeWidth: 2.5, filled: true),
    FigureShape(FigureKind.rect, [340.0, 80.0, 140.0, 240.0], strokeWidth: 2.5, filled: true),
    FigureShape(FigureKind.rect, [480.0, 120.0, 10.0, 160.0], strokeWidth: 2.5, filled: true),
    FigureShape(FigureKind.rect, [490.0, 140.0, 150.0, 120.0], strokeWidth: 2.5, filled: true),
    FigureShape(FigureKind.rect, [640.0, 160.0, 90.0, 80.0], strokeWidth: 2.5, filled: true),
    FigureShape(FigureKind.rect, [730.0, 175.0, 25.0, 50.0], strokeWidth: 2.5, filled: true),
    FigureShape(FigureKind.rect, [400.0, 60.0, 40.0, 20.0], strokeWidth: 2.5, filled: true),
    FigureShape(FigureKind.line, [760.0, 160.0, 745.0, 175.0], strokeWidth: 2.0),
    FigureShape(FigureKind.text, [770.0, 155.0], text: '1', fontSize: 28.0, bold: true),
    FigureShape(FigureKind.line, [460.0, 50.0, 430.0, 70.0], strokeWidth: 2.0),
    FigureShape(FigureKind.text, [475.0, 45.0], text: '2', fontSize: 28.0, bold: true),
    FigureShape(FigureKind.line, [130.0, 130.0, 190.0, 175.0], strokeWidth: 2.0),
    FigureShape(FigureKind.text, [110.0, 125.0], text: '3', fontSize: 28.0, bold: true),
]);
