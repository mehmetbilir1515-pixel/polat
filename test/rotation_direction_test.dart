import 'package:flutter_test/flutter_test.dart';
import 'package:polat_rd/calculators/rotation_direction.dart';

// ÜRETİLDİ: kaynak HTML verisinden (Node). Şanzıman süzgeci bileşen bazlıdır:
// "CYCLO (ZS)-PLANET (ZSPV)" hem CYCLO (ZS) hem PLANET (ZSPV) seçiminde görünür.
const modelOptions = <String>[
  'P47- ŞANZIMAN DÜZ TARAFTA',
  'P47- ŞANZIMAN KONİK TARAFTA',
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ',
  'S200',
  'S300 / S350',
  'S430 / S470 / S530 / S570',
  'S670',
  'SX435 / SX475 / SX575',
  'SX650',
  'SX840',
  'SX920',
];

const gearboxOptions = <String>[
  'CYCLO (ZS)',
  'DESCH ZG',
  'PLANET (ZSPN)',
  'PLANET (ZSPV)',
];

const expectedCounts = <String, int>{
  'all|all|all': 40,
  'all|all|Ana Motor': 20,
  'all|all|Helezon Motoru': 20,
  'all|CYCLO (ZS)|all': 22,
  'all|CYCLO (ZS)|Ana Motor': 11,
  'all|CYCLO (ZS)|Helezon Motoru': 11,
  'all|DESCH ZG|all': 2,
  'all|DESCH ZG|Ana Motor': 1,
  'all|DESCH ZG|Helezon Motoru': 1,
  'all|PLANET (ZSPN)|all': 18,
  'all|PLANET (ZSPN)|Ana Motor': 9,
  'all|PLANET (ZSPN)|Helezon Motoru': 9,
  'all|PLANET (ZSPV)|all': 10,
  'all|PLANET (ZSPV)|Ana Motor': 5,
  'all|PLANET (ZSPV)|Helezon Motoru': 5,
  'P47- ŞANZIMAN DÜZ TARAFTA|all|all': 4,
  'P47- ŞANZIMAN DÜZ TARAFTA|all|Ana Motor': 2,
  'P47- ŞANZIMAN DÜZ TARAFTA|all|Helezon Motoru': 2,
  'P47- ŞANZIMAN DÜZ TARAFTA|CYCLO (ZS)|all': 2,
  'P47- ŞANZIMAN DÜZ TARAFTA|CYCLO (ZS)|Ana Motor': 1,
  'P47- ŞANZIMAN DÜZ TARAFTA|CYCLO (ZS)|Helezon Motoru': 1,
  'P47- ŞANZIMAN DÜZ TARAFTA|DESCH ZG|all': 0,
  'P47- ŞANZIMAN DÜZ TARAFTA|DESCH ZG|Ana Motor': 0,
  'P47- ŞANZIMAN DÜZ TARAFTA|DESCH ZG|Helezon Motoru': 0,
  'P47- ŞANZIMAN DÜZ TARAFTA|PLANET (ZSPN)|all': 2,
  'P47- ŞANZIMAN DÜZ TARAFTA|PLANET (ZSPN)|Ana Motor': 1,
  'P47- ŞANZIMAN DÜZ TARAFTA|PLANET (ZSPN)|Helezon Motoru': 1,
  'P47- ŞANZIMAN DÜZ TARAFTA|PLANET (ZSPV)|all': 2,
  'P47- ŞANZIMAN DÜZ TARAFTA|PLANET (ZSPV)|Ana Motor': 1,
  'P47- ŞANZIMAN DÜZ TARAFTA|PLANET (ZSPV)|Helezon Motoru': 1,
  'P47- ŞANZIMAN KONİK TARAFTA|all|all': 4,
  'P47- ŞANZIMAN KONİK TARAFTA|all|Ana Motor': 2,
  'P47- ŞANZIMAN KONİK TARAFTA|all|Helezon Motoru': 2,
  'P47- ŞANZIMAN KONİK TARAFTA|CYCLO (ZS)|all': 2,
  'P47- ŞANZIMAN KONİK TARAFTA|CYCLO (ZS)|Ana Motor': 1,
  'P47- ŞANZIMAN KONİK TARAFTA|CYCLO (ZS)|Helezon Motoru': 1,
  'P47- ŞANZIMAN KONİK TARAFTA|DESCH ZG|all': 0,
  'P47- ŞANZIMAN KONİK TARAFTA|DESCH ZG|Ana Motor': 0,
  'P47- ŞANZIMAN KONİK TARAFTA|DESCH ZG|Helezon Motoru': 0,
  'P47- ŞANZIMAN KONİK TARAFTA|PLANET (ZSPN)|all': 2,
  'P47- ŞANZIMAN KONİK TARAFTA|PLANET (ZSPN)|Ana Motor': 1,
  'P47- ŞANZIMAN KONİK TARAFTA|PLANET (ZSPN)|Helezon Motoru': 1,
  'P47- ŞANZIMAN KONİK TARAFTA|PLANET (ZSPV)|all': 2,
  'P47- ŞANZIMAN KONİK TARAFTA|PLANET (ZSPV)|Ana Motor': 1,
  'P47- ŞANZIMAN KONİK TARAFTA|PLANET (ZSPV)|Helezon Motoru': 1,
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ|all|all': 2,
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ|all|Ana Motor': 1,
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ|all|Helezon Motoru': 1,
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ|CYCLO (ZS)|all': 2,
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ|CYCLO (ZS)|Ana Motor': 1,
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ|CYCLO (ZS)|Helezon Motoru': 1,
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ|DESCH ZG|all': 0,
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ|DESCH ZG|Ana Motor': 0,
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ|DESCH ZG|Helezon Motoru': 0,
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ|PLANET (ZSPN)|all': 0,
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ|PLANET (ZSPN)|Ana Motor': 0,
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ|PLANET (ZSPN)|Helezon Motoru': 0,
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ|PLANET (ZSPV)|all': 0,
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ|PLANET (ZSPV)|Ana Motor': 0,
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ|PLANET (ZSPV)|Helezon Motoru': 0,
  'S200|all|all': 2,
  'S200|all|Ana Motor': 1,
  'S200|all|Helezon Motoru': 1,
  'S200|CYCLO (ZS)|all': 2,
  'S200|CYCLO (ZS)|Ana Motor': 1,
  'S200|CYCLO (ZS)|Helezon Motoru': 1,
  'S200|DESCH ZG|all': 0,
  'S200|DESCH ZG|Ana Motor': 0,
  'S200|DESCH ZG|Helezon Motoru': 0,
  'S200|PLANET (ZSPN)|all': 0,
  'S200|PLANET (ZSPN)|Ana Motor': 0,
  'S200|PLANET (ZSPN)|Helezon Motoru': 0,
  'S200|PLANET (ZSPV)|all': 0,
  'S200|PLANET (ZSPV)|Ana Motor': 0,
  'S200|PLANET (ZSPV)|Helezon Motoru': 0,
  'S300 / S350|all|all': 4,
  'S300 / S350|all|Ana Motor': 2,
  'S300 / S350|all|Helezon Motoru': 2,
  'S300 / S350|CYCLO (ZS)|all': 2,
  'S300 / S350|CYCLO (ZS)|Ana Motor': 1,
  'S300 / S350|CYCLO (ZS)|Helezon Motoru': 1,
  'S300 / S350|DESCH ZG|all': 0,
  'S300 / S350|DESCH ZG|Ana Motor': 0,
  'S300 / S350|DESCH ZG|Helezon Motoru': 0,
  'S300 / S350|PLANET (ZSPN)|all': 2,
  'S300 / S350|PLANET (ZSPN)|Ana Motor': 1,
  'S300 / S350|PLANET (ZSPN)|Helezon Motoru': 1,
  'S300 / S350|PLANET (ZSPV)|all': 0,
  'S300 / S350|PLANET (ZSPV)|Ana Motor': 0,
  'S300 / S350|PLANET (ZSPV)|Helezon Motoru': 0,
  'S430 / S470 / S530 / S570|all|all': 4,
  'S430 / S470 / S530 / S570|all|Ana Motor': 2,
  'S430 / S470 / S530 / S570|all|Helezon Motoru': 2,
  'S430 / S470 / S530 / S570|CYCLO (ZS)|all': 2,
  'S430 / S470 / S530 / S570|CYCLO (ZS)|Ana Motor': 1,
  'S430 / S470 / S530 / S570|CYCLO (ZS)|Helezon Motoru': 1,
  'S430 / S470 / S530 / S570|DESCH ZG|all': 0,
  'S430 / S470 / S530 / S570|DESCH ZG|Ana Motor': 0,
  'S430 / S470 / S530 / S570|DESCH ZG|Helezon Motoru': 0,
  'S430 / S470 / S530 / S570|PLANET (ZSPN)|all': 2,
  'S430 / S470 / S530 / S570|PLANET (ZSPN)|Ana Motor': 1,
  'S430 / S470 / S530 / S570|PLANET (ZSPN)|Helezon Motoru': 1,
  'S430 / S470 / S530 / S570|PLANET (ZSPV)|all': 0,
  'S430 / S470 / S530 / S570|PLANET (ZSPV)|Ana Motor': 0,
  'S430 / S470 / S530 / S570|PLANET (ZSPV)|Helezon Motoru': 0,
  'S670|all|all': 4,
  'S670|all|Ana Motor': 2,
  'S670|all|Helezon Motoru': 2,
  'S670|CYCLO (ZS)|all': 2,
  'S670|CYCLO (ZS)|Ana Motor': 1,
  'S670|CYCLO (ZS)|Helezon Motoru': 1,
  'S670|DESCH ZG|all': 0,
  'S670|DESCH ZG|Ana Motor': 0,
  'S670|DESCH ZG|Helezon Motoru': 0,
  'S670|PLANET (ZSPN)|all': 2,
  'S670|PLANET (ZSPN)|Ana Motor': 1,
  'S670|PLANET (ZSPN)|Helezon Motoru': 1,
  'S670|PLANET (ZSPV)|all': 0,
  'S670|PLANET (ZSPV)|Ana Motor': 0,
  'S670|PLANET (ZSPV)|Helezon Motoru': 0,
  'SX435 / SX475 / SX575|all|all': 4,
  'SX435 / SX475 / SX575|all|Ana Motor': 2,
  'SX435 / SX475 / SX575|all|Helezon Motoru': 2,
  'SX435 / SX475 / SX575|CYCLO (ZS)|all': 2,
  'SX435 / SX475 / SX575|CYCLO (ZS)|Ana Motor': 1,
  'SX435 / SX475 / SX575|CYCLO (ZS)|Helezon Motoru': 1,
  'SX435 / SX475 / SX575|DESCH ZG|all': 0,
  'SX435 / SX475 / SX575|DESCH ZG|Ana Motor': 0,
  'SX435 / SX475 / SX575|DESCH ZG|Helezon Motoru': 0,
  'SX435 / SX475 / SX575|PLANET (ZSPN)|all': 2,
  'SX435 / SX475 / SX575|PLANET (ZSPN)|Ana Motor': 1,
  'SX435 / SX475 / SX575|PLANET (ZSPN)|Helezon Motoru': 1,
  'SX435 / SX475 / SX575|PLANET (ZSPV)|all': 2,
  'SX435 / SX475 / SX575|PLANET (ZSPV)|Ana Motor': 1,
  'SX435 / SX475 / SX575|PLANET (ZSPV)|Helezon Motoru': 1,
  'SX650|all|all': 4,
  'SX650|all|Ana Motor': 2,
  'SX650|all|Helezon Motoru': 2,
  'SX650|CYCLO (ZS)|all': 2,
  'SX650|CYCLO (ZS)|Ana Motor': 1,
  'SX650|CYCLO (ZS)|Helezon Motoru': 1,
  'SX650|DESCH ZG|all': 0,
  'SX650|DESCH ZG|Ana Motor': 0,
  'SX650|DESCH ZG|Helezon Motoru': 0,
  'SX650|PLANET (ZSPN)|all': 2,
  'SX650|PLANET (ZSPN)|Ana Motor': 1,
  'SX650|PLANET (ZSPN)|Helezon Motoru': 1,
  'SX650|PLANET (ZSPV)|all': 2,
  'SX650|PLANET (ZSPV)|Ana Motor': 1,
  'SX650|PLANET (ZSPV)|Helezon Motoru': 1,
  'SX840|all|all': 4,
  'SX840|all|Ana Motor': 2,
  'SX840|all|Helezon Motoru': 2,
  'SX840|CYCLO (ZS)|all': 2,
  'SX840|CYCLO (ZS)|Ana Motor': 1,
  'SX840|CYCLO (ZS)|Helezon Motoru': 1,
  'SX840|DESCH ZG|all': 0,
  'SX840|DESCH ZG|Ana Motor': 0,
  'SX840|DESCH ZG|Helezon Motoru': 0,
  'SX840|PLANET (ZSPN)|all': 2,
  'SX840|PLANET (ZSPN)|Ana Motor': 1,
  'SX840|PLANET (ZSPN)|Helezon Motoru': 1,
  'SX840|PLANET (ZSPV)|all': 2,
  'SX840|PLANET (ZSPV)|Ana Motor': 1,
  'SX840|PLANET (ZSPV)|Helezon Motoru': 1,
  'SX920|all|all': 4,
  'SX920|all|Ana Motor': 2,
  'SX920|all|Helezon Motoru': 2,
  'SX920|CYCLO (ZS)|all': 2,
  'SX920|CYCLO (ZS)|Ana Motor': 1,
  'SX920|CYCLO (ZS)|Helezon Motoru': 1,
  'SX920|DESCH ZG|all': 2,
  'SX920|DESCH ZG|Ana Motor': 1,
  'SX920|DESCH ZG|Helezon Motoru': 1,
  'SX920|PLANET (ZSPN)|all': 2,
  'SX920|PLANET (ZSPN)|Ana Motor': 1,
  'SX920|PLANET (ZSPN)|Helezon Motoru': 1,
  'SX920|PLANET (ZSPV)|all': 0,
  'SX920|PLANET (ZSPV)|Ana Motor': 0,
  'SX920|PLANET (ZSPV)|Helezon Motoru': 0,
};

