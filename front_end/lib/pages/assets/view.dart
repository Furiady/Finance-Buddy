import 'package:flutter/material.dart';
import 'package:front_end/components/monthly-header-component/view.dart';
import 'package:front_end/components/pie-chart-component-new/view.dart';
import 'package:front_end/components/reports-header-component/view.dart';
import 'package:front_end/pages/assets/assets-list/view.dart';
import 'package:front_end/pages/assets/view-model.dart';
import 'package:front_end/pages/home/home-list/view.dart';

class Assets extends StatefulWidget {
  const Assets({super.key});

  @override
  _AssetsState createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  final AssetsViewModel viewModel = AssetsViewModel();
  DateTime currentDate = DateTime.now();

  Future<void> fetchChartData({
    required DateTime date,
  }) async {
    try {
      setState(() {
        viewModel.isLoading = true;
        viewModel.errorMessage = null;
      });
      viewModel.chartData =
          await viewModel.chartService.getChartData(type: "Income", date: date);
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

  Future<void> fetchRecordsData({
    required DateTime date,
  }) async {
    try {
      setState(() {
        viewModel.errorMessage = null;
        viewModel.isLoading = true;
      });
      viewModel.recordsData = await viewModel.recordService.getRecords(
        date: currentDate,
        type: 'Income',
      );
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
    fetchChartData(date: currentDate);
    fetchRecordsData(date: currentDate);
  }

  void handleDateChange(DateTime newDate) {
    setState(() {
      currentDate = newDate;
    });
    fetchChartData(date: newDate);
    fetchRecordsData(date: newDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const ReportsHeaderComponent(),
              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 45),
                            PieChartComponent(
                              data: viewModel.chartData,
                              onTap: (value) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeListComponent(
                                      type: "Income",
                                      category: value,
                                      headerTitle: value[0].toUpperCase() + value.substring(1),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            AssetsListComponent(
                              records: viewModel.recordsData,
                              date: currentDate,
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
              ),
            ],
          ),
          Positioned(
            top: 75,
            left: 0,
            right: 0,
            child: MonthlyHeaderComponent(
              date: currentDate,
              onDateChanged: handleDateChange,
            ),
          ),
        ],
      ),
    );
  }
}
