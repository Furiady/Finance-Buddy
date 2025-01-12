class AssetViewModel {
  DateTime currentDate = DateTime.now();

  List<Map<String, dynamic>> filterTransactionsByMonth(
      List<Map<String, dynamic>> transactions) {
    return transactions.where((transaction) {
      final transactionDate = transaction['waktu'] as DateTime;
      return transactionDate.year == currentDate.year &&
          transactionDate.month == currentDate.month;
    }).toList();
  }

  double totalExpense(List<Map<String, dynamic>> transactions) {
    return filterTransactionsByMonth(transactions)
        .where((transaction) => transaction['tipe'] == 'Expense')
        .fold(0.0, (sum, item) => sum + (item['jumlah'] as double));
  }

  Map<String, double> getCategoryBreakdown(List<Map<String, dynamic>> transactions) {
    final filteredTransactions = filterTransactionsByMonth(transactions);
    Map<String, double> categoryBreakdown = {};

    for (var transaction in filteredTransactions) {
      if (transaction['tipe'] == 'Expense') {
        final category = transaction['kategori'] as String;
        final amount = transaction['jumlah'] as double;

        categoryBreakdown[category] =
            (categoryBreakdown[category] ?? 0) + amount;
      }
    }

    return categoryBreakdown;
  }
}
