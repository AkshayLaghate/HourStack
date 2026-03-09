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
    // Map common currency codes to symbols
    String actualSymbol = symbol;
    if (symbol == 'INR') {
      actualSymbol = '₹';
    } else if (symbol == 'USD') {
      actualSymbol = '\$';
    } else if (symbol == 'EUR') {
      actualSymbol = '€';
    } else if (symbol == 'GBP') {
      actualSymbol = '£';
    }

    final formatter = NumberFormat.currency(
      symbol: actualSymbol,
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

  /// Formats the double (representing hours) as a duration string.
  /// Example: 3.38 -> "03 hr 23 min", 0.17 -> "10 min"
  String toDurationString() {
    final totalMinutes = (this * 60).round();
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours < 1) {
      return '${minutes.toString().padLeft(2, '0')} min';
    } else {
      final hoursStr = hours.toString().padLeft(2, '0');
      final minutesStr = minutes.toString().padLeft(2, '0');
      return '$hoursStr hr $minutesStr min';
    }
  }
}
