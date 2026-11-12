import 'package:flutter_test/flutter_test.dart';
import 'package:polat_rd/calculators/gearbox_lubrication_guide.dart';

// Beklenen metinler kullanıcının HTML kılavuzundan bağımsız bir betikle (bs4) çıkarılmıştır;
// koddan türetilmemiştir. Sıra HTML belge sırasıdır.
const _expectedTexts = <String>[
  'Şanzıman Yağ Banyosu ile Yağlama',
  'Yağlayıcı ile doldurma',
  'CYCLO DRIVE santrifüj redüktör pim halkası üzerinde, birbirine 180° açıyla konumlandırılmış iki (2) kontrol vidası ve iki (2) işaret (X) bulunmaktadır. Ayrı işaret (X) en üste gelene kadar redüktörü çevirin (bkz. Şekil 2). Redüktörü doldurmak için üstteki iki vidayı açın. İkinci delikten yağ çıkana kadar üstteki delikten yağlayıcı yağ ile doldurun. Redüktör başarılı bir şekilde doldurulduktan sonra, kontrol vidaları yeni yağ keçeleri ile birlikte sıkıca tekrar vidalar içine takılmalıdır (bkz. parça listesi).',
  'Üst nokta ve kontrol',
  'tapası için işaretleme',
  'yağ girişi',
  'yağ gözetleme',
  'Şanzıman Gres Yağlama',
  '1',
  '2',
  '3',
  'Şek. 6. CYCLO Drive santrifüj redüktörünün yeniden yağlanması',
  'Tamamen sızdırmaz (kapalı) CYCLO Drive santrifüj redüktörünün yeniden yağlanması',
  'Tamamen sızdırmaz CYCLO Drive santrifüj redüktörleri yalnızca makine dururken (çalışmıyorken) yeniden yağlanabilir.',
  'Yüksek hızlı mil (1) üzerinden gres beslemesi yaparak yeniden yağlayın (ayrıca bkz. Şek. 6).',
  'Halka dişli muhafazasında bulunan kontrol vidalarından (2) en az birini açın.',
  'Planlanan yağlama aralıklarının bir yıl içinde toplam yağlayıcı hacminin tamamen değişmesini sağlayacak şekilde gres miktarını hesaplayın.',
  'Maks. yağlayıcı miktarı, Bölüm 9\'da açıklandığı gibi iç boşluk tarafından belirlenir.',
  'Yağlama aralıklarına Bölüm 8.3\'e göre uyulmalıdır.',
  'Önerilen Yağlayıcılar',
  'Yağlar (Oils)',
  'DIN 51517 Bölüm 3\'e göre Yağlayıcı',
  '← olası çalışma sıcaklıkları →',
  'Ortam sıcaklığı',
  'Çalışma sıcaklığı',
  '-20°',
  '0°',
  '+20°',
  '+40°',
  '+60°',
  '+80°',
  '+100°',
  '+120°',
  'CLP 68',
  'CLP 100',
  'CLP 150',
  'CLP 220',
  'CLP 320',
  'Mineral Yağ',
  'Üretici',
  'Tip',
  'Üretici',
  'Tip',
  'AVIA',
  'Gear RSX',
  'MOBIL',
  'Mobilgear 600 XP',
  'CASTROL',
  'Alpha SP',
  'SHELL',
  'Omala',
  'KLÜBER',
  'Klüberoil GEM 1',
  'TOTAL',
  'Carter EP',
  'Sentetik Yağ',
  'Mobil SHC 600',
  'Gres Tipleri (Grease type)',
  'Üretici',
  'Tip',
  'Üretici',
  'Tip',
  'Shell',
  'Gadus S2 U460L 2',
  'Gadus S3 V220C 2',
  'Castrol',
  'Tribol GR 100-2',
  'PD',
  'Spheerol EPL 0',
  'Klüber',
  'Klüber Synth UH1 14-151*',
  '*Gıda endüstrisi için uygundur.',
  'Tab. 2: Önerilen yağlayıcılar',
];

// HTML'deki bg-ambient (A), bg-operating (O) ve boş (-) hücre sınıflarından çıkarılmıştır.
const _expectedCells = <String, String>{
  'CLP 68': 'AAAOOO--',
  'CLP 100': 'AAAAOOO-',
  'CLP 150': '-AAAOOOO',
  'CLP 220': '--AA-OOO',
  'CLP 320': '---AOOOO',
};

void main() {
  test('kılavuz metinleri HTML ile birebir aynı ve aynı sırada', () {
    expect(lubricationGuideTexts, _expectedTexts);
  });

  test('sıcaklık tablosu: her satır 8 hücre', () {
    expect(tempChartTemps.length, 8);
    for (final r in tempChartRows) {
      expect(r.cells.length, 8, reason: r.label);
    }
  });

  test('sıcaklık tablosu hücreleri HTML sınıflarıyla aynı', () {
    final actual = {
      for (final r in tempChartRows)
        r.label: r.cells
            .map((c) => switch (c) {
                  TempCell.ambient => 'A',
                  TempCell.operating => 'O',
                  TempCell.none => '-',
                })
            .join(),
    };
    expect(actual, _expectedCells);
  });
}
