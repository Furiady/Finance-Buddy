import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:front_end/components/pie-chart-component-new/view-model.dart';
import 'package:front_end/model/chart-model/model.dart';
import 'package:front_end/utils/format-currency/format-currency.dart';

class PieChartComponent extends StatelessWidget {
  final List<ChartModel> data;
  final void Function(String)? onTap;

  const PieChartComponent({
    super.key,
    required this.onTap,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final PieChartComponentViewModel viewModel = PieChartComponentViewModel();
    final totalValue = data.fold(0, (sum, item) => sum + item.value);
    final random = Random();
    final Map<String, Color> categoryColors = {
      for (var item in data)
        item.key: Color.fromARGB(
          255,
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
        ),
    };

    return IntrinsicHeight(
      // Ensures the height adjusts to the content
      child: Container(
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
          mainAxisSize: MainAxisSize.min, // Allows dynamic resizing
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
              formatCurrency(totalValue),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              flex: 4,
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: totalValue > 0
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: PieChart(
                              PieChartData(
                                sections: data.map((entry) {
                                  final percentage =
                                      (entry.value / totalValue) * 100;
                                  final color = categoryColors[entry.key]!;
                                  return PieChartSectionData(
                                    value: entry.value.toDouble(),
                                    title: '${percentage.toStringAsFixed(1)}%',
                                    color: color,
                                    radius: 50,
                                    titleStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                }).toList(),
                                sectionsSpace: 2,
                                centerSpaceRadius: 40.0,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: Text(
                          'No data to display.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.map((entry) {
                final color = categoryColors[entry.key]!;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: GestureDetector(
                    onTap: () {
                      onTap!(entry.key);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
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
                            '${entry.key}: ${formatCurrency(entry.value)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
