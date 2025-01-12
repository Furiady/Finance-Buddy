import 'package:intl/intl.dart';

class MonthlyHeaderComponentViewModel{
  DateTime currentDate = DateTime.now();
  String get formattedDate => DateFormat('MMMM yyyy').format(currentDate);
  void incrementMonth() {
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
  }
  void decrementMonth() {
      currentDate = DateTime(currentDate.year, currentDate.month - 1);
  }
}