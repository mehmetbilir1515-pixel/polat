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

  testWidgets('DEKANTÖR YAĞLAMA BİLGİSİ: Main/Helezon seçimi ve endüstriyel model', (tester) async {
    await tester.pumpWidget(const PolatApp());

    await tester.tap(find.text('DEKANTÖR YAĞLAMA BİLGİSİ'));
    await tester.pumpAndSettle();
    expect(find.text('Main Bearing'), findsOneWidget);
    expect(find.text('Helezon Rulmanı'), findsOneWidget);

    // Main Bearing verisi henüz eklenmedi.
    await tester.tap(find.text('Main Bearing'));
    await tester.pumpAndSettle();
    expect(find.textContaining('henüz eklenmedi'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Helezon Rulmanı -> Endüstriyel -> S200
    await tester.tap(find.text('Helezon Rulmanı'));
    await tester.pumpAndSettle();
    expect(find.text('Endüstriyel'), findsOneWidget);
    expect(find.text('Zeytinyağı'), findsOneWidget);

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('S200').last);
    await tester.pumpAndSettle();

    expect(find.text('S200 Yağlama Bilgisi'), findsOneWidget);
    expect(find.text('Arka Rulman: 13,59 g - 9 defa basım'), findsOneWidget);
    expect(find.text('Ön Rulman: 6,82 g - 4 defa basım'), findsOneWidget);
    expect(find.text('Her iki rulman toplam yağ miktarı: 20,41 g'), findsOneWidget);
    expect(find.text('3210-A/C3'), findsOneWidget);
    expect(find.text("SKF'te Ara"), findsNWidgets(2));
  });

  testWidgets('DEKANTÖR YAĞLAMA BİLGİSİ: Zeytinyağı sekmesi ve model', (tester) async {
    await tester.pumpWidget(const PolatApp());

    await tester.tap(find.text('DEKANTÖR YAĞLAMA BİLGİSİ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Helezon Rulmanı'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Zeytinyağı'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PX20').last);
    await tester.pumpAndSettle();

    expect(find.text('PX20 Yağlama Bilgisi'), findsOneWidget);
    expect(find.text('Re-Greasing Miktarı (g)'), findsOneWidget);
    expect(find.text('41,92'), findsOneWidget);
    expect(find.text('3218 A'), findsOneWidget);
    expect(find.text('52,4'), findsOneWidget);
    expect(find.text("SKF'te Ara"), findsOneWidget);

    // Endüstriyel sekmesine dönünce seçim sıfırlanır.
    await tester.tap(find.text('Endüstriyel'));
    await tester.pumpAndSettle();
    expect(find.text('PX20 Yağlama Bilgisi'), findsNothing);
  });

  testWidgets('DEKANTÖR MOTOR DÖNÜŞ YÖNÜ: model süzgeci ve yön rozetleri', (tester) async {
    await tester.pumpWidget(const PolatApp());

    await tester.tap(find.text('DEKANTÖR MOTOR DÖNÜŞ YÖNÜ'));
    await tester.pumpAndSettle();
    expect(find.text('40 kayıt'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('filter-model')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('S200').last);
    await tester.pumpAndSettle();

    // S200: ana motor saat yönü tersi, helezon motoru saat yönü.
    expect(find.text('2 kayıt'), findsOneWidget);
    // Liste tembel kurulur; ikinci kart ekran dışında olabilir, önce kaydır.
    await tester.scrollUntilVisible(
      find.text('Motor: Helezon Motoru'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Motor: Ana Motor', skipOffstage: false), findsOneWidget);
    expect(find.text('Motor: Helezon Motoru'), findsOneWidget);
    expect(find.text('SAAT YÖNÜ TERSİ', skipOffstage: false), findsOneWidget);
    expect(find.text('SAAT YÖNÜ', skipOffstage: false), findsOneWidget);
  });

  testWidgets('DEKANTÖR MOTOR DÖNÜŞ YÖNÜ: kayıt yoksa uyarı, temizleyince tümü', (tester) async {
    await tester.pumpWidget(const PolatApp());

    await tester.tap(find.text('DEKANTÖR MOTOR DÖNÜŞ YÖNÜ'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('filter-model')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('S200').last);
    await tester.pumpAndSettle();

    // S200 için yalnızca CYCLO (ZS) vardır; PLANET (ZSPN) ile kayıt çıkmaz.
    await tester.tap(find.byKey(const ValueKey('filter-gearbox')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PLANET (ZSPN)').last);
    await tester.pumpAndSettle();
    expect(find.text('0 kayıt'), findsOneWidget);
    expect(find.textContaining('kayıt bulunamadı'), findsOneWidget);

    final reset = find.byKey(const ValueKey('reset-filters'));
    await tester.ensureVisible(reset);
    await tester.pumpAndSettle();
    await tester.tap(reset);
    await tester.pumpAndSettle();
    expect(find.text('40 kayıt'), findsOneWidget);
    expect(find.textContaining('kayıt bulunamadı'), findsNothing);
  });

  testWidgets('Kütle denkliği: hata bandı açılıp kapanırken yazılan kutu odağını korur', (tester) async {
    await tester.pumpWidget(const PolatApp());

    await tester.tap(find.text('Dekantör Kütle Denkliği'));
    await tester.pumpAndSettle();

    final cakeField = find.byKey(const ValueKey('field-cakeSolids'));
    final cakeEditable = find.descendant(
      of: cakeField,
      matching: find.byType(EditableText),
    );
    bool hasFocus() => tester.widget<EditableText>(cakeEditable).focusNode.hasFocus;
    String cakeText() => tester.widget<TextField>(cakeField).controller!.text;

    // Kutu sanal ekranın dışında kalabilir; dokunmadan önce görünür alana kaydır.
    await tester.ensureVisible(cakeField);
    await tester.pumpAndSettle();
    await tester.tap(cakeField);
    await tester.pump();
    expect(hasFocus(), isTrue);

    // Kek oranı beslemeden küçük -> hata bandı açılır, bütün sayfa aşağı kayar.
    await tester.enterText(cakeField, '1');
    await tester.pumpAndSettle();
    expect(find.textContaining('Kek kuru katı oranı'), findsOneWidget);
    expect(hasFocus(), isTrue);
    expect(cakeText(), '1');

    // Geçerli değere dönünce hata bandı kapanır; odak ve metin yine yerinde.
    await tester.enterText(cakeField, '18');
    await tester.pumpAndSettle();
    expect(find.textContaining('Kek kuru katı oranı'), findsNothing);
    expect(hasFocus(), isTrue);
    expect(cakeText(), '18');
    expect(find.text('421,17 kg/h'), findsOneWidget);
  });

  testWidgets('Kütle denkliği: yalnızca rakam, virgül ve nokta girilebilir', (tester) async {
    await tester.pumpWidget(const PolatApp());

    await tester.tap(find.text('Dekantör Kütle Denkliği'));
    await tester.pumpAndSettle();

    final flowField = find.byKey(const ValueKey('field-flow'));
    await tester.enterText(flowField, '1a2,5x');
    await tester.pump();
    expect(tester.widget<TextField>(flowField).controller!.text, '12,5');
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
