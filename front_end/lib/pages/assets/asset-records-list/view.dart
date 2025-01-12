import 'package:flutter/material.dart';
import 'package:front_end/pages/assets/asset-records-list/component.dart';
import 'package:front_end/pages/assets/asset-records-list/view-model.dart';

class AssetRecordsList extends StatefulWidget {
  final String date;
  final List<Map<String, dynamic>> transactions;

  const AssetRecordsList({
    super.key,
    required this.date,
    required this.transactions,
  });

  @override
  State<AssetRecordsList> createState() => _AssetRecordsListState();
}

class _AssetRecordsListState extends State<AssetRecordsList> {
  final AssetRecordListViewModel viewModel = AssetRecordListViewModel();
  late List<Map<String, dynamic>> filteredTransactions;
  late Map<String, double> dailyTotals;

  @override
  void initState() {
    super.initState();
    filteredTransactions = viewModel.filterTransactionsByMonth(widget.transactions);
    dailyTotals = viewModel.groupTransactionsByDate(filteredTransactions);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Daily Recap',
              style: TextStyle(
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        viewModel.formatCurrency(totalAmount),
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TransactionList(
                          date: widget.date, transactions: widget.transactions),
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
}
