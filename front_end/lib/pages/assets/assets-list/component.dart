import 'package:flutter/material.dart';
import 'package:front_end/model/record-response-model/model.dart';
import 'package:front_end/pages/assets/assets-list/view-model.dart';

class AssetsRecordListComponent extends StatefulWidget {
  final String date;
  final List<RecordModel> records;

  const AssetsRecordListComponent({
    super.key,
    required this.date,
    required this.records,
  });

  @override
  State<AssetsRecordListComponent> createState() => _AssetsRecordListComponentState();
}

class _AssetsRecordListComponentState extends State<AssetsRecordListComponent> {
  late final AssetsListViewModel viewModel;
  late List<RecordModel> filteredRecords;

  @override
  void initState() {
    super.initState();
    viewModel = AssetsListViewModel();
    filteredRecords = viewModel.recordsForDate(widget.records, widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return filteredRecords.isEmpty
        ? const Center(
      child: Text(
        "No records available for this date.",
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    )
        : ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        final record = filteredRecords[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              // Category Icon with Background Color
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: viewModel.getCategoryColor(record.category),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Image.asset(
                    viewModel.getIconPathByCategory(record.category),
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Record Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Record Amount
              Text(
                viewModel.formatCurrency(record.value),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
