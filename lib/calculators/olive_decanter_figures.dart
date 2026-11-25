// Zeytinyağı dekantörü çalışma parametreleri ekranındaki ölçü şekilleri.
//
// Şekiller kullanıcının "Ürün Giriş Borusu" ve "Su Ayar Sacı" HTML'lerindeki SVG çizimlerinden
// betikle üretilmiştir (koordinatlar elle yazılmaz); uygulama içinde CustomPaint ile çizilir.
// Veri değişirse HTML'deki SVG kaynak alınıp bu dosya yeniden üretilir.

import 'lubrication_figures.dart';

/// Ürün giriş borusu ölçü gösterimi (kırmızı ok: boru boyu).
const productInletPipeFigure = LubricationFigure(800.0, 600.0, [
    FigureShape(FigureKind.rect, [710.0, 40.0, 35.0, 105.0], strokeWidth: 2.5),
    FigureShape(FigureKind.rect, [710.0, 255.0, 35.0, 105.0], strokeWidth: 2.5),
    FigureShape(FigureKind.line, [710.0, 40.0, 710.0, 360.0], strokeWidth: 2.5),
    FigureShape(FigureKind.line, [160.0, 145.0, 710.0, 145.0], strokeWidth: 2.5),
    FigureShape(FigureKind.line, [160.0, 255.0, 710.0, 255.0], strokeWidth: 2.5),
    FigureShape(FigureKind.line, [160.0, 145.0, 160.0, 255.0], strokeWidth: 2.5),
    FigureShape(FigureKind.path, [], text: 'M 160 145 C 80 145, 20 180, 20 290', strokeWidth: 2.5),
    FigureShape(FigureKind.path, [], text: 'M 160 255 C 140 255, 110 270, 110 320', strokeWidth: 2.5),
    FigureShape(FigureKind.line, [20.0, 290.0, 20.0, 480.0], strokeWidth: 2.5),
    FigureShape(FigureKind.line, [110.0, 320.0, 110.0, 480.0], strokeWidth: 2.5),
    FigureShape(FigureKind.line, [20.0, 480.0, 110.0, 480.0], strokeWidth: 2.5),
    FigureShape(FigureKind.line, [160.0, 90.0, 710.0, 90.0], strokeWidth: 1.5, strokeColor: 0xFFFF0000, fillColor: 0xFFFF0000),
    FigureShape(FigureKind.line, [160.0, 80.0, 160.0, 100.0], strokeWidth: 2.0, strokeColor: 0xFFFF0000, fillColor: 0xFFFF0000),
    FigureShape(FigureKind.polygon, [160.0, 90.0, 175.0, 84.0, 175.0, 96.0], strokeWidth: 1.0, strokeColor: 0xFFFF0000, fillColor: 0xFFFF0000),
    FigureShape(FigureKind.polygon, [710.0, 90.0, 695.0, 84.0, 695.0, 96.0], strokeWidth: 1.0, strokeColor: 0xFFFF0000, fillColor: 0xFFFF0000),
]);

/// Su ayar sacı ölçü gösterimi (kırmızı çift yönlü ok: ölçü).
const waterAdjustPlateFigure = LubricationFigure(800.0, 550.0, [
    FigureShape(FigureKind.path, [], text: 'M -20 80 Q 400 -20 820 80', strokeWidth: 2.5, strokeColor: 0xFF111111),
    FigureShape(FigureKind.rrect, [220.0, 160.0, 360.0, 240.0, 15.0], strokeWidth: 2.5, strokeColor: 0xFF111111),
    FigureShape(FigureKind.path, [], text: 'M 300 400 L 300 490 Q 300 510 320 510 L 480 510 Q 500 510 500 490 L 500 400', strokeWidth: 2.5, strokeColor: 0xFF111111),
    FigureShape(FigureKind.rrect, [250.0, 195.0, 45.0, 130.0, 22.5], strokeWidth: 2.5, strokeColor: 0xFF111111),
    FigureShape(FigureKind.rrect, [505.0, 195.0, 45.0, 130.0, 22.5], strokeWidth: 2.5, strokeColor: 0xFF111111),
    FigureShape(FigureKind.circle, [272.5, 290.0, 16.0], strokeWidth: 2.5, strokeColor: 0xFF111111),
    FigureShape(FigureKind.circle, [272.5, 290.0, 11.0], strokeWidth: 2.5, strokeColor: 0xFF111111),
    FigureShape(FigureKind.circle, [272.5, 290.0, 6.0], strokeWidth: 2.5, strokeColor: 0xFF111111),
    FigureShape(FigureKind.path, [], text: 'M 268 290 Q 272.5 295 277 290', strokeWidth: 1.5, strokeColor: 0xFF111111),
    FigureShape(FigureKind.circle, [527.5, 290.0, 16.0], strokeWidth: 2.5, strokeColor: 0xFF111111),
    FigureShape(FigureKind.circle, [527.5, 290.0, 11.0], strokeWidth: 2.5, strokeColor: 0xFF111111),
    FigureShape(FigureKind.circle, [527.5, 290.0, 6.0], strokeWidth: 2.5, strokeColor: 0xFF111111),
    FigureShape(FigureKind.path, [], text: 'M 523 290 Q 527.5 295 532 290', strokeWidth: 1.5, strokeColor: 0xFF111111),
    FigureShape(FigureKind.line, [400.0, 30.0, 400.0, 160.0], strokeWidth: 2.5, strokeColor: 0xFFE00000, fillColor: 0xFFE00000),
    FigureShape(FigureKind.polygon, [400.0, 30.0, 394.0, 45.0, 406.0, 45.0], strokeWidth: 2.5, strokeColor: 0xFFE00000, fillColor: 0xFFE00000),
    FigureShape(FigureKind.polygon, [400.0, 160.0, 394.0, 145.0, 406.0, 145.0], strokeWidth: 2.5, strokeColor: 0xFFE00000, fillColor: 0xFFE00000),
]);
