import 'package:flutter/material.dart';
import 'package:front_end/model/record-response-model/model.dart';
import 'package:front_end/pages/bills/bills-list/view-model.dart';
import 'package:front_end/pages/home/home-detail/view.dart';

class BillsRecordListComponent extends StatefulWidget {
  final String date;
  final List<RecordModel> records;

  const BillsRecordListComponent({
    super.key,
    required this.date,
    required this.records,
  });

  @override
  State<BillsRecordListComponent> createState() =>
      _BillsRecordListComponentState();
}

class _BillsRecordListComponentState extends State<BillsRecordListComponent> {
  late final BillsListViewModel viewModel;
  late List<RecordModel> filteredRecords;

  @override
  void initState() {
    super.initState();
    viewModel = BillsListViewModel();
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeDetail(
                          record: filteredRecords[index],
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
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
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
