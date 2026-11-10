import 'package:flutter_test/flutter_test.dart';
import 'package:polat_rd/calculators/drive_config.dart';

// ÜRETİLDİ: Excel'in 'Konfigürasyon' sayfasından, ham XML okuyarak (Dart verisini üreten betikten bağımsız).
const expectedTotalConfigs = 81;
const expectedRawRows = 87;
const expectedSelections = <String>[
  'S200, Ø200mm',
  'S300, Ø300mm',
  'S350, Ø354mm',
  'S430, Ø430mm',
  'SX435, Ø430mm',
  'S470, Ø470mm',
  'SX475, Ø470mm',
  'S530, Ø530mm',
  'S570, Ø570mm',
  'SX575, Ø570mm',
  'SX650, Ø650mm',
  'S670, Ø692mm',
  'S840, Ø835mm',
  'S920, Ø920mm',
  'PX5, Ø232mm',
  'PX10, Ø232mm',
  'PX20, Ø354mm',
  'PX30, Ø354mm',
  'PX40, Ø470mm',
  'PXZ40, Ø354mm',
  'PXZ60, Ø470mm',
  'PXZ60 20°, Ø470mm',
  'PX70, Ø470mm',
  'PXZ80, Ø470mm',
  'PXZ80 20°, Ø470mm',
  'PXZ100, Ø470mm',
  'PXZ120, Ø470mm',
  'PX160, Ø570mm',
  'PXZ160, Ø570mm',
  'PXE160, Ø570mm',
  'PXE250, Ø570mm',
  'PXE500, Ø570mm',
];

