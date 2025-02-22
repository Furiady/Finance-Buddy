import 'package:flutter/material.dart';
import 'package:front_end/model/record-response-model/model.dart';
import 'package:front_end/pages/assets/assets-list/component.dart';
import 'package:front_end/pages/assets/assets-list/view-model.dart';
import 'package:intl/intl.dart';

class AssetsListComponent extends StatefulWidget {
  final List<RecordModel> records;
  final DateTime date;

  const AssetsListComponent(
      {super.key, required this.records, required this.date});

  @override
  _AssetsListComponentState createState() => _AssetsListComponentState();
}

class _AssetsListComponentState extends State<AssetsListComponent> {
  late List<RecordModel> filteredRecords;
  late Map<String, int> dailyTotals;

  @override
  void initState() {
    super.initState();
    _updateData(widget.records);
  }

  @override
  void didUpdateWidget(covariant AssetsListComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.records != widget.records) {
      _updateData(widget.records);
    }
  }

  void _updateData(List<RecordModel> records) {
    final AssetsListViewModel viewModel = AssetsListViewModel();
    filteredRecords = viewModel.filterRecordsByMonth(records, widget.date);
    dailyTotals = viewModel.groupRecordsByDate(filteredRecords, widget.date);
  }

  @override
  Widget build(BuildContext context) {
    final sortedDailyTotals = dailyTotals.entries.toList()
      ..sort((a, b) => DateFormat.yMMMMd()
          .parse(a.key)
          .compareTo(DateFormat.yMMMMd().parse(b.key)));

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16),
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
        if (sortedDailyTotals.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No records available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedDailyTotals.length,
              itemBuilder: (context, index) {
                final date = sortedDailyTotals[index].key;
                final totalAmount = sortedDailyTotals[index].value;
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  child: ExpansionTile(
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    collapsedBackgroundColor: Colors.white,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          AssetsListViewModel().formatCurrency(totalAmount),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AssetsRecordListComponent(
                          date: date,
                          records: widget.records,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
