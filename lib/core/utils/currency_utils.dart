import 'package:intl/intl.dart';

const currencySymbols = <String, String>{
  'USD': '\$',
  'EUR': '€',
  'GBP': '£',
  'CAD': 'C\$',
  'AUD': 'A\$',
  'CHF': 'Fr',
  'JPY': '¥',
};

/// Returns a [NumberFormat] for the given currency code.
NumberFormat currencyFormat([String currencyCode = 'USD']) {
  final symbol = currencySymbols[currencyCode] ?? currencyCode;
  final decimalDigits = currencyCode == 'JPY' ? 0 : 2;
  return NumberFormat.currency(symbol: symbol, decimalDigits: decimalDigits);
}
