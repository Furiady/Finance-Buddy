import 'package:flutter/material.dart';
import 'package:front_end/components/monthly-header-component/view.dart';
import 'package:front_end/components/pie-chart-component-new/view.dart';
import 'package:front_end/components/reports-header-component/view.dart';
import 'package:front_end/pages/assets/asset-records-list/view.dart';
import 'package:front_end/pages/assets/view-model.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class Assets extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;

  const Assets({super.key, required this.transactions});

  @override
  _AssetsState createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  final AssetViewModel viewModel = AssetViewModel();

  @override
  Widget build(BuildContext context) {
    final totalValue = viewModel.totalExpense(widget.transactions);
    final data = viewModel.getCategoryBreakdown(widget.transactions);

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
                      // PieChartComponent(
                      //     totalValue: totalValue,
                      //     data: data),
                      const SizedBox(height: 20),
                      AssetRecordsList(transactions: widget.transactions),
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
            child: Text(""), //MonthlyHeaderComponent(),
          ),
        ],
      ),
    );
  }
}