const expectedRows = <String, List<String>>{
  'P47- ŞANZIMAN DÜZ TARAFTA|all|all': [
    'P47- ŞANZIMAN DÜZ TARAFTA CYCLO (ZS)- PLANET (ZSPV) Ana Motor SAAT YÖNÜ Düz gövde tarafı',
    'P47- ŞANZIMAN DÜZ TARAFTA CYCLO (ZS)- PLANET (ZSPV) Helezon Motoru SAAT YÖNÜ Düz gövde tarafı',
    'P47- ŞANZIMAN DÜZ TARAFTA PLANET (ZSPN) Ana Motor SAAT YÖNÜ TERSİ Düz gövde tarafı',
    'P47- ŞANZIMAN DÜZ TARAFTA PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ TERSİ Düz gövde tarafı',
  ],
  'P47- ŞANZIMAN KONİK TARAFTA|all|all': [
    'P47- ŞANZIMAN KONİK TARAFTA CYCLO (ZS)- PLANET (ZSPV) Ana Motor SAAT YÖNÜ TERSİ Konik gövde tarafı',
    'P47- ŞANZIMAN KONİK TARAFTA CYCLO (ZS)- PLANET (ZSPV) Helezon Motoru SAAT YÖNÜ TERSİ Konik gövde tarafı',
    'P47- ŞANZIMAN KONİK TARAFTA PLANET (ZSPN) Ana Motor SAAT YÖNÜ Konik gövde tarafı',
    'P47- ŞANZIMAN KONİK TARAFTA PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ Konik gövde tarafı',
  ],
  'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ|all|all': [
    'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ CYCLO (ZS) Ana Motor SAAT YÖNÜ TERSİ Zeytinyağı dekantörü',
    'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ CYCLO (ZS) Helezon Motoru SAAT YÖNÜ TERSİ Zeytinyağı dekantörü',
  ],
  'S200|all|all': [
    'S200 CYCLO (ZS) Ana Motor SAAT YÖNÜ TERSİ -',
    'S200 CYCLO (ZS) Helezon Motoru SAAT YÖNÜ -',
  ],
  'S300 / S350|all|all': [
    'S300 / S350 CYCLO (ZS) Ana Motor SAAT YÖNÜ TERSİ -',
    'S300 / S350 CYCLO (ZS) Helezon Motoru SAAT YÖNÜ -',
    'S300 / S350 PLANET (ZSPN) Ana Motor SAAT YÖNÜ -',
    'S300 / S350 PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ TERSİ -',
  ],
  'S430 / S470 / S530 / S570|all|all': [
    'S430 / S470 / S530 / S570 CYCLO (ZS) Ana Motor SAAT YÖNÜ TERSİ -',
    'S430 / S470 / S530 / S570 CYCLO (ZS) Helezon Motoru SAAT YÖNÜ -',
    'S430 / S470 / S530 / S570 PLANET (ZSPN) Ana Motor SAAT YÖNÜ -',
    'S430 / S470 / S530 / S570 PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ TERSİ -',
  ],
  'S670|all|all': [
    'S670 CYCLO (ZS) Ana Motor SAAT YÖNÜ TERSİ -',
    'S670 CYCLO (ZS) Helezon Motoru SAAT YÖNÜ -',
    'S670 PLANET (ZSPN) Ana Motor SAAT YÖNÜ -',
    'S670 PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ TERSİ -',
  ],
  'SX435 / SX475 / SX575|all|all': [
    'SX435 / SX475 / SX575 CYCLO (ZS)- PLANET (ZSPV) Ana Motor SAAT YÖNÜ TERSİ -',
    'SX435 / SX475 / SX575 CYCLO (ZS)- PLANET (ZSPV) Helezon Motoru SAAT YÖNÜ TERSİ -',
    'SX435 / SX475 / SX575 PLANET (ZSPN) Ana Motor SAAT YÖNÜ -',
    'SX435 / SX475 / SX575 PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ -',
  ],
  'SX650|all|all': [
    'SX650 CYCLO (ZS)-PLANET (ZSPV) Ana Motor SAAT YÖNÜ TERSİ -',
    'SX650 CYCLO (ZS)-PLANET (ZSPV) Helezon Motoru SAAT YÖNÜ -',
    'SX650 PLANET (ZSPN) Ana Motor SAAT YÖNÜ -',
    'SX650 PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ TERSİ -',
  ],
  'SX840|all|all': [
    'SX840 CYCLO (ZS)-PLANET (ZSPV) Ana Motor SAAT YÖNÜ TERSİ -',
    'SX840 CYCLO (ZS)-PLANET (ZSPV) Helezon Motoru SAAT YÖNÜ TERSİ -',
    'SX840 PLANET (ZSPN) Ana Motor SAAT YÖNÜ -',
    'SX840 PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ -',
  ],
  'SX920|all|all': [
    'SX920 CYCLO (ZS)-DESCH ZG Ana Motor SAAT YÖNÜ TERSİ Desch şanzıman',
    'SX920 CYCLO (ZS)-DESCH ZG Helezon Motoru SAAT YÖNÜ TERSİ Desch şanzıman',
    'SX920 PLANET (ZSPN) Ana Motor SAAT YÖNÜ -',
    'SX920 PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ -',
  ],
  'all|CYCLO (ZS)|all': [
    'S200 CYCLO (ZS) Ana Motor SAAT YÖNÜ TERSİ -',
    'S200 CYCLO (ZS) Helezon Motoru SAAT YÖNÜ -',
    'S300 / S350 CYCLO (ZS) Ana Motor SAAT YÖNÜ TERSİ -',
    'S300 / S350 CYCLO (ZS) Helezon Motoru SAAT YÖNÜ -',
    'S430 / S470 / S530 / S570 CYCLO (ZS) Ana Motor SAAT YÖNÜ TERSİ -',
    'S430 / S470 / S530 / S570 CYCLO (ZS) Helezon Motoru SAAT YÖNÜ -',
    'SX435 / SX475 / SX575 CYCLO (ZS)- PLANET (ZSPV) Ana Motor SAAT YÖNÜ TERSİ -',
    'SX435 / SX475 / SX575 CYCLO (ZS)- PLANET (ZSPV) Helezon Motoru SAAT YÖNÜ TERSİ -',
    'P47- ŞANZIMAN KONİK TARAFTA CYCLO (ZS)- PLANET (ZSPV) Ana Motor SAAT YÖNÜ TERSİ Konik gövde tarafı',
    'P47- ŞANZIMAN KONİK TARAFTA CYCLO (ZS)- PLANET (ZSPV) Helezon Motoru SAAT YÖNÜ TERSİ Konik gövde tarafı',
    'P47- ŞANZIMAN DÜZ TARAFTA CYCLO (ZS)- PLANET (ZSPV) Ana Motor SAAT YÖNÜ Düz gövde tarafı',
    'P47- ŞANZIMAN DÜZ TARAFTA CYCLO (ZS)- PLANET (ZSPV) Helezon Motoru SAAT YÖNÜ Düz gövde tarafı',
    'SX650 CYCLO (ZS)-PLANET (ZSPV) Ana Motor SAAT YÖNÜ TERSİ -',
    'SX650 CYCLO (ZS)-PLANET (ZSPV) Helezon Motoru SAAT YÖNÜ -',
    'S670 CYCLO (ZS) Ana Motor SAAT YÖNÜ TERSİ -',
    'S670 CYCLO (ZS) Helezon Motoru SAAT YÖNÜ -',
    'SX840 CYCLO (ZS)-PLANET (ZSPV) Ana Motor SAAT YÖNÜ TERSİ -',
    'SX840 CYCLO (ZS)-PLANET (ZSPV) Helezon Motoru SAAT YÖNÜ TERSİ -',
    'SX920 CYCLO (ZS)-DESCH ZG Ana Motor SAAT YÖNÜ TERSİ Desch şanzıman',
    'SX920 CYCLO (ZS)-DESCH ZG Helezon Motoru SAAT YÖNÜ TERSİ Desch şanzıman',
    'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ CYCLO (ZS) Ana Motor SAAT YÖNÜ TERSİ Zeytinyağı dekantörü',
    'PX- PXZ ZEYTİNYAĞI DEKANTÖRLERİ CYCLO (ZS) Helezon Motoru SAAT YÖNÜ TERSİ Zeytinyağı dekantörü',
  ],
  'all|DESCH ZG|all': [
    'SX920 CYCLO (ZS)-DESCH ZG Ana Motor SAAT YÖNÜ TERSİ Desch şanzıman',
    'SX920 CYCLO (ZS)-DESCH ZG Helezon Motoru SAAT YÖNÜ TERSİ Desch şanzıman',
  ],
  'all|PLANET (ZSPN)|all': [
    'S300 / S350 PLANET (ZSPN) Ana Motor SAAT YÖNÜ -',
    'S300 / S350 PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ TERSİ -',
    'S430 / S470 / S530 / S570 PLANET (ZSPN) Ana Motor SAAT YÖNÜ -',
    'S430 / S470 / S530 / S570 PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ TERSİ -',
    'SX435 / SX475 / SX575 PLANET (ZSPN) Ana Motor SAAT YÖNÜ -',
    'SX435 / SX475 / SX575 PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ -',
    'P47- ŞANZIMAN KONİK TARAFTA PLANET (ZSPN) Ana Motor SAAT YÖNÜ Konik gövde tarafı',
    'P47- ŞANZIMAN KONİK TARAFTA PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ Konik gövde tarafı',
    'P47- ŞANZIMAN DÜZ TARAFTA PLANET (ZSPN) Ana Motor SAAT YÖNÜ TERSİ Düz gövde tarafı',
    'P47- ŞANZIMAN DÜZ TARAFTA PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ TERSİ Düz gövde tarafı',
    'SX650 PLANET (ZSPN) Ana Motor SAAT YÖNÜ -',
    'SX650 PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ TERSİ -',
    'S670 PLANET (ZSPN) Ana Motor SAAT YÖNÜ -',
    'S670 PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ TERSİ -',
    'SX840 PLANET (ZSPN) Ana Motor SAAT YÖNÜ -',
    'SX840 PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ -',
    'SX920 PLANET (ZSPN) Ana Motor SAAT YÖNÜ -',
    'SX920 PLANET (ZSPN) Helezon Motoru SAAT YÖNÜ -',
  ],
  'all|PLANET (ZSPV)|all': [
    'SX435 / SX475 / SX575 CYCLO (ZS)- PLANET (ZSPV) Ana Motor SAAT YÖNÜ TERSİ -',
    'SX435 / SX475 / SX575 CYCLO (ZS)- PLANET (ZSPV) Helezon Motoru SAAT YÖNÜ TERSİ -',
    'P47- ŞANZIMAN KONİK TARAFTA CYCLO (ZS)- PLANET (ZSPV) Ana Motor SAAT YÖNÜ TERSİ Konik gövde tarafı',
    'P47- ŞANZIMAN KONİK TARAFTA CYCLO (ZS)- PLANET (ZSPV) Helezon Motoru SAAT YÖNÜ TERSİ Konik gövde tarafı',
    'P47- ŞANZIMAN DÜZ TARAFTA CYCLO (ZS)- PLANET (ZSPV) Ana Motor SAAT YÖNÜ Düz gövde tarafı',
    'P47- ŞANZIMAN DÜZ TARAFTA CYCLO (ZS)- PLANET (ZSPV) Helezon Motoru SAAT YÖNÜ Düz gövde tarafı',
    'SX650 CYCLO (ZS)-PLANET (ZSPV) Ana Motor SAAT YÖNÜ TERSİ -',
    'SX650 CYCLO (ZS)-PLANET (ZSPV) Helezon Motoru SAAT YÖNÜ -',
    'SX840 CYCLO (ZS)-PLANET (ZSPV) Ana Motor SAAT YÖNÜ TERSİ -',
    'SX840 CYCLO (ZS)-PLANET (ZSPV) Helezon Motoru SAAT YÖNÜ TERSİ -',
  ],
};

