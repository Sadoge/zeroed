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

/// Formats a currency amount, dropping trailing ".00" for whole numbers.
String formatCurrency(double amount, [String currencyCode = 'USD']) {
  final formatted = currencyFormat(currencyCode).format(amount);
  if (currencyCode == 'JPY') return formatted;
  // Remove .00 suffix for whole numbers
  return formatted.replaceAll(RegExp(r'\.00$'), '');
}
