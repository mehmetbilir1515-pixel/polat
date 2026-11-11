// Şanzıman tork bilgisi.
//
// Veri, kullanıcının gönderdiği "Şanzıman Tipi / Şanzıman Torku" tablosundan alınmıştır
// (28 şanzıman; sıra tablodaki gibi). Satırlar tablodan betikle üretilir (elle yazılmaz);
// test beklentileri tablonun ham metninden ayrıca ayrıştırılır.
// Veri değişirse tablo kaynak alınıp bu dosya ve test/gearbox_torque_test.dart yeniden üretilir.

/// Bir şanzıman tipinin maksimum tork dayanımı.
class GearboxTorque {
  const GearboxTorque(this.model, this.maxTorqueNm);

  /// Şanzıman tipi (ör. "ZS612/87").
  final String model;

  /// Maksimum tork dayanımı (Nm).
  final int maxTorqueNm;
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
  GearboxTorque('ZS612/87', 630),
  GearboxTorque('ZSPN612/105', 630),
  GearboxTorque('ZS614/87', 1250),
  GearboxTorque('ZSPN614/105', 1370),
  GearboxTorque('ZS616M/87', 2050),
  GearboxTorque('ZSPN617/129', 3150),
  GearboxTorque('ZSPN616/129', 2100),
  GearboxTorque('ZSPN619/129', 7960),
  GearboxTorque('ZS619LX/59', 10400),
  GearboxTorque('ZS617FX/87', 3150),
  GearboxTorque('ZSPV619/84', 7960),
  GearboxTorque('ZSPN618/129', 5000),
  GearboxTorque('ZSPN621/129', 12650),
  GearboxTorque('ZSPR619LX/150-177', 10400),
  GearboxTorque('ZSPN622/129', 16000),
  GearboxTorque('ZSPV619LX/150-116', 12000),
  GearboxTorque('ZSPN623/129', 20500),
  GearboxTorque('ZSPN625/129', 30960),
  GearboxTorque('DESCH ZG50 - İ:80/1', 50000),
  GearboxTorque('ZS 612/17', 630),
  GearboxTorque('ZS 616/25', 2100),
  GearboxTorque('ZS 617/25', 3150),
  GearboxTorque('ZS 616-59', 2100),
  GearboxTorque('ZS618FX-59', 5000),
  GearboxTorque('ZS 618/25', 5000),
  GearboxTorque('ZS 619/25', 7960),
  GearboxTorque('ZS619FX-59', 7960),
  GearboxTorque('ZS 622FX/59', 15880),
];
