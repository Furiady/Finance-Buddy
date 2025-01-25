import 'package:flutter/material.dart';
import 'package:front_end/model/home-model/model.dart';
import 'package:front_end/model/record-response-model/model.dart';
import 'package:front_end/pages/home/home-detail/view.dart';
import 'package:front_end/utils/format-currency/format-currency.dart';
import 'package:intl/intl.dart';

class IncomeExpenseCardComponent extends StatefulWidget {
  final IncomeExpenseModel value;

  const IncomeExpenseCardComponent({super.key, required this.value});

  @override
  State<IncomeExpenseCardComponent> createState() =>
      _IncomeExpenseCardComponentState();
}

class _IncomeExpenseCardComponentState
    extends State<IncomeExpenseCardComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.arrow_downward, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    "Income",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                formatCurrency(widget.value.income),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Row(
                children: [
                  Icon(Icons.arrow_upward, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    "Expense",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
               formatCurrency(widget.value.expense),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class RecentListComponent extends StatefulWidget {
  final List<RecordModel> records;
  const RecentListComponent({super.key, required this.records});
  @override
  State<RecentListComponent> createState() => _RecentListComponentState();
}

class _RecentListComponentState extends State<RecentListComponent> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.records.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeDetail(record: widget.records[index]),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundColor: Colors.red.withOpacity(0.1),
              child: Icon(Icons.fastfood,
                  color: widget.records[index].type == "Expense"
                      ? Colors.red
                      : Colors.green),
            ),
            title: Text(widget.records[index].title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.records[index].category),
                Text(DateFormat('dd MMMM yyyy')
                    .format(widget.records[index].date)),
              ],
            ),
            trailing: Text(
              formatCurrency(widget.records[index].value),
              style: TextStyle(
                color: widget.records[index].type == "Expense"
                    ? Colors.red
                    : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        );
      },
    );
  }
}