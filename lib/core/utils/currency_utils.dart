/// Currency formatting utilities
class CurrencyUtils {
  CurrencyUtils._();

  static String format(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }
}
