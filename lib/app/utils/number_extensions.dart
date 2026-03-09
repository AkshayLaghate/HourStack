import 'package:intl/intl.dart';

extension NumberFormatting on double {
  /// Formats the double to a string with a fixed number of decimal places.
  /// Defaults to 2 decimal places.
  String toFormattedString([int decimals = 2]) {
    return toStringAsFixed(decimals);
  }

  /// Formats the double as a currency string with thousands separators.
  /// Defaults to 2 decimal places and '$' symbol.
  String toCurrency({String symbol = '\$', int decimals = 2}) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimals,
    );
    return formatter.format(this);
  }

  /// Formats the double with thousands separators but no currency symbol.
  String toThousandSeparator([int decimals = 2]) {
    final formatter = NumberFormat.decimalPattern();
    formatter.minimumFractionDigits = decimals;
    formatter.maximumFractionDigits = decimals;
    return formatter.format(this);
  }
}
