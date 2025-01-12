import 'package:flutter/material.dart';
import 'package:front_end/components/pie-chart-component/view.dart';
import 'package:front_end/pages/bills/view-model.dart';
import 'pie_chart_widget.dart'; // Adjust the import path as necessary
import 'view_model.dart'; // Import the view model to fetch the data

class Bills extends StatefulWidget {
  const Bills({Key? key}) : super(key: key);

  @override
  State<Bills> createState() => _PieChartViewState();
}

class _PieChartViewState extends State<Bills> {
  late final ChartViewModel _chartViewModel;
  Map<String, double>? billsChart;

  @override
  void initState() {
    super.initState();
    _viewModel = ViewModel(); // Initialize the view model
    _fetchData();
  }

  Future<void> _fetchData() async {
    final data = await _viewModel.fetchBillsChart(); // Fetch data from the API
    setState(() {
      billsChart = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pie Chart"),
      ),
      body: billsChart == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Data Distribution",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            PieChartWidget(
              data: billsChart!,
              centerSpaceRadius: 60.0,
            ),
            const SizedBox(height: 24),
            const Text(
              "Chart Information",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: billsChart!.entries.map((entry) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.circle, size: 14, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      "${entry.key}: ${entry.value.toStringAsFixed(1)}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
