import 'package:flutter/material.dart';
import 'package:front_end/model/home-model/model.dart';
import 'package:front_end/model/quest-model/model.dart';
import 'package:front_end/model/record-response-model/model.dart';
import 'package:front_end/pages/home/home-detail/view.dart';
import 'package:front_end/pages/home/view-model.dart';
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
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      HomeDetail(record: widget.records[index]),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundColor: widget.records[index].type == "Expense"
                  ? Colors.red.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
              child: Icon(Icons.attach_money_rounded,
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

class RowQuest extends StatefulWidget {
  final QuestModel questData;
  final VoidCallback onClaimSuccess; // Callback function

  const RowQuest(
      {super.key, required this.questData, required this.onClaimSuccess});

  @override
  State<RowQuest> createState() => _RowQuestState();
}

class _RowQuestState extends State<RowQuest> {
  final HomeViewModel viewModel = HomeViewModel();

  Future<void> claimQuest() async {
    try {
      setState(() {
        viewModel.errorMessage = null;
        viewModel.isLoadingClaim = true;
      });
      await viewModel.questServices
          .claimQuest(context: context, questId: widget.questData.id);
      if (mounted) {
        widget.onClaimSuccess(); // Notify PopUpQuest and Home to refresh data
      }
    } catch (e) {
      setState(() {
        viewModel.errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          viewModel.isLoadingClaim = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.calendar_month, size: 32, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.questData.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.monetization_on,
                            color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text('${widget.questData.reward}'),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('${widget.questData.count}/${widget.questData.limit}'),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: widget.questData.status ? claimQuest : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            widget.questData.status ? Colors.blue : Colors.grey,
                      ),
                      child: viewModel.isLoadingClaim
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Claim',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PopUpQuest extends StatefulWidget {
  final VoidCallback onClaimSuccess; // Callback function

  const PopUpQuest({super.key, required this.onClaimSuccess});

  @override
  State<PopUpQuest> createState() => _PopUpQuestState();
}

class _PopUpQuestState extends State<PopUpQuest> {
  final HomeViewModel viewModel = HomeViewModel();

  Future<void> fetchData() async {
    try {
      setState(() {
        viewModel.errorMessage = null;
        viewModel.isLoadingQuest = true;
      });
      viewModel.quests =
          await viewModel.questServices.getQuest(context: context);

    } catch (e) {
      setState(() {
        viewModel.errorMessage = e.toString();
      });
    } finally {
      setState(() {
        viewModel.isLoadingQuest = false;
      });
    }
  }

  void refreshData() {
    fetchData();
    widget.onClaimSuccess(); // Refresh profile data in Home
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      'Quest',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            viewModel.isLoadingQuest
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 300, // Adjust height based on UI needs
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: viewModel.quests.length,
                      itemBuilder: (context, index) {
                        return RowQuest(
                          questData: viewModel.quests[index],
                          onClaimSuccess: refreshData, // Pass the callback
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
