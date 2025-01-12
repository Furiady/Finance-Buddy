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

  @override
  void initState() {

    super.initState();
    viewModel.fetchChartData(month: 1, year: 2025);
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
                      PieChartComponent(data: viewModel.chartData),
                      const SizedBox(height: 20),
                      //ListComponent(transactions: widget.transactions),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Positioned(
            top: 75,
            left: 0,
            right: 0,
            child: MonthlyHeaderComponent(),
          ),
        ],
      ),
    );
  }
}
