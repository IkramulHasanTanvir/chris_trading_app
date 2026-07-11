class PnlFormatHelper {
  static String format(num? value, {String? unit, bool showSign = true}) {
    if (value == null) return '--';
    final isPercent = (unit ?? 'usd').toLowerCase() == 'percent';
    final sign = showSign && value > 0 ? '+' : '';
    if (isPercent) return '$sign$value%';
    return '$sign\$$value';
  }
}
