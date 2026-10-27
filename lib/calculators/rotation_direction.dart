/// Dekantör motor dönüş yönü talimatı (AG-TL-09 Rev.04).
///
/// Veri kullanıcının "Dekantör Dönüş Yönü Talimatı" HTML sayfasından alınmıştır.
/// Satırlar HTML'den Node ile üretilir; elle değiştirmeyin.
library;

/// Motor dönüş yönü (motor mili ucundan dekantöre doğru bakışa göre).
enum RotationDirection {
  clockwise('SAAT YÖNÜ'),
  counterClockwise('SAAT YÖNÜ TERSİ');

  const RotationDirection(this.label);

  final String label;
}

class RotationEntry {
  const RotationEntry(this.model, this.gearbox, this.motor, this.direction, this.note);

  final String model;
  final String gearbox;
  final String motor;
  final RotationDirection direction;

  /// Açıklama / özel durum; yoksa boş.
  final String note;
}

const mainMotor = 'Ana Motor';
const scrollMotor = 'Helezon Motoru';
const motorTypes = <String>[mainMotor, scrollMotor];

/// Listede bulunan benzersiz modeller (HTML'deki gibi sıralı).
List<String> get rotationModels =>
    (rotationEntries.map((e) => e.model).toSet().toList()..sort());

/// Listede bulunan benzersiz şanzıman tipleri (HTML'deki gibi sıralı).
List<String> get rotationGearboxes =>
    (rotationEntries.map((e) => e.gearbox).toSet().toList()..sort());

/// Verilen ölçütlere uyan kayıtlar. `null` = "Tümü".
List<RotationEntry> filterRotation({String? model, String? gearbox, String? motor}) {
  return [
    for (final e in rotationEntries)
      if ((model == null || e.model == model) &&
          (gearbox == null || e.gearbox == gearbox) &&
          (motor == null || e.motor == motor))
        e,
  ];
}