// Seçim -> o seçimdeki yapılandırmaların imzaları (Excel sırasıyla; 12 hücre '|' ile birleşik, 'X' = boş).
const expectedConfigs = <String, List<String>>{
  'S200, Ø200mm': [
    'S200, Ø200mm|5,5KW - 3000D/D - B5 - IE3|2,2KW - 3000D/D - B3 - IE3|ZS612/87|630 Nm|10°|⌀201mm|⌀204mm|⌀136mm|⌀110mm|5482|4500',
    'S200, Ø200mm|5,5KW - 3000D/D - B5 - IE3|2,2KW - 3000D/D - B3 - IE3|ZSPN612/105|630 Nm|10°|⌀201mm|⌀204mm|⌀136mm|⌀110mm|5482|4500',
  ],
  'S300, Ø300mm': [
    'S300, Ø300mm|15KW - 3000D/D - B5 - IE3|5,5KW - 3000D/D - B5 - IE3|ZS614/87|1250 Nm|10°|⌀229,5mm|YOK|YOK|⌀160mm|4303|X',
    'S300, Ø300mm|18,5KW - 3000D/D - B5 - IE3|5,5KW - 3000D/D - B5 - IE3|ZS614/87|1250 Nm|10°|⌀229,5mm|YOK|YOK|⌀160mm|4303|X',
    'S300, Ø300mm|15KW - 3000D/D - B5 - IE3|4KW - 3000D/D - B3 - IE3|ZSPN614/105|1370 Nm|10°|⌀229,5mm|⌀185,5mm|⌀184mm|⌀160mm|4303|3024',
    'S300, Ø300mm|15KW - 3000D/D - B5 - IE3|5,5KW - 3000D/D - B5 - IE3|ZS616M/87|2050 Nm|10°|⌀229,5mm|YOK|YOK|⌀160mm|4303|X',
    'S300, Ø300mm|15KW - 3000D/D - B5 - IE3|4KW - 3000D/D - B5 - IE3|ZS614/87|1250 Nm|10°|⌀229,5mm|YOK|YOK|⌀160mm|4303|X',
  ],
  'S350, Ø354mm': [
    'S350, Ø354mm|22KW - 3000D/D - B5 - IE3|7,5KW - 3000D/D - B5 - IE3|ZS616M/87|2050 Nm|10°|⌀255,5mm|YOK|YOK|⌀197,7mm|3877|X',
    'S350, Ø354mm|30KW - 3000D/D - B5 - IE3|7,5KW - 3000D/D - B5 - IE3|ZS616M/87|2050 Nm|10°|⌀255,5mm|YOK|YOK|⌀197,7mm|3877|X',
    'S350, Ø354mm|22KW - 3000D/D - B5 - IE3|7,5KW - 3000D/D - B3 - IE3|ZSPN617/129|3150 Nm|10°|⌀255,5mm|⌀205,5mm|⌀205,5mm|⌀197,7mm|3877|3000',
    'S350, Ø354mm|22KW - 3000D/D - B5 - IE3|5,5KW - 3000D/D - B3 - IE3|ZSPN616/129|2100 Nm|10°|⌀255,5mm|⌀205,5mm|⌀205,5mm|⌀197,7mm|3877|3000',
    'S350, Ø354mm|30KW - 3000D/D - B5 - IE3|7,5KW - 3000D/D - B3 - IE3|ZSPN617/129|3150 Nm|10°|⌀255,5mm|⌀205,5mm|⌀205,5mm|⌀197,7mm|3877|3000',
    'S350, Ø354mm|22KW - 3000D/D - B5 - IE3|7,5KW - 3000D/D - B3 - IE3|ZSPN616/129|2100 Nm|10°|⌀255,5mm|⌀205,5mm|⌀205,5mm|⌀197,7mm|3877|3000',
  ],
  'S430, Ø430mm': [
    'S430, Ø430mm|37KW - 1500D/D - B3 - IE3|11KW - 1500D/D - B3 - IE3|ZSPN619/129|7960 Nm|10°|⌀457mm|⌀255,5mm|⌀217,5mm|⌀200mm|3428|1762',
    'S430, Ø430mm|37KW - 1500D/D - B3 - IE3|15KW - 1500D/D - B3 - IE3|ZS619LX/59|10400 Nm|10°|⌀457mm|⌀255,5mm|⌀217,5mm|⌀200mm|3428|1762',
    'S430, Ø430mm|37KW - 1500D/D - B3 - IE3|7,5KW - 3000D/D - B3 - IE3|ZSPN617/129|3150 Nm|10°|⌀457mm|⌀255,5mm|⌀217,5mm|⌀200mm|3428|1762',
    'S430, Ø430mm|45KW - 1500D/D - B3 - IE3|11KW - 1500D/D - B3 - IE3|ZSPN619/129|7960 Nm|10°|⌀457mm|⌀255,5mm|⌀217,5mm|⌀200mm|3428|1762',
    'S430, Ø430mm|37KW - 1500D/D - B3 - IE3|22KW - 1500D/D - B3 - IE3|ZS619LX/59|10400 Nm|10°|⌀457mm|⌀255,5mm|⌀217,5mm|⌀200mm|3428|1762',
  ],
  'SX435, Ø430mm': [
    'SX435, Ø430mm|37KW - 1500D/D - B3 - IE3|7,5KW - 3000D/D - B3 - IE3|ZS617FX/87|3150 Nm|10°|⌀457mm|⌀255,5mm|⌀217,5mm|⌀200mm|3428|1762',
    'SX435, Ø430mm|45KW - 1500D/D - B3 - IE3|11KW - 1500D/D - B3 - IE3|ZSPV619/84|7960 Nm|10°|⌀457mm|⌀255,5mm|⌀217,5mm|⌀200mm|3428|1762',
  ],
  'S470, Ø470mm': [
    'S470, Ø470mm|45KW - 1500D/D - B3 - IE3|11KW - 1500D/D - B3 - IE3|ZSPN619/129|7960 Nm|15°|⌀457mm|⌀285,5mm|⌀217,5mm|⌀220mm|3116|1969',
    'S470, Ø470mm|55KW - 1500D/D - B3 - IE3|11KW - 1500D/D - B3 - IE3|ZSPN619/129|7960 Nm|15°|⌀457mm|⌀285,5mm|⌀217,5mm|⌀220mm|3116|1969',
    'S470, Ø470mm|55KW - 1500D/D - B3 - IE3|22KW - 1500D/D - B3 - IE3|ZS619LX/59|10400 Nm|10°|⌀457mm|⌀285,5mm|⌀217,5mm|⌀220mm|3116|1969',
    'S470, Ø470mm|45KW - 1500D/D - B3 - IE3|15KW - 1500D/D - B3 - IE3|ZSPN619/129|7960 Nm|10°|⌀457mm|⌀285,5mm|⌀217,5mm|⌀220mm|3116|1969',
    'S470, Ø470mm|45KW - 1500D/D - B3 - IE3|7,5KW - 1500D/D - B3 - IE3|ZSPN618/129|5000 Nm|10°|⌀457mm|⌀285,5mm|⌀217,5mm|⌀220mm|3116|1969',
    'S470, Ø470mm|45KW - 1500D/D - B3 - IE2|11KW - 1500D/D - B3 - IE2|ZSPN621/129|12650 Nm|10°|⌀457mm|⌀285,5mm|⌀217,5mm|⌀220mm|3116|1969',
    'S470, Ø470mm|45KW - 1500D/D - B3 - IE2|7,5KW - 1500D/D - B3 - IE2|ZSPN619/129|7960 Nm|15°|⌀457mm|⌀285,5mm|⌀217,5mm|⌀220mm|3116|1969',
    'S470, Ø470mm|45KW - 1500D/D - B3 - IE2|11KW - 1500D/D - B3 - IE2|ZSPN618/129|5000 Nm|10°|⌀457mm|⌀285,5mm|⌀217,5mm|⌀220mm|3116|1969',
    'S470, Ø470mm|55KW - 1500D/D - B3 - IE3|15KW - 1500D/D - B3 - IE3|ZSPN619/129|7960 Nm|15°|⌀457mm|⌀285,5mm|⌀217,5mm|⌀220mm|3116|1969',
    'S470, Ø470mm|45KW - 1500D/D - B3 - IE3|15KW - 1500D/D - B3 - IE3|ZSPN621/129|12650 Nm|10°|⌀457mm|⌀285,5mm|⌀217,5mm|⌀220mm|3116|1969',
    'S470, Ø470mm|55KW - 1500D/D - B3 - IE3|15KW - 1500D/D - B3 - IE3|ZSPN621/129|12650 Nm|10°|⌀457mm|⌀285,5mm|⌀217,5mm|⌀220mm|3116|1969',
    'S470, Ø470mm|45KW - 1500D/D - B3 - IE3|11KW - 1500D/D - B3 - IE3|ZSPN619/129|7960 Nm|10°|⌀457mm|⌀285,5mm|⌀217,5mm|⌀220mm|3116|1969',
    'S470, Ø470mm|45KW - 1500D/D - B3 - IE3|11KW - 1500D/D - B3 - IE3|ZSPR619LX/150-177|10400 Nm|15°|⌀228mm|⌀285,5mm|⌀88mm|⌀220mm|1555|4866',
  ],
  'SX475, Ø470mm': [
    'SX475, Ø470mm|45KW - 1500D/D - B3 - IE3|15KW - 1500D/D - B3 - IE3|ZSPV619/84|7960 Nm|10°|⌀457mm|⌀285,5mm|⌀217,5mm|⌀220mm|3116|1969',
  ],
  'S530, Ø530mm': [
    'S530, Ø530mm|55KW - 1500D/D - B3 - IE3|11KW - 1500D/D - B3 - IE3|ZSPN619/129|7960 Nm|10°|⌀457mm|⌀285,5mm|⌀285,5mm|⌀220mm|3116|1500',
    'S530, Ø530mm|55KW - 1500D/D - B3 - IE3|15KW - 1500D/D - B3 - IE3|ZSPN621/129|12650 Nm|10°|⌀457mm|⌀285,5mm|⌀285,5mm|⌀220mm|3116|1500',
    'S530, Ø530mm|75KW - 1500D/D - B3 - IE4|15KW - 1500D/D - B3 - IE3|ZSPN621/129|12650 Nm|10°|⌀457mm|⌀285,5mm|⌀285,5mm|⌀220mm|3116|1500',
    'S530, Ø530mm|75KW - 1500D/D - B3 - IE2|11KW - 1500D/D - B3 - IE2|ZSPN619/129|7960 Nm|10°|⌀457mm|⌀285,5mm|⌀285,5mm|⌀220mm|3116|1500',
    'S530, Ø530mm|75KW - 1500D/D - B3 - IE4|37KW - 1500D/D - B3 - IE3|ZS619LX/59|10400 Nm|10°|⌀457mm|⌀285,5mm|⌀285,5mm|⌀220mm|3116|1500',
    'S530, Ø530mm|55KW - 1500D/D - B3 - IE3|15KW - 1500D/D - B3 - IE3|ZSPN619/129|7960 Nm|10°|⌀457mm|⌀285,5mm|⌀285,5mm|⌀220mm|3116|1500',
  ],
  'S570, Ø570mm': [
    'S570, Ø570mm|90KW - 1500D/D - B3 - IE4|22KW - 1500D/D - B3 - IE3|ZSPN621/129|12650 Nm|15°|⌀457mm|⌀255,5mm|⌀255,5mm|⌀250mm|2742|1500',
    'S570, Ø570mm|55KW - 1500D/D - B3 - IE3|11KW - 1500D/D - B3 - IE3|ZSPN622/129|16000 Nm|10°|⌀457mm|⌀285,5mm|⌀285,5mm|⌀250mm|2742|1500',
    'S570, Ø570mm|90KW - 1500D/D - B3 - IE4|22KW - 1500D/D - B3 - IE3|ZSPN622/129|16000 Nm|10°|⌀457mm|⌀255,5mm|⌀255,5mm|⌀250mm|2742|1500',
    'S570, Ø570mm|55KW - 1500D/D - B3 - IE3|11KW - 1500D/D - B3 - IE3|ZSPN619/129|7960 Nm|15°|⌀457mm|⌀255,5mm|⌀255,5mm|⌀250mm|2742|1500',
    'S570, Ø570mm|75KW - 1500D/D - B3 - IE4|15KW - 1500D/D - B3 - IE3|ZSPN621/129|12650 Nm|10°|⌀457mm|⌀285,5mm|⌀285,5mm|⌀250mm|2742|1500',
    'S570, Ø570mm|75KW - 1500D/D - B3 - IE4|15KW - 1500D/D - B3 - IE3|ZSPN619/129|7960 Nm|10°|⌀457mm|⌀285,5mm|⌀285,5mm|⌀250mm|2742|1500',
    'S570, Ø570mm|75KW - 1500D/D - B3 - IE4|22KW - 1500D/D - B3 - IE3|ZSPN622/129|16000 Nm|10°|⌀457mm|⌀285,5mm|⌀285,5mm|⌀250mm|2742|1500',
    'S570, Ø570mm|75KW - 1500D/D - B3 - IE2|11KW - 1500D/D - B3 - IE2|ZSPN619/129|7960 Nm|10°|⌀457mm|⌀285,5mm|⌀285,5mm|⌀250mm|2742|1500',
    'S570, Ø570mm|90KW - 1500D/D - B3 - IE4|15KW - 1500D/D - B3 - IE2|ZSPN621/129|12650 Nm|15°|⌀457mm|⌀255,5mm|⌀255,5mm|⌀250mm|2742|1500',
    'S570, Ø570mm|55KW - 1500D/D - B3 - IE3|15KW - 1500D/D - B3 - IE3|ZSPN621/129|12650 Nm|15°|⌀457mm|⌀285,5mm|⌀285,5mm|⌀250mm|2742|1500',
    'S570, Ø570mm|55KW - 1500D/D - B3 - IE3|11KW - 1500D/D - B3 - IE3|ZSPN619/129|7960 Nm|10°|⌀457mm|⌀285,5mm|⌀285,5mm|⌀250mm|2742|1500',
    'S570, Ø570mm|75KW - 1500D/D - B3 - IE4|37KW - 1000D/D - B3 - IE3|ZS619LX/59|10400 Nm|10°|⌀457mm|⌀285,5mm|⌀285,5mm|⌀250mm|2742|1500',
  ],
  'SX575, Ø570mm': [
    'SX575, Ø570mm|75KW - 1500D/D - B3 - IE3|22KW - 1500D/D - B3 - IE3|ZSPV619LX/150-116|12000 Nm|10°|⌀457mm|⌀285,5mm|⌀285,5mm|⌀250mm|2742|1500',
    'SX575, Ø570mm|75KW - 1500D/D - B3 - IE4|37KW - 1500D/D - B3 - IE2|ZSPV619/84|7960 Nm|10°|⌀457mm|⌀285,5mm|⌀285,5mm|⌀250mm|2742|1500',
  ],
  'SX650, Ø650mm': [
    'SX650, Ø650mm|90KW - 1500D/D - B3 - IE4|22KW - 1500D/D - B3 - IE3|ZSPN622/129|16000 Nm|10°|⌀362mm|YOK|YOK|⌀219mm|2479|X',
    'SX650, Ø650mm|90KW - 1000D/D - B3 - IE4|22KW - 1000D/D - B3 - IE3|ZS619LX/59|10400 Nm|15°|⌀231mm|YOK|YOK|⌀257mm|899|X',
    'SX650, Ø650mm|110KW - 1500D/D - B3 - IE4|22KW - 1500D/D - B3 - IE3|ZSPN623/129|20500 Nm|15°|⌀362mm|YOK|YOK|⌀219mm|2479|X',
    'SX650, Ø650mm|90KW - 1500D/D - B3 - IE4|22KW - 1500D/D - B3 - IE3|ZSPN623/129|20500 Nm|15°|⌀362mm|YOK|YOK|⌀219mm|2479|X',
  ],
  'S670, Ø692mm': [
    'S670, Ø692mm|132KW - 1500D/D - B3 - IE4|37KW - 1500D/D - B3 - IE2|ZSPN625/129|30960 Nm|10°|⌀457mm|⌀255,5mm|⌀358,85mm|⌀311,6mm|2200|1068',
    'S670, Ø692mm|110KW - 1500D/D - B3 - IE4|37KW - 1500D/D - B3 - IE2|ZSPN625/129|30960 Nm|10°|⌀457mm|⌀255,5mm|⌀358,85mm|⌀311,6mm|2200|1068',
    'S670, Ø692mm|90KW - 1500D/D - B3 - IE4|22KW - 1500D/D - B3 - IE3|ZSPN622/129|16000 Nm|10°|⌀457mm|⌀255,5mm|⌀358,85mm|⌀311,6mm|2200|1068',
  ],
  'S840, Ø835mm': [
    'S840, Ø835mm|200KW - 1500D/D - B3 - IE4|45KW - 1500D/D - B3 - IE3|ZSPN625/129|30960 Nm|10°|⌀507mm|YOK|YOK|⌀297mm|2561|X',
  ],
  'S920, Ø920mm': [
    'S920, Ø920mm|200KW - 1500D/D - B3 - IE4 (OZEL)|90KW - 1500D/D - B3 - IE4 (OZEL)|DESCH ZG50 - İ:80/1|50000 Nm|4°-6°|⌀407mm|⌀407mm|⌀407mm|⌀371mm|1646|1500',
  ],
  'PX5, Ø232mm': [
    'PX5, Ø232mm|OMEGA MOTOR 5,5KW 2P 132M B5 IE3|X|ZS 612/17|630 Nm|10°|⌀225mm|⌀235mm|⌀158mm|⌀147mm|4592|4462',
  ],
  'PX10, Ø232mm': [
    'PX10, Ø232mm|OMEGA MOTOR 7,5KW 2P 132S B5 IE3|X|ZS 612/17|630 Nm|10°|⌀225mm|⌀235mm|⌀158mm|⌀147mm|4592|4462',
  ],
  'PX20, Ø354mm': [
    'PX20, Ø354mm|WAT MOTOR 11KW 2P 160M B5 IE3|WAT MOTOR 0,25KW 6P 71M B14 IE2|ZS 616/25|2100 Nm|12°|⌀238,9mm|⌀244,57mm|⌀206,65mm|⌀199,8mm|3587|3672',
  ],
  'PX30, Ø354mm': [
    'PX30, Ø354mm|OMEGA MOTOR 15KW 2P 160M B5 IE3|WAT MOTOR 0,25KW 6P 71M B14 IE2|ZS 616/25|2100 Nm|12°|⌀238,9mm|⌀244,57mm|⌀206,65mm|⌀199,8mm|3587|3672',
  ],
  'PX40, Ø470mm': [
    'PX40, Ø470mm|OMEGA MOTOR 18,5KW 2P 160L B5 IE3|SIEMENS MOTOR 0,55KW 1000D/D B14FLANŞ|ZS 617/25|3150 Nm|12°|⌀243,87mm|⌀258mm|⌀258mm|⌀247,5mm|2956|3000',
  ],
  'PXZ40, Ø354mm': [
    'PXZ40, Ø354mm|OMEGA MOTOR 22KW 4P 180L B5 IE3|OMEGA MOTOR 15KW 2P 160M B5 IE3|ZS 616-59|2100 Nm|12°|⌀359mm|⌀174mm|⌀174mm|⌀154mm|3497|3000',
  ],
  'PXZ60, Ø470mm': [
    'PXZ60, Ø470mm|WAT MOTOR 30KW 4P 200L B5 IE3|OMEGA MOTOR 15KW 4P 160L B5 IE3|ZS618FX-59|5000 Nm|12°|⌀415,5mm|⌀217,5mm|⌀217,5mm|⌀205mm|3040|1500',
  ],
  'PXZ60 20°, Ø470mm': [
    'PXZ60 20°, Ø470mm|WAT MOTOR 30KW 4P 200L B5 IE3|OMEGA MOTOR 15KW 4P 160L B5 IE3|ZS618FX-59|5000 Nm|20°|⌀415,5mm|⌀217,5mm|⌀217,5mm|⌀205mm|3040|1500',
  ],
  'PX70, Ø470mm': [
    'PX70, Ø470mm|WAT MOTOR 22KW 2P 180M B5 IE3|SIEMENS MOTOR 0,55KW 1000D/D B14FLANŞ|ZS 618/25|5000 Nm|12°|⌀236,2mm|⌀252,2mm|⌀264,9mm|⌀247,5mm|2863|2856',
  ],
  'PXZ80, Ø470mm': [
    'PXZ80, Ø470mm|WAT MOTOR 30KW 4P 200L B5 IE3|OMEGA MOTOR 15KW 4P 160L B5 IE3|ZS618FX-59|5000 Nm|12°|⌀415,5mm|⌀217,5mm|⌀217,5mm|⌀205mm|3040|1500',
  ],
  'PXZ80 20°, Ø470mm': [
    'PXZ80 20°, Ø470mm|WAT MOTOR 30KW 4P 200L B5 IE3|OMEGA MOTOR 15KW 4P 160L B5 IE3|ZS618FX-59|5000 Nm|12°|⌀415,5mm|⌀217,5mm|⌀217,5mm|⌀205mm|3040|1500',
  ],
  'PXZ100, Ø470mm': [
    'PXZ100, Ø470mm|OMEGA MOTOR 37KW 4P 225M B5 IE3|OMEGA MOTOR 18,5KW 4P 160L B5 IE3 KOMPAKT|ZS618FX-59|5000 Nm|12°|⌀415,5mm|⌀217,5mm|⌀217,5mm|⌀205mm|3040|1500',
  ],
  'PXZ120, Ø470mm': [
    'PXZ120, Ø470mm|OMEGA MOTOR 37KW 4P 225M B5 IE3|OMEGA MOTOR 18,5KW 4P 160L B5 IE3 KOMPAKT|ZS618FX-59|5000 Nm|12°|⌀415,5mm|⌀217,5mm|⌀260,3mm|⌀205mm|3040|1253',
  ],
  'PX160, Ø570mm': [
    'PX160, Ø570mm|WAT MOTOR 45KW 2P 225M B5 IE3|SIEMENS MOTOR 0,55KW 1000D/D B14FLANŞ|ZS 619/25|7960 Nm|12°|⌀227,06mm|⌀250mm|⌀307,3mm|⌀282,78mm|2409|2441',
  ],
  'PXZ160, Ø570mm': [
    'PXZ160, Ø570mm|OMEGA MOTOR 55KW 2P 250M B5 IE3|OMEGA MOTOR 22KW 6P 200L B5 IE3|ZS619FX-59|7960 Nm|12°|⌀292mm|⌀231mm|⌀231mm|⌀330mm|2655|1000',
  ],
  'PXE160, Ø570mm': [
    'PXE160, Ø570mm|OMEGA MOTOR 55KW 2P 250M B5 IE3|OMEGA MOTOR 22KW 6P 200L B5 IE3|ZS619FX-59|7960 Nm|12°|⌀292mm|⌀231mm|⌀231mm|⌀330mm|2655|1000',
  ],
  'PXE250, Ø570mm': [
    'PXE250, Ø570mm|OMEGA MOTOR 55KW 2P 250M B5 IE3|OMEGA MOTOR 22KW 6P 200L B5 IE3|ZS619FX-59|7960 Nm|12°|⌀292mm|⌀231mm|⌀231mm|⌀330mm|2655|1000',
  ],
  'PXE500, Ø570mm': [
    'PXE500, Ø570mm|OMEGA MOTOR 75KW 2P 280S B35 IE4|OMEGA MOTOR 22KW 6P 200L B5 IE3|ZS 622FX/59|15880 Nm|12°|⌀292mm|⌀231mm|⌀231mm|⌀330mm|2655|1000',
  ],
};

