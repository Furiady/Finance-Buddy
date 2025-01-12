import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListViewModel{
  DateTime currentDate = DateTime.now();
  List<Map<String, dynamic>> recordsForDate(
      List<Map<String, dynamic>> records, String date) {
    return records
        .where((record) =>
    DateFormat.yMMMMd().format(record['waktu'] as DateTime) == date &&
        record['tipe'] == 'Expense')
        .toList();
  }
  Map<String, double> groupRecordsByDate(
      List<Map<String, dynamic>> records) {
    final Map<String, double> dailyTotals = {};
    for (var record in records) {
      final date = DateFormat.yMMMMd().format(record['waktu']);
      final amount = record['jumlah'];
      if (record['tipe'] == 'Expense') {
        dailyTotals[date] = (dailyTotals[date] ?? 0) + amount;
      }
    }
    return dailyTotals;
  }
  List<Map<String, dynamic>> filterRecordsByMonth(List<Map<String, dynamic>> records) {
    return records.where((record) {
      final recordDate = record['waktu'] as DateTime;
      return recordDate.year == currentDate.year &&
          recordDate.month == currentDate.month;
    }).toList();
  }


  String formatCurrency(double amount) {
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