import 'olive_decanter_params.dart';

/// Filtre sütunlarının Excel başlıkları (her iki sayfada da aynıdır).
const String oliveModelHeader = 'Dekantör Modeli';
const String olivePhaseHeader = 'Faz';

/// Sayfadaki benzersiz değerler, ilk görülme sırasıyla (hücre metni olduğu gibi).
List<String> _distinct(OliveParamSheet sheet, String header) {
  final col = sheet.column(header);
  final seen = <String>{};
  final result = <String>[];
  for (final row in sheet.rows) {
    final v = row[col];
    if (v != null && seen.add(v)) result.add(v);
  }
  return result;
}

/// Sayfadaki dekantör modelleri (sayfa sırasıyla).
List<String> oliveModels(OliveParamSheet sheet) => _distinct(sheet, oliveModelHeader);

/// Sayfadaki faz değerleri (hücre metni olduğu gibi: "3 FAZ" ya da yalnızca "3").
List<String> olivePhases(OliveParamSheet sheet) => _distinct(sheet, olivePhaseHeader);

/// Faz seçeneğinin açılır listedeki etiketi. Yalnızca sayı olan hücreler ("3") "3 FAZ" olarak
/// gösterilir; tablodaki hücre değeri değişmez.
String olivePhaseLabel(String raw) => RegExp(r'^\d+$').hasMatch(raw) ? '$raw FAZ' : raw;

/// Model ve/veya faza göre süzülmüş satırlar (null = o ölçüt uygulanmaz). Sıra korunur.
List<List<String?>> filterOliveRows(OliveParamSheet sheet, {String? model, String? phase}) {
  final m = sheet.column(oliveModelHeader);
  final p = sheet.column(olivePhaseHeader);
  return [
    for (final row in sheet.rows)
      if ((model == null || row[m] == model) && (phase == null || row[p] == phase)) row,
  ];
}
