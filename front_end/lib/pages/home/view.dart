import 'package:flutter/material.dart';
import 'package:front_end/pages/home/component.dart';
import 'package:front_end/pages/home/home-list/view.dart';
import 'package:front_end/pages/home/view-model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeViewModel viewModel = HomeViewModel();
  DateTime currentDate = DateTime.now();

  Future<void> fetchRecordsData({
    required DateTime date
  }) async {
    try {
      setState(() {
        viewModel.errorMessage = null;
        viewModel.isLoading = true;
      });
      viewModel.recordsData = await viewModel.recordService.getRecords(date: currentDate, page: 1, limit: 3);
    } catch (e) {
      setState(() {
        viewModel.errorMessage = e.toString();
      });
    } finally {
      setState(() {
        viewModel.isLoading = false;
      });
    }
  }
  Future<void> fetchIncomeExpenseValue({
    required DateTime date
  }) async {
    try {
      setState(() {
        viewModel.errorMessage = null;
        viewModel.isLoading = true;
      });
      viewModel.incomeExpenseValue = await viewModel.incomeExpenseService.getIncomeExpenseData(date: date);
    } catch (e) {
      setState(() {
        viewModel.errorMessage = e.toString();
      });
    } finally {
      setState(() {
        viewModel.isLoading = false;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    fetchRecordsData(date: currentDate);
    fetchIncomeExpenseValue(date: currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.2,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 1,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/ezgif.com-animated-gif-maker.gif'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),

            const SizedBox(height: 15),
            const Text("March 2024",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            const SizedBox(height: 15),
            IncomeExpenseCardComponent(value: viewModel.incomeExpenseValue),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Recent Transactions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeListComponent()),
                    );
                  },
                  icon: const Icon(Icons.navigate_next_outlined), // You can replace this with an iOS-style icon if needed
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(child: RecentListComponent(records: viewModel.recordsData)),
          ],
        ),
      ),
    );
  }
}
