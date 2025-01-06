import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class Assets extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;

  const Assets({super.key, required this.transactions});

  @override
  _AssetsState createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  DateTime _currentDate = DateTime.now();

  String formatRupiah(double amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
        .format(amount);
  }

  String get formattedDate => DateFormat('MMMM yyyy').format(_currentDate);

  void _incrementMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
    });
  }

  void _decrementMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
    });
  }

  List<Map<String, dynamic>> _filterTransactionsByMonth() {
    return widget.transactions.where((transaction) {
      final transactionDate = transaction['waktu'] as DateTime;
      return transactionDate.year == _currentDate.year &&
          transactionDate.month == _currentDate.month;
    }).toList();
  }

  Map<String, double> _groupTransactionsByDate(List<Map<String, dynamic>> transactions) {
    final Map<String, double> dailyTotals = {};
    for (var transaction in transactions) {
      final date = DateFormat.yMMMMd().format(transaction['waktu']);
      final amount = transaction['jumlah'];
      if (transaction['tipe'] == 'Expense') {
        dailyTotals[date] = (dailyTotals[date] ?? 0) + amount;
      }
    }
    return dailyTotals;
  }

  @override
  Widget build(BuildContext context) {
    // Filter transactions for the current month
    final filteredTransactions = _filterTransactionsByMonth();

    double totalIncome = filteredTransactions
        .where((transaction) => transaction['tipe'] == 'Income')
        .fold(0.0, (sum, item) => sum + (item['jumlah'] as double));

    double totalExpense = filteredTransactions
        .where((transaction) => transaction['tipe'] == 'Expense')
        .fold(0.0, (sum, item) => sum + (item['jumlah'] as double));

    Map<String, double> categoryBreakdown = {};
    for (var transaction in filteredTransactions) {
      if (transaction['tipe'] == 'Expense') {
        categoryBreakdown[transaction['kategori']] =
            (categoryBreakdown[transaction['kategori']] ?? 0) + transaction['jumlah'];
      }
    }

    final dailyTotals = _groupTransactionsByDate(filteredTransactions);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(), // Header utama di atas
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 45),
                      _buildSummaryBox(totalExpense, categoryBreakdown),
                      const SizedBox(height: 20),
                      _buildDailyRecap(dailyTotals),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 75, // Sesuaikan posisi sehingga menindih bagian header
            left: 0,
            right: 0,
            child: _buildMonthNavigator(),
          ),
        ],
      ),
    );
  }

  // Build Header
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          height: 110,
          color: Colors.blue,
          padding: const EdgeInsets.only(top: 20), // Menaikkan posisi sedikit
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0), // Menaikkan teks
              child: Text(
                'Transaction Reports',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMonthNavigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40, // Perbesar lebar kotak
          height: 50, // Perbesar tinggi kotak
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
            onPressed: _decrementMonth,
          ),
        ),
        const SizedBox(width: 8), // Memberi jarak antara panah dan bulan
        Container(
          width: 250,
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Perbesar padding
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              formattedDate,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8), // Memberi jarak antara bulan dan panah
        Container(
          width: 40, // Perbesar lebar kotak
          height: 50, // Perbesar tinggi kotak
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_forward, color: Color.fromARGB(255, 0, 0, 0)),
            onPressed: _incrementMonth,
          ),
        ),
      ],
    );
  }

  // Build Summary Box
  Widget _buildSummaryBox(double totalExpense, Map<String, double> categoryBreakdown) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'This Month Total Spend',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatRupiah(totalExpense),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          // Chart section
          SizedBox(
            height: 200,
            child: totalExpense > 0
                ? PieChart(
              PieChartData(
                sections: categoryBreakdown.entries.map((entry) {
                  final percentage = (entry.value / totalExpense) * 100;
                  return PieChartSectionData(
                    value: entry.value,
                    title: '${percentage.toStringAsFixed(1)}%',
                    color: _getCategoryColor(entry.key),
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            )
                : const Center(
              child: Text(
                'No expenses to display.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Category breakdown section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categoryBreakdown.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    // Container untuk latar belakang warna
                    Container(
                      width: 40, // Ukuran ikon
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(entry.key), // Warna latar belakang
                        shape: BoxShape.circle, // Bentuk lingkaran
                      ),
                      child: Center(
                        child: Image.asset(
                          _getIconPathByCategory(entry.key),
                          width: 24, // Ukuran ikon di dalam lingkaran
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${entry.key}: ${formatRupiah(entry.value)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyRecap(Map<String, double> dailyTotals) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Daily Recap',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dailyTotals.length,
          itemBuilder: (context, index) {
            final date = dailyTotals.keys.elementAt(index);
            final totalAmount = dailyTotals[date]!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatRupiah(totalAmount),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildTransactionList(date), // Menampilkan detail transaksi ketika expanded
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTransactionList(String date) {
    final transactionsForDate =
    widget.transactions.where((transaction) => DateFormat.yMMMMd().format(transaction['waktu']) == date && transaction['tipe'] == 'Expense');

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactionsForDate.length,
      itemBuilder: (context, index) {
        final transaction = transactionsForDate.elementAt(index);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 40, // Ukuran ikon
                height: 40,
                decoration: BoxDecoration(
                  color: _getCategoryColor(transaction['kategori']),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Image.asset(  // Menggunakan asset gambar untuk ikon
                    _getIconPathByCategory(transaction['kategori']),
                    width: 24,  // Sesuaikan ukuran ikon
                    height: 24,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  transaction['kategori'],
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                formatRupiah(transaction['jumlah']),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getIconPathByCategory(String category) {
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


  // Color by category
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food & beverages':
        return Color.fromARGB(255, 255, 148, 148);
      case 'transportation':
        return Color.fromARGB(255, 162, 255, 165);
      case 'medicines':
        return Color.fromARGB(255, 236, 255, 176);
      case 'plays':
        return Color.fromARGB(255, 197, 181, 255);
      default:
        return Colors.grey;
    }
  }

  Widget _buildTransactionCard(
      {required String date,
        required String category,
        required String note,
        required String amount,
        required Color color,
        required IconData icon}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(category),
        subtitle: Text(note),
        trailing: Text(
          amount,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        isThreeLine: true,
      ),
    );
  }
}
