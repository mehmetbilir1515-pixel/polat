import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polat_rd/app.dart';
import 'package:polat_rd/theme.dart';
import 'package:polat_rd/theme_controller.dart';

void main() {
  test('Açık tema marka renklerini değiştirmeden korur', () {
    final t = buildPolatTheme();
    expect(ral5004, const Color(0xFF1A1C2B));
    expect(ral1003, const Color(0xFFF9A800));
    expect(t.colorScheme.primary, ral5004);
    expect(t.colorScheme.primaryContainer, ral1003);
    expect(t.colorScheme.surface, const Color(0xFFFFFBF2));
    expect(t.scaffoldBackgroundColor, const Color(0xFFFFFBF2));
    expect(t.appBarTheme.backgroundColor, ral5004);
    expect(t.appBarTheme.foregroundColor, ral1003);
  });

  test('Koyu tema aynı RAL renklerinden türetilir', () {
    final t = buildPolatDarkTheme();
    expect(t.brightness, Brightness.dark);
    expect(t.colorScheme.primary, ral1003);
    expect(t.cardTheme.color, ral5004);
    expect(t.appBarTheme.backgroundColor, ral5004);
  });

  testWidgets('Koyu temada ana ekran açılır ve bir ekrana girilip geri dönülebilir', (tester) async {
    themeModeNotifier.value = ThemeMode.dark;
    addTearDown(() => themeModeNotifier.value = ThemeMode.light);

    await tester.pumpWidget(const PolatApp());
    await tester.pumpAndSettle();
    expect(find.text('Dekantör Model Değerleri'), findsOneWidget);

    await tester.tap(find.text('Dekantör Model Değerleri'));
    await tester.pumpAndSettle();
    expect(find.text('DEKANTÖR MODELİ SEÇİNİZ...'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('POLAT R&D'), findsOneWidget);
  });

  testWidgets('Hareketi azalt açıkken ana ekran ve kart dokunuşu çalışır', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData.fromView(tester.view).copyWith(disableAnimations: true),
        child: const PolatApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dekantör Model Değerleri'));
    await tester.pumpAndSettle();
    expect(find.text('DEKANTÖR MODELİ SEÇİNİZ...'), findsOneWidget);
  });

  testWidgets('Varsayılan tema açıktır; Görünüm menüsünden Koyu seçilebilir ve geri Açık yapılabilir',
      (tester) async {
    themeModeNotifier.value = ThemeMode.light;
    addTearDown(() => themeModeNotifier.value = ThemeMode.light);

    await tester.pumpWidget(const PolatApp());
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(find.text('POLAT R&D'))).brightness, Brightness.light);

    await tester.tap(find.byTooltip('Görünüm'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Koyu'));
    await tester.pumpAndSettle();
    expect(themeModeNotifier.value, ThemeMode.dark);
    expect(Theme.of(tester.element(find.text('POLAT R&D'))).brightness, Brightness.dark);

    await tester.tap(find.text('Açık'));
    await tester.pumpAndSettle();
    expect(themeModeNotifier.value, ThemeMode.light);
    expect(Theme.of(tester.element(find.text('POLAT R&D'))).brightness, Brightness.light);
  });
}
