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

  Future<void> fetchData({required DateTime date}) async {
    try {
      setState(() {
        viewModel.errorMessage = null;
        viewModel.isLoading = true;
      });
      viewModel.profileData =
          await viewModel.profileService.getUser(context: context);
      viewModel.incomeExpenseValue =
          await viewModel.incomeExpenseService.getIncomeExpenseData(date: date);
      viewModel.recordsData = await viewModel.recordService
          .getRecords(date: date, page: 1, limit: 3);
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

  void refreshProfileData() {
    fetchData(date: currentDate); // Refresh user profile and other data
  }

  @override
  void initState() {
    super.initState();
    fetchData(date: currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return viewModel.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
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
                          image: DecorationImage(
                            image: AssetImage('assets/images/gamification/${viewModel.profileData?.gamification}.gif'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            color: Colors.blueAccent,
                            height: 40,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Icon(
                                    Icons.monetization_on,
                                    color: Colors.yellow,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Text(
                                    (viewModel.profileData?.coin.toString() ??
                                        "-"),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                color: Colors.blue,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        PopUpQuest(
                                      onClaimSuccess:
                                          refreshProfileData, // Pass the callback
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.task,
                                  color: Colors.white,
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
                  Text(DateFormat('MMMM yyyy').format(currentDate),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Expanded(
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
                              records: viewModel.recordsData),
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