const rotationEntries = <RotationEntry>[
  RotationEntry('S200', 'CYCLO (ZS)', 'Ana Motor', RotationDirection.counterClockwise, ''),
  RotationEntry('S200', 'CYCLO (ZS)', 'Helezon Motoru', RotationDirection.clockwise, ''),
  RotationEntry('S300 / S350', 'CYCLO (ZS)', 'Ana Motor', RotationDirection.counterClockwise, ''),
  RotationEntry('S300 / S350', 'CYCLO (ZS)', 'Helezon Motoru', RotationDirection.clockwise, ''),
  RotationEntry('S300 / S350', 'PLANET (ZSPN)', 'Ana Motor', RotationDirection.clockwise, ''),
  RotationEntry('S300 / S350', 'PLANET (ZSPN)', 'Helezon Motoru', RotationDirection.counterClockwise, ''),
  RotationEntry('S430 / S470 / S530 / S570', 'CYCLO (ZS)', 'Ana Motor', RotationDirection.counterClockwise, ''),
  RotationEntry('S430 / S470 / S530 / S570', 'CYCLO (ZS)', 'Helezon Motoru', RotationDirection.clockwise, ''),
  RotationEntry('S430 / S470 / S530 / S570', 'PLANET (ZSPN)', 'Ana Motor', RotationDirection.clockwise, ''),
  RotationEntry('S430 / S470 / S530 / S570', 'PLANET (ZSPN)', 'Helezon Motoru', RotationDirection.counterClockwise, ''),
  RotationEntry('SX435 / SX475 / SX575', 'CYCLO (ZS)- PLANET (ZSPV)', 'Ana Motor', RotationDirection.counterClockwise, ''),
  RotationEntry('SX435 / SX475 / SX575', 'CYCLO (ZS)- PLANET (ZSPV)', 'Helezon Motoru', RotationDirection.counterClockwise, ''),
  RotationEntry('SX435 / SX475 / SX575', 'PLANET (ZSPN)', 'Ana Motor', RotationDirection.clockwise, ''),
  RotationEntry('SX435 / SX475 / SX575', 'PLANET (ZSPN)', 'Helezon Motoru', RotationDirection.clockwise, ''),
  RotationEntry('P47- ŞANZIMAN KONİK TARAFTA', 'CYCLO (ZS)- PLANET (ZSPV)', 'Ana Motor', RotationDirection.counterClockwise, 'Konik gövde tarafı'),
  RotationEntry('P47- ŞANZIMAN KONİK TARAFTA', 'CYCLO (ZS)- PLANET (ZSPV)', 'Helezon Motoru', RotationDirection.counterClockwise, 'Konik gövde tarafı'),
  RotationEntry('P47- ŞANZIMAN KONİK TARAFTA', 'PLANET (ZSPN)', 'Ana Motor', RotationDirection.clockwise, 'Konik gövde tarafı'),
  RotationEntry('P47- ŞANZIMAN KONİK TARAFTA', 'PLANET (ZSPN)', 'Helezon Motoru', RotationDirection.clockwise, 'Konik gövde tarafı'),
  RotationEntry('P47- ŞANZIMAN DÜZ TARAFTA', 'CYCLO (ZS)- PLANET (ZSPV)', 'Ana Motor', RotationDirection.clockwise, 'Düz gövde tarafı'),
  RotationEntry('P47- ŞANZIMAN DÜZ TARAFTA', 'CYCLO (ZS)- PLANET (ZSPV)', 'Helezon Motoru', RotationDirection.clockwise, 'Düz gövde tarafı'),
  RotationEntry('P47- ŞANZIMAN DÜZ TARAFTA', 'PLANET (ZSPN)', 'Ana Motor', RotationDirection.counterClockwise, 'Düz gövde tarafı'),
  RotationEntry('P47- ŞANZIMAN DÜZ TARAFTA', 'PLANET (ZSPN)', 'Helezon Motoru', RotationDirection.counterClockwise, 'Düz gövde tarafı'),
  RotationEntry('SX650', 'CYCLO (ZS)-PLANET (ZSPV)', 'Ana Motor', RotationDirection.counterClockwise, ''),
  RotationEntry('SX650', 'CYCLO (ZS)-PLANET (ZSPV)', 'Helezon Motoru', RotationDirection.clockwise, ''),
  RotationEntry('SX650', 'PLANET (ZSPN)', 'Ana Motor', RotationDirection.clockwise, ''),
  RotationEntry('SX650', 'PLANET (ZSPN)', 'Helezon Motoru', RotationDirection.counterClockwise, ''),
  RotationEntry('S670', 'CYCLO (ZS)', 'Ana Motor', RotationDirection.counterClockwise, ''),
  RotationEntry('S670', 'CYCLO (ZS)', 'Helezon Motoru', RotationDirection.clockwise, ''),
  RotationEntry('S670', 'PLANET (ZSPN)', 'Ana Motor', RotationDirection.clockwise, ''),
  RotationEntry('S670', 'PLANET (ZSPN)', 'Helezon Motoru', RotationDirection.counterClockwise, ''),
  RotationEntry('SX840', 'CYCLO (ZS)-PLANET (ZSPV)', 'Ana Motor', RotationDirection.counterClockwise, ''),
  RotationEntry('SX840', 'CYCLO (ZS)-PLANET (ZSPV)', 'Helezon Motoru', RotationDirection.counterClockwise, ''),
  RotationEntry('SX840', 'PLANET (ZSPN)', 'Ana Motor', RotationDirection.clockwise, ''),
  RotationEntry('SX840', 'PLANET (ZSPN)', 'Helezon Motoru', RotationDirection.clockwise, ''),
  RotationEntry('SX920', 'CYCLO (ZS)-DESCH ZG', 'Ana Motor', RotationDirection.counterClockwise, 'Desch şanzıman'),
  RotationEntry('SX920', 'CYCLO (ZS)-DESCH ZG', 'Helezon Motoru', RotationDirection.counterClockwise, 'Desch şanzıman'),
  RotationEntry('SX920', 'PLANET (ZSPN)', 'Ana Motor', RotationDirection.clockwise, ''),
  RotationEntry('SX920', 'PLANET (ZSPN)', 'Helezon Motoru', RotationDirection.clockwise, ''),
  RotationEntry('PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ', 'CYCLO (ZS)', 'Ana Motor', RotationDirection.counterClockwise, 'Zeytinyağı dekantörü'),
  RotationEntry('PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ', 'CYCLO (ZS)', 'Helezon Motoru', RotationDirection.counterClockwise, 'Zeytinyağı dekantörü'),
];
