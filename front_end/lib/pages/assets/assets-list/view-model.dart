import 'package:flutter/material.dart';
import 'package:front_end/model/record-response-model/model.dart';
import 'package:intl/intl.dart';

class AssetsListViewModel {

  List<RecordModel> filterRecordsByMonth(List<RecordModel> records, DateTime currentDate) {
    return records.where((record) {
      final recordDate = record.date;
      return recordDate.year == currentDate.year &&
          recordDate.month == currentDate.month;
    }).toList();
  }

  Map<String, int> groupRecordsByDate(List<RecordModel> records,DateTime currentDate) {
    final Map<String, int> dailyTotals = {};
    for (var record in records) {
      final date = DateFormat.yMMMMd().format(record.date);
      dailyTotals[date] = (dailyTotals[date] ?? 0) + record.value;
    }
    return dailyTotals;
  }

  List<RecordModel> recordsForDate(List<RecordModel> records, String date) {
    return records
        .where((record) => DateFormat.yMMMMd().format(record.date) == date)
        .toList();
  }

  String formatCurrency(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
        .format(amount);
  }

  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food & beverages':
        return const Color.fromARGB(255, 255, 148, 148);
      case 'transportation':
        return const Color.fromARGB(255, 162, 255, 165);
      case 'medicines':
        return const Color.fromARGB(255, 236, 255, 176);
      case 'plays':
        return const Color.fromARGB(255, 197, 181, 255);
      default:
        return Colors.grey;
    }
  }

  /// Returns the path to the icon for each category
  String getIconPathByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food & beverages':
        return 'assets/fast-food.png';
      case 'transportation':
        return 'assets/bus.png';
      case 'medicines':
        return 'assets/medicines.png';
      case 'plays':
        return 'assets/joystick.png';
      default:
        return 'assets/wallet.png';
    }
  }
}
