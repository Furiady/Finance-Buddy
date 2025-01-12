import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PieChartComponentViewModel{
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