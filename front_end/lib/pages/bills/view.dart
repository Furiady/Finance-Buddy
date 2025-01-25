import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:front_end/components/monthly-header-component/view.dart';
import 'package:front_end/components/pie-chart-component-new/view.dart';
import 'package:front_end/components/reports-header-component/view.dart';
import 'package:front_end/pages/bills/bills-list/view.dart';
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
      viewModel.chartData = await viewModel.chartService.getChartData(type: "Expense", date: date);
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
    required DateTime date
  }) async {
    try {
      setState(() {
        viewModel.errorMessage = null;
        viewModel.isLoading = true;
      });
      viewModel.recordsData = await viewModel.recordService.getRecords(
        date: currentDate,
        type: "Expense",
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
                child: SingleChildScrollView(
                  child: viewModel.isLoading
                      ? const Center(
                          child:
                              CircularProgressIndicator()) // Show loading spinner
                      : Column(
                          children: [
                            const SizedBox(height: 45),
                            PieChartComponent(data: viewModel.chartData),
                            const SizedBox(height: 20),
                            BillsListComponent(records: viewModel.recordsData, date: currentDate),
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
              onDateChanged:
                  handleDateChange, // Pass the callback to the MonthlyHeaderComponent
            ),
          ),
        ],
      ),
    );
  }
}