String _sig(RotationEntry e) =>
    '${e.model} ${e.gearbox} ${e.motor} ${e.direction.label} ${e.note.isEmpty ? '-' : e.note}';

void main() {
  test('Benzersiz model ve şanzıman bileşen listeleri HTML verisi ile aynı', () {
    expect(rotationModels, modelOptions);
    expect(rotationGearboxes, gearboxOptions);
    expect(rotationEntries.length, 40);
  });

  test('Her model/şanzıman/motor birleşimi için kayıt sayısı HTML ile aynı', () {
    for (final entry in expectedCounts.entries) {
      final parts = entry.key.split('|');
      String? v(String s) => s == 'all' ? null : s;
      final result = filterRotation(model: v(parts[0]), gearbox: v(parts[1]), motor: v(parts[2]));
      expect(result.length, entry.value, reason: entry.key);
    }
  });

  test('Model veya motor süzgeci HTML satırlarını aynı sırayla verir', () {
    for (final entry in expectedRows.entries) {
      final parts = entry.key.split('|');
      String? v(String s) => s == 'all' ? null : s;
      final result = filterRotation(model: v(parts[0]), gearbox: v(parts[1]), motor: v(parts[2]));
      expect(result.map(_sig).toList(), entry.value, reason: entry.key);
    }
  });

  test('Her modelde ana ve helezon motoru için birer satır vardır (şanzıman başına)', () {
    for (final e in rotationEntries.where((e) => e.motor == mainMotor)) {
      final pair = rotationEntries
          .where((x) => x.model == e.model && x.gearbox == e.gearbox)
          .toList();
      expect(pair.map((x) => x.motor).toList(), [mainMotor, scrollMotor], reason: _sig(e));
    }
  });

  test('Örnek: S200 ana motor saat yönü tersi, helezon motoru saat yönü', () {
    final main = filterRotation(model: 'S200', motor: mainMotor).single;
    final scroll = filterRotation(model: 'S200', motor: scrollMotor).single;
    expect(main.direction, RotationDirection.counterClockwise);
    expect(scroll.direction, RotationDirection.clockwise);
  });

  test('Birleşik şanzımanlar tek biçimde gösterilir ve bileşen süzgecinde görünür', () {
    expect(rotationGearboxes.where((g) => g.contains('-')), isEmpty);
    // İki farklı yazım ("- " ve "-") tek etikete iner.
    final labels = {for (final e in rotationEntries) e.gearboxLabel};
    expect(labels, contains('CYCLO (ZS) - PLANET (ZSPV)'));
    expect(labels.where((l) => l.contains('ZSPV')).length, 1);
    // CYCLO (ZS): saf CYCLO + ZSPV birleşikleri + DESCH birleşiği.
    final cyclo = filterRotation(gearbox: 'CYCLO (ZS)');
    expect(cyclo.length, 22);
    expect(cyclo.any((e) => e.gearbox.contains('ZSPV')), isTrue);
    expect(cyclo.any((e) => e.gearbox.contains('DESCH')), isTrue);
    expect(filterRotation(gearbox: 'PLANET (ZSPV)').length, 10);
  });
}
