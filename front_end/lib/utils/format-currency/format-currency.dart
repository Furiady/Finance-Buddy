import 'package:intl/intl.dart';
String formatCurrency(int amount) {
  return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
      .format(amount);
}