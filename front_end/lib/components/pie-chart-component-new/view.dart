import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:front_end/components/pie-chart-component-new/view-model.dart';

class PieChartComponent extends StatelessWidget {
  final double totalExpense;
  final Map<String, double> categoryBreakdown;

  const PieChartComponent({
    super.key,
    required this.totalExpense,
    required this.categoryBreakdown,
  });

  @override
  Widget build(BuildContext context) {
    final PieChartComponentViewModel viewModel = PieChartComponentViewModel();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'This Month Total Spend',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            viewModel.formatCurrency(totalExpense),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: totalExpense > 0
                ? PieChart(
              PieChartData(
                sections: categoryBreakdown.entries.map((entry) {
                  final percentage = (entry.value / totalExpense) * 100;
                  return PieChartSectionData(
                    value: entry.value,
                    title: '${percentage.toStringAsFixed(1)}%',
                    color: viewModel.getCategoryColor(entry.key),
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            )
                : const Center(
              child: Text(
                'No expenses to display.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categoryBreakdown.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: viewModel.getCategoryColor(entry.key),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          viewModel.getIconPathByCategory(entry.key),
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${entry.key}: ${viewModel.formatCurrency(
                            entry.value)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
