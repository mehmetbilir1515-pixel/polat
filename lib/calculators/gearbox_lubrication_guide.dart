// Şanzıman yağlama kılavuzu (Tab. 2 ve yağlama talimatları).
//
// Metinler ve tablolar kullanıcının "Teknik Kılavuz ve Yağlayıcılar" HTML'inden betikle
// üretilmiştir (elle yazılmaz); test beklentileri HTML dosyasından ayrı bir betikle çıkarılır.
// Veri değişirse HTML kaynak alınıp bu dosya ve test/gearbox_lubrication_guide_test.dart yeniden üretilir.

/// Sıcaklık tablosunda bir hücrenin türü.
enum TempCell { none, ambient, operating }

/// Sıcaklık tablosunun bir satırı (yağ sınıfı ve 8 sıcaklık hücresi).
class TempRow {
  const TempRow(this.label, this.cells);

  final String label;
  final List<TempCell> cells;
}

const String oilBathTitle = 'Şanzıman Yağ Banyosu ile Yağlama';
const String oilBathSubtitle = 'Yağlayıcı ile doldurma';
const String oilBathText =
    'CYCLO DRIVE santrifüj redüktör pim halkası üzerinde, birbirine 180° açıyla konumlandırılmış iki (2) kontrol vidası ve iki (2) işaret (X) bulunmaktadır. Ayrı işaret (X) en üste gelene kadar redüktörü çevirin (bkz. Şekil 2). Redüktörü doldurmak için üstteki iki vidayı açın. İkinci delikten yağ çıkana kadar üstteki delikten yağlayıcı yağ ile doldurun. Redüktör başarılı bir şekilde doldurulduktan sonra, kontrol vidaları yeni yağ keçeleri ile birlikte sıkıca tekrar vidalar içine takılmalıdır (bkz. parça listesi).';

/// Şekil 2 (yağ banyosu) üzerindeki yazılar: sol kesit ve sağ ön görünüm.
const List<String> oilBathFigureLabels = [
  'Üst nokta ve kontrol',
  'tapası için işaretleme',
  'yağ girişi',
  'yağ gözetleme',
];

/// Şekil 6 (gres yağlama) üzerindeki numaralar: 1 yüksek hızlı mil, 2 kontrol vidası, 3 halka dişli.
const List<String> greaseFigureLabels = ['1', '2', '3'];

const String greaseTitle = 'Şanzıman Gres Yağlama';
const String greaseFigureCaption = 'Şek. 6. CYCLO Drive santrifüj redüktörünün yeniden yağlanması';
const String greaseSubtitle =
    'Tamamen sızdırmaz (kapalı) CYCLO Drive santrifüj redüktörünün yeniden yağlanması';
const String greaseIntro =
    'Tamamen sızdırmaz CYCLO Drive santrifüj redüktörleri yalnızca makine dururken (çalışmıyorken) yeniden yağlanabilir.';
const List<String> greaseSteps = [
  'Yüksek hızlı mil (1) üzerinden gres beslemesi yaparak yeniden yağlayın (ayrıca bkz. Şek. 6).',
  'Halka dişli muhafazasında bulunan kontrol vidalarından (2) en az birini açın.',
  'Planlanan yağlama aralıklarının bir yıl içinde toplam yağlayıcı hacminin tamamen değişmesini sağlayacak şekilde gres miktarını hesaplayın.',
];
const List<String> greaseNotes = ['Maks. yağlayıcı miktarı, Bölüm 9\'da açıklandığı gibi iç boşluk tarafından belirlenir.', 'Yağlama aralıklarına Bölüm 8.3\'e göre uyulmalıdır.'];

const String lubricantsTitle = 'Önerilen Yağlayıcılar';
const String oilsHeader = 'Yağlar (Oils)';
const String greasesHeader = 'Gres Tipleri (Grease type)';

