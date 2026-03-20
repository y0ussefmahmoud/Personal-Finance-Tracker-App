import 'package:intl/intl.dart';

String formatCurrency(double amount, {String symbol = 'ج.م'}) {
  final formatter = NumberFormat.currency(locale: 'ar_EG', symbol: symbol);
  return formatter.format(amount);
}
