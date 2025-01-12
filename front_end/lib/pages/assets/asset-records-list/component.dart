import 'package:flutter/material.dart';
import 'package:front_end/pages/assets/asset-records-list/view-model.dart';

class TransactionList extends StatefulWidget {
  final String date;
  final List<Map<String, dynamic>> transactions;

  const TransactionList({
    super.key,
    required this.date,
    required this.transactions,
  });

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  late final AssetRecordListViewModel viewModel;
  late List<Map<String, dynamic>> transactions;

  @override
  void initState() {
    super.initState();
    viewModel = AssetRecordListViewModel();
    transactions = viewModel.transactionsForDate(widget.transactions, widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: viewModel.getCategoryColor(transaction['kategori']),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Image.asset(
                    viewModel.getIconPathByCategory(transaction['kategori']),
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  transaction['kategori'],
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                viewModel.formatCurrency(transaction['jumlah']),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
