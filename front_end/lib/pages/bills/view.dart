import 'package:flutter/material.dart';
import 'package:front_end/components/monthly-header-component/view.dart';
import 'package:front_end/components/pie-chart-component-new/view.dart';
import 'package:front_end/components/reports-header-component/view.dart';
import 'package:front_end/pages/bills/view-model.dart';

class Bills extends StatefulWidget {
  const Bills({super.key});

  @override
  _BillsState createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  final BillsViewModel viewModel = BillsViewModel();
  DateTime currentDate = DateTime.now();
  Future<void> fetchChartData({
    required DateTime date,
  }) async {
    try {
      setState(() {
        viewModel.isLoading = true;
        viewModel.errorMessage = null;
      });
      viewModel.chartData = await viewModel.chartService.getChartData(type: "Income", date: date);
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
    required int month,
    required int year,
    String? type,
    String? category,
    String? deductFrom,
  }) async {
    try {
      setState(() {
        viewModel.errorMessage = null;
        viewModel.isLoading = true;
      });
      viewModel.recordsData = await viewModel.recordService.getRecords(
        year: year,
        month: month,
        type: type,
        category: category,
        deductFrom: deductFrom,
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
  }

  void handleDateChange(DateTime newDate) {
    setState(() {
      currentDate = newDate;
    });
    fetchChartData(date: newDate);
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 45),
                      viewModel.isLoading
                          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
                          : PieChartComponent(data: viewModel.chartData),
                      const SizedBox(height: 20),
                      //ListComponent(transactions: widget.transactions),
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
              onDateChanged: handleDateChange, // Pass the callback to the MonthlyHeaderComponent
            ),
          ),
        ],
      ),
    );
  }
}
