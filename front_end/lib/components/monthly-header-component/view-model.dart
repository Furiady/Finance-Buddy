import 'package:intl/intl.dart';

class MonthlyHeaderComponentViewModel {
  String formattedDate(DateTime currentDate) {
    return DateFormat('MMMM yyyy').format(currentDate);
  }

  DateTime incrementMonth(DateTime currentDate) {
    return DateTime(currentDate.year, currentDate.month + 1);
  }

  DateTime decrementMonth(DateTime currentDate) {
    return DateTime(currentDate.year, currentDate.month - 1);
  }
}
