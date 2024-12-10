import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'views/add_transaction.dart';
import 'views/reports_page.dart';
import 'views/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Record-Keeping App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _income = 0; // Default value
  double _expense = 0; // Default value
  int _currentIndex = 0; // Track selected tab index

  List<Map<String, dynamic>> _transactions = []; // Awalnya kosong

  // Format Rupiah
  String formatRupiah(double amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
        .format(amount);
  }

  // Tambah Transaksi
  void _addTransaction(Map<String, dynamic> transaction) {
    setState(() {
      if (transaction['tipe'] == 'Income') {
        _income += transaction['jumlah'];
      } else {
        _expense += transaction['jumlah'];
      }
      _transactions.add(transaction);
    });
  }

  // Navigasi ke Halaman Tambah Transaksi
  void _navigateToAddTransaction() async {
    final List<String> kategoriList = [
      'Food & Beverages',
      'Transportation',
      'Wallet',
      'Medicines',
      'Plays'
    ];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionPage(kategoriList: kategoriList),
      ),
    );
    if (result != null) {
      _addTransaction(result);
    }
  }

  // Kelompokkan transaksi berdasarkan tanggal
  Map<String, List<Map<String, dynamic>>> _groupTransactionsByDate() {
    Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
    for (var transaction in _transactions) {
      String formattedDate = DateFormat('dd MMMM yyyy').format(transaction['waktu']);
      if (!groupedTransactions.containsKey(formattedDate)) {
        groupedTransactions[formattedDate] = [];
      }
      groupedTransactions[formattedDate]?.add(transaction);
    }
    
    // Urutkan tanggal berdasarkan yang terbaru
    var sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => DateFormat('dd MMMM yyyy').parse(b).compareTo(DateFormat('dd MMMM yyyy').parse(a)));
    
    // Kembalikan Map dengan tanggal yang sudah diurutkan
    Map<String, List<Map<String, dynamic>>> sortedGroupedTransactions = {};
    for (var date in sortedDates) {
      sortedGroupedTransactions[date] = groupedTransactions[date]!;
    }
    
    return sortedGroupedTransactions;
  }

  @override
  Widget build(BuildContext context) {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

    // Pages for each tab
    final List<Widget> pages = [
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                currentMonth,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                            border: Border.all(
                              color: Colors.green,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Income',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              formatRupiah(_income),
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                            border: Border.all(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Expense',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              formatRupiah(_expense),
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              _transactions.isEmpty
                  ? const Text(
                      'No transactions yet.',
                      style: TextStyle(color: Colors.grey),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _groupTransactionsByDate().entries.map((entry) {
                        String date = entry.key;
                        List<Map<String, dynamic>> transactions = entry.value;

                        return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: transactions.length,
                                itemBuilder: (context, index) {
                                  final transaction = transactions[index];
                                  String category = transaction['kategori'] ?? '';
                                  String assetIconPath;
                                  Color backgroundColor;

                                  // Assign asset icon and background color based on category
                                  switch (category.toLowerCase()) {
                                    case 'food & beverages':
                                      assetIconPath = 'assets/fast-food.png';
                                      backgroundColor =
                                          const Color.fromARGB(255, 255, 148, 148);
                                      break;
                                    case 'transportation':
                                      assetIconPath = 'assets/bus.png';
                                      backgroundColor =
                                          const Color.fromARGB(255, 162, 255, 165);
                                      break;
                                    case 'wallet':
                                      assetIconPath = 'assets/wallet.png';
                                      backgroundColor =
                                          const Color.fromARGB(255, 233, 245, 255);
                                      break;
                                    case 'medicines':
                                      assetIconPath = 'assets/medicines.png';
                                      backgroundColor =
                                          const Color.fromARGB(255, 236, 255, 176);
                                      break;
                                    case 'plays':
                                      assetIconPath = 'assets/joystick.png';
                                      backgroundColor =
                                          const Color.fromARGB(255, 197, 181, 255);
                                      break;
                                    default:
                                      assetIconPath = 'assets/default_icon.png';
                                      backgroundColor = Colors.grey;
                                      break;
                                  }

                                  String amountText = transaction['tipe'] == 'Expense'
                                      ? '-${formatRupiah(transaction['jumlah'])}'
                                      : '+${formatRupiah(transaction['jumlah'])}';

                                  TextStyle amountStyle = TextStyle(
                                    color: transaction['tipe'] == 'Expense'
                                        ? Colors.red
                                        : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  );

                                  // Format the date
                                  String formattedDate = (transaction['waktu'] != null)
                                      ? DateFormat('dd MMMM yyyy').format(transaction['waktu'])
                                      : 'Unknown Date';

                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: backgroundColor,
                                        child: Image.asset(
                                          assetIconPath,
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      title: Text(transaction['kategori']),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(transaction['note']),
                                          Text(
                                            formattedDate, // Menampilkan tanggal
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Text(
                                        amountText,
                                        style: amountStyle,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
      ReportsPage(transactions: _transactions),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      floatingActionButton: _currentIndex == 0 // Hanya tampilkan jika di halaman Home
          ? FloatingActionButton(
              onPressed: _navigateToAddTransaction,
              child: const Icon(Icons.add),
            )
          : null, // Tidak ada FloatingActionButton di halaman lain
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
