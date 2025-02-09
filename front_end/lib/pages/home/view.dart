import 'package:flutter/material.dart';
import 'package:front_end/pages/home/component.dart';
import 'package:front_end/pages/home/home-list/view.dart';
import 'package:front_end/pages/home/view-model.dart';
import 'package:front_end/pages/shop/view.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeViewModel viewModel = HomeViewModel();
  DateTime currentDate = DateTime.now();

  Future<void> fetchRecordsData({required DateTime date}) async {
    try {
      setState(() {
        viewModel.errorMessage = null;
        viewModel.isLoading = true;
      });
      viewModel.recordsData = await viewModel.recordService
          .getRecords(date: currentDate, page: 1, limit: 3);
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

  Future<void> fetchIncomeExpenseValue({required DateTime date}) async {
    try {
      setState(() {
        viewModel.errorMessage = null;
        viewModel.isLoading = true;
      });
      viewModel.incomeExpenseValue =
          await viewModel.incomeExpenseService.getIncomeExpenseData(date: date);
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image:
                          AssetImage('assets/ezgif.com-animated-gif-maker.gif'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellow,
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Add your quest button logic here
                          },
                          icon: const Icon(
                            Icons.task,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8), // Space between buttons
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Shop()),
                            );
                          },
                          icon: const Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              DateFormat('MMMM yyyy').format(currentDate),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            viewModel.isLoading
                ? const Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: Column(
                      children: [
                        IncomeExpenseCardComponent(
                            value: viewModel.incomeExpenseValue),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Recent Transactions",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HomeListComponent(
                                      headerTitle: "Recent Transaction Records",
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.navigate_next_outlined),
                            ),
                          ],
                        ),
                        Expanded(
                          child: RecentListComponent(
                            records: viewModel.recordsData,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
