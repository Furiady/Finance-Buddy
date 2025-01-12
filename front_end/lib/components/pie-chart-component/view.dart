import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> data;
  final double centerSpaceRadius;

  const PieChartWidget({
    Key? key,
    required this.data,
    this.centerSpaceRadius = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalValue = data.values.fold(0.0, (sum, value) => sum + value);
    final random = Random();
    final List<Color> colors = [];

    return totalValue > 0
        ? Column(
      children: [
        PieChart(
          PieChartData(
            sections: data.entries.map((entry) {
              final percentage = (entry.value / totalValue) * 100;
              final color = Color.fromARGB(
                255,
                random.nextInt(256),
                random.nextInt(256),
                random.nextInt(256),
              );
              colors.add(color);
              return PieChartSectionData(
                value: entry.value,
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
            centerSpaceRadius: centerSpaceRadius,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: data.entries.map((entry) {
            final colorIndex = data.keys.toList().indexOf(entry.key);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: colors[colorIndex],
                ),
                const SizedBox(width: 8),
                Text(
                  entry.key,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    )
        : const Center(
      child: Text(
        'No data to display.',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