const String tempChartTitle = 'DIN 51517 Bölüm 3\'e göre Yağlayıcı';
const String tempChartTop = '← olası çalışma sıcaklıkları →';
const String tempChartAmbient = 'Ortam sıcaklığı';
const String tempChartOperating = 'Çalışma sıcaklığı';
const List<String> tempChartTemps = ['-20°', '0°', '+20°', '+40°', '+60°', '+80°', '+100°', '+120°'];
const List<TempRow> tempChartRows = [
  TempRow('CLP 68', [TempCell.ambient, TempCell.ambient, TempCell.ambient, TempCell.operating, TempCell.operating, TempCell.operating, TempCell.none, TempCell.none]),
  TempRow('CLP 100', [TempCell.ambient, TempCell.ambient, TempCell.ambient, TempCell.ambient, TempCell.operating, TempCell.operating, TempCell.operating, TempCell.none]),
  TempRow('CLP 150', [TempCell.none, TempCell.ambient, TempCell.ambient, TempCell.ambient, TempCell.operating, TempCell.operating, TempCell.operating, TempCell.operating]),
  TempRow('CLP 220', [TempCell.none, TempCell.none, TempCell.ambient, TempCell.ambient, TempCell.none, TempCell.operating, TempCell.operating, TempCell.operating]),
  TempRow('CLP 320', [TempCell.none, TempCell.none, TempCell.none, TempCell.ambient, TempCell.operating, TempCell.operating, TempCell.operating, TempCell.operating]),
];

const String mineralOilLabel = 'Mineral Yağ';
const List<String> oilTableHeads = ['Üretici', 'Tip', 'Üretici', 'Tip'];
/// Mineral yağ satırları: üretici, tip, üretici, tip.
const List<List<String>> mineralOils = [
  ['AVIA', 'Gear RSX', 'MOBIL', 'Mobilgear 600 XP'],
  ['CASTROL', 'Alpha SP', 'SHELL', 'Omala'],
  ['KLÜBER', 'Klüberoil GEM 1', 'TOTAL', 'Carter EP'],
];
const String syntheticOilLabel = 'Sentetik Yağ';
const String syntheticOil = 'Mobil SHC 600';

const List<String> greaseTableHeads = ['Üretici', 'Tip', 'Üretici', 'Tip'];
/// Gres satırları: üretici ve tipleri (HTML'deki sırayla).
const List<({String maker, List<String> types})> greaseTypes = [
  (maker: 'Shell', types: ['Gadus S2 U460L 2', 'Gadus S3 V220C 2']),
  (maker: 'Castrol', types: ['Tribol GR 100-2', 'PD', 'Spheerol EPL 0']),
  (maker: 'Klüber', types: ['Klüber Synth UH1 14-151*']),
];

const String lubricantsFootnote = '*Gıda endüstrisi için uygundur.';
const String lubricantsTableCaption = 'Tab. 2: Önerilen yağlayıcılar';

/// Kılavuzdaki tüm metinler, HTML'deki belge sırasıyla (test bu sırayı HTML ile karşılaştırır).
List<String> get lubricationGuideTexts => [
      oilBathTitle,
      oilBathSubtitle,
      oilBathText,
      ...oilBathFigureLabels,
      greaseTitle,
      ...greaseFigureLabels,
      greaseFigureCaption,
      greaseSubtitle,
      greaseIntro,
      ...greaseSteps,
      ...greaseNotes,
      lubricantsTitle,
      oilsHeader,
      tempChartTitle,
      tempChartTop,
      tempChartAmbient,
      tempChartOperating,
      ...tempChartTemps,
      for (final r in tempChartRows) r.label,
      mineralOilLabel,
      ...oilTableHeads,
      for (final r in mineralOils) ...r,
      syntheticOilLabel,
      syntheticOil,
      greasesHeader,
      ...greaseTableHeads,
      for (final g in greaseTypes) ...[g.maker, ...g.types],
      lubricantsFootnote,
      lubricantsTableCaption,
    ];
