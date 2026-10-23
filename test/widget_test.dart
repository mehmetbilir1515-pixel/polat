import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polat_rd/app.dart';

void main() {
  testWidgets('Ana ekran başlığı ve ilk araç görünür', (tester) async {
    await tester.pumpWidget(const PolatApp());

    expect(find.text('POLAT R&D'), findsOneWidget);
    expect(find.text('G-Force (RCF) Hesaplayıcı'), findsOneWidget);
  });

  testWidgets('G-Force aracı sonucu gösterir', (tester) async {
    await tester.pumpWidget(const PolatApp());

    await tester.tap(find.text('G-Force (RCF) Hesaplayıcı'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '500');
    await tester.enterText(find.byType(TextField).at(1), '3000');
    await tester.tap(find.text('Hesapla'));
    await tester.pump();

    // 500 mm çap, 3000 RPM -> yaklaşık 2.516 g
    expect(find.textContaining('2.516'), findsOneWidget);
  });
}
