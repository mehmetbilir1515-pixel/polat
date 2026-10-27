/// Sayıyı Türkçe biçimde yazar: binlik ayırıcı nokta, ondalık ayırıcı virgül.
String formatNumber(double value, {int decimals = 2}) {
  if (!value.isFinite) {
    return '—';
  }
  final negative = value < 0;
  final fixed = value.abs().toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final intPart = parts[0];
  final buffer = StringBuffer();
  for (var i = 0; i < intPart.length; i++) {
    if (i > 0 && (intPart.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(intPart[i]);
  }
  final decimalPart = parts.length > 1 ? ',${parts[1]}' : '';
  final isZero = double.parse(fixed) == 0;
  return '${negative && !isZero ? '-' : ''}${buffer.toString()}$decimalPart';
}

/// Kullanıcı girdisini sayıya çevirir. "12,5", "12.5" ve "1.234,5" kabul edilir.
/// Geçersizse null döner.
double? parseNumber(String input) {
  var text = input.trim().replaceAll(' ', '');
  if (text.isEmpty) {
    return null;
  }
  if (text.contains(',') && text.contains('.')) {
    text = text.replaceAll('.', '').replaceAll(',', '.');
  } else {
    text = text.replaceAll(',', '.');
  }
  return double.tryParse(text);
}

/// Sayıyı gereksiz sıfırlar olmadan Türkçe biçimde yazar (ör. 13,59 · 30 · 20,075).
/// Binlik ayırıcı kullanmaz; yağ miktarı ve ölçü değerleri için uygundur.
String formatCompact(double value, {int maxDecimals = 3}) {
  if (!value.isFinite) {
    return '—';
  }
  var text = value.toStringAsFixed(maxDecimals);
  if (text.contains('.')) {
    text = text.replaceFirst(RegExp(r'0+$'), '');
    text = text.replaceFirst(RegExp(r'\.$'), '');
  }
  return text.replaceAll('.', ',');
}
