// Şanzıman tork ve yağlama bilgisi.
//
// Veri, kullanıcının gönderdiği "Şanzıman Tipi / Şanzıman Torku / Yağ Bilgisi / Yağ Miktarı"
// tablosundan alınmıştır (28 şanzıman; sıra tablodaki gibi). Satırlar tablodan betikle üretilir
// (elle yazılmaz); test beklentileri tablonun ham metninden ayrıca ayrıştırılır.
// Veri değişirse tablo kaynak alınıp bu dosya ve test/gearbox_torque_test.dart yeniden üretilir.

/// Şanzımanda kullanılan yağın türü.
enum GearboxOil {
  /// Gres: miktar kg cinsindendir.
  grease('Gres', 'kg'),

  /// Sıvı yağ: miktar litre cinsindendir.
  liquid('Sıvı', 'L');

  const GearboxOil(this.label, this.unit);

  /// Ekranda gösterilen ad ("Gres" / "Sıvı").
  final String label;

  /// Miktar birimi ("kg" / "L").
  final String unit;
}

/// Her şanzıman seçiminin altında gösterilen yağ kodu ve tanımı bilgisi.
const String greaseCodeNote = 'Gres kodu ve tanımı: 150030090152 SHELL GADUS S2 U460L 2';
const String liquidOilCodeNote =
    'Sıvı Yağ Kodu ve Tanımı: 150030090006 MİNERAL DİŞLİ YAĞI VİSKOZİTE 220';

/// Bir şanzıman tipinin maksimum tork dayanımı ve yağlama bilgisi.
class GearboxTorque {
  const GearboxTorque(this.model, this.maxTorqueNm, this.oil, this.oilAmount);

  /// Şanzıman tipi (ör. "ZS612/87").
  final String model;

  /// Maksimum tork dayanımı (Nm).
  final int maxTorqueNm;

  /// Yağ bilgisi: gres veya sıvı.
  final GearboxOil oil;

  /// Yağ miktarı; birim [oil] türüne göre kg (gres) veya L (sıvı).
  final double oilAmount;
}

/// Seçim listesi için şanzıman tipleri (tablo sırasıyla).
List<String> get gearboxTorqueModels => [for (final g in gearboxTorques) g.model];

/// Şanzıman tipine göre kayıt; yoksa null.
GearboxTorque? gearboxTorqueFor(String model) {
  for (final g in gearboxTorques) {
    if (g.model == model) {
      return g;
    }
  }
  return null;
}

const List<GearboxTorque> gearboxTorques = [
  GearboxTorque('ZS612/87', 630, GearboxOil.grease, 0.3),
  GearboxTorque('ZSPN612/105', 630, GearboxOil.liquid, 0.7),
  GearboxTorque('ZS614/87', 1250, GearboxOil.grease, 1),
  GearboxTorque('ZSPN614/105', 1370, GearboxOil.liquid, 1),
  GearboxTorque('ZS616M/87', 2050, GearboxOil.grease, 1.1),
  GearboxTorque('ZSPN617/129', 3150, GearboxOil.liquid, 2),
  GearboxTorque('ZSPN616/129', 2100, GearboxOil.liquid, 1.6),
  GearboxTorque('ZSPN619/129', 7960, GearboxOil.liquid, 5),
  GearboxTorque('ZS619LX/59', 10400, GearboxOil.liquid, 4.3),
  GearboxTorque('ZS617FX/87', 3150, GearboxOil.grease, 1.7),
  GearboxTorque('ZSPV619/84', 7960, GearboxOil.liquid, 5.2),
  GearboxTorque('ZSPN618/129', 5000, GearboxOil.liquid, 3.5),
  GearboxTorque('ZSPN621/129', 12650, GearboxOil.liquid, 5.5),
  GearboxTorque('ZSPR619LX/150-177', 10400, GearboxOil.liquid, 6.3),
  GearboxTorque('ZSPN622/129', 16000, GearboxOil.liquid, 6.8),
  GearboxTorque('ZSPV619LX/150-116', 12000, GearboxOil.liquid, 5.9),
  GearboxTorque('ZSPN623/129', 20500, GearboxOil.liquid, 8),
  GearboxTorque('ZSPN625/129', 30960, GearboxOil.liquid, 14),
  GearboxTorque('DESCH ZG50 - İ:80/1', 50000, GearboxOil.liquid, 42),
  GearboxTorque('ZS 612/17', 630, GearboxOil.grease, 0.3),
  GearboxTorque('ZS 616/25', 2100, GearboxOil.grease, 1.8),
  GearboxTorque('ZS 617/25', 3150, GearboxOil.liquid, 1.9),
  GearboxTorque('ZS 616-59', 2100, GearboxOil.grease, 1.4),
  GearboxTorque('ZS618FX-59', 5000, GearboxOil.liquid, 2.7),
  GearboxTorque('ZS 618/25', 5000, GearboxOil.grease, 2.2),
  GearboxTorque('ZS 619/25', 7960, GearboxOil.grease, 4.9),
  GearboxTorque('ZS619FX-59', 7960, GearboxOil.liquid, 4.2),
  GearboxTorque('ZS 622FX/59', 15880, GearboxOil.liquid, 6),
];
