import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polat_rd/app.dart';

void main() {
  testWidgets('Ana ekran başlığı ve ilk araç görünür', (tester) async {
    await tester.pumpWidget(const PolatApp());

    expect(find.text('POLAT R&D'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget); // P logosu
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

  testWidgets('Kütle denkliği ekranı örnek değerlerle sonuç gösterir', (tester) async {
    await tester.pumpWidget(const PolatApp());

    await tester.tap(find.text('Dekantör Kütle Denkliği'));
    await tester.pumpAndSettle();

    // Hesap sayfasındaki örnek: 7 m³/h, %1,13 besleme, %18 kek, %0,05 sentrat
    expect(find.text('421,17 kg/h'), findsOneWidget); // kek çıkışı
    expect(find.text('6.578,83 kg/h'), findsOneWidget); // sentrat çıkışı
    expect(find.text('95,58 %'), findsOneWidget); // yakalama verimi
    expect(find.text('10,11 kg/tDS'), findsOneWidget); // polimer tüketimi
    expect(find.text('1.000 mg/L'), findsOneWidget); // %0,10 -> AKM
  });

  testWidgets('POLAT DECANTER 3000G: model seçince hedef devir ve uyarı görünür', (tester) async {
    await tester.pumpWidget(const PolatApp());

    await tester.tap(find.text('POLAT DECANTER 3000G'));
    await tester.pumpAndSettle();

    // Model seçilmeden sonuç yok.
    expect(find.text('Hedef 3000G Devri'), findsNothing);

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('S430').last);
    await tester.pumpAndSettle();

    // S430: hedef 3.533 rpm; en büyük şanzıman limiti (3.500) yetersiz.
    expect(find.text('Hedef 3000G Devri'), findsOneWidget);
    expect(find.text('3.533'), findsOneWidget);
    expect(find.textContaining('Yetersiz!'), findsOneWidget);
    expect(find.text("Mevcut Çalışma Devri 3000G'yi Sağlamaktadır."), findsNothing);
  });

  testWidgets('POLAT DECANTER 3000G: S200 zaten 3000G sağlıyor', (tester) async {
    await tester.pumpWidget(const PolatApp());

    await tester.tap(find.text('POLAT DECANTER 3000G'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('S200').last);
    await tester.pumpAndSettle();

    expect(find.text("Mevcut Çalışma Devri 3000G'yi Sağlamaktadır."), findsOneWidget);
    expect(find.text('Mevcut G Kuvveti'), findsOneWidget);
    expect(find.text('3.140'), findsOneWidget);
    expect(find.textContaining('Yetersiz!'), findsNothing);
  });

  testWidgets('Dekantör model değerleri: model seçince değerler görünür', (tester) async {
    await tester.pumpWidget(const PolatApp());

    await tester.tap(find.text('Dekantör Model Değerleri'));
    await tester.pumpAndSettle();

    // Model seçilmeden değer yok.
    expect(find.text('Hidrolik Kapasite'), findsNothing);

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SX650').last);
    await tester.pumpAndSettle();

    expect(find.text('2.300'), findsOneWidget); // maks. çalışma devri
    expect(find.text('2.500'), findsOneWidget); // maks. gövde devri
    expect(find.text('70-100'), findsOneWidget); // hidrolik kapasite
  });

  testWidgets('Kütle denkliği debi değişince güncellenir ve hatayı gösterir', (tester) async {
    await tester.pumpWidget(const PolatApp());

    await tester.tap(find.text('Dekantör Kütle Denkliği'));
    await tester.pumpAndSettle();

    // Debi iki katına çıkınca kek çıkışı da iki katına çıkar.
    await tester.enterText(find.byType(TextField).at(0), '14');
    await tester.pump();
    expect(find.text('842,34 kg/h'), findsOneWidget);

    // Kek kuruluğu beslemeden küçükse hata mesajı görünür.
    await tester.enterText(find.byType(TextField).at(5), '1');
    await tester.pump();
    expect(find.textContaining('Kek kuru katı oranı'), findsOneWidget);
  });
}
