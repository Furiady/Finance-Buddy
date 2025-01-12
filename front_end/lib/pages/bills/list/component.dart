import 'package:flutter/material.dart';
import 'package:front_end/pages/assets/asset-records-list/view-model.dart';
import 'package:front_end/pages/bills/list/view-model.dart';

class RecordList extends StatefulWidget {
  final String date;
  final List<Map<String, dynamic>> records;

  const RecordList({
    super.key,
    required this.date,
    required this.records,
  });

  @override
  State<RecordList> createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  late final ListViewModel viewModel;
  late List<Map<String, dynamic>> records;

  @override
  void initState() {
    super.initState();
    viewModel = ListViewModel();
    records = viewModel.recordsForDate(widget.records, widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: viewModel.getCategoryColor(record['kategori']),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Image.asset(
                    viewModel.getIconPathByCategory(record['kategori']),
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  record['kategori'],
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                viewModel.formatCurrency(record['jumlah']),
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