String _sig(DriveConfig c) => [
      c.selection,
      c.drumMotor,
      c.scrollMotor,
      c.gearboxType,
      c.gearboxTorque,
      c.coneAngle,
      c.drumMotorPulley,
      c.scrollMotorPulley,
      c.gearboxPulley,
      c.drumPulley,
      c.drumRpm50Hz?.toString() ?? 'X',
      c.gearboxInputRpm50Hz?.toString() ?? 'X',
    ].join('|');

void main() {
  test('seçim listesi Excel A sütunuyla aynı (benzersiz, Excel sırasıyla)', () {
    expect(driveConfigSelections, expectedSelections);
  });

  test('kayıt sayısı: 87 satır, 6 birebir tekrar çıkarılınca 81', () {
    expect(expectedRawRows, 87);
    expect(expectedTotalConfigs, 81);
    expect(driveConfigs.length, expectedTotalConfigs);
  });

  test('her seçimin yapılandırmaları Excel ile birebir aynı ve aynı sırada', () {
    for (final selection in expectedSelections) {
      expect(
        driveConfigsFor(selection).map(_sig).toList(),
        expectedConfigs[selection],
        reason: selection,
      );
    }
  });

  test('elle doğrulanan örnekler', () {
    final s200 = driveConfigsFor('S200, Ø200mm');
    expect(s200.map((c) => c.gearboxType).toList(), ['ZS612/87', 'ZSPN612/105']);
    expect(s200.first.drumRpm50Hz, 5482);
    expect(s200.first.gearboxInputRpm50Hz, 4500);

    final s920 = driveConfigsFor('S920, Ø920mm').single;
    expect(s920.gearboxType, 'DESCH ZG50 - İ:80/1');
    expect(s920.coneAngle, '4°-6°');
    expect(s920.gearboxTorque, '50000 Nm');

    // "X" -> null, "YOK" olduğu gibi.
    final s840 = driveConfigsFor('S840, Ø835mm').single;
    expect(s840.gearboxInputRpm50Hz, isNull);
    expect(s840.scrollMotorPulley, 'YOK');
    expect(driveConfigsFor('PX5, Ø232mm').single.scrollMotor, 'X');
  });

  test('fazladan boşluklar temizlenmiştir', () {
    for (final c in driveConfigs) {
      for (final v in [c.selection, c.drumMotor, c.scrollMotor, c.gearboxType, c.drumPulley]) {
        expect(v, v.trim(), reason: v);
        expect(v.contains('  '), isFalse, reason: v);
      }
    }
  });
}
