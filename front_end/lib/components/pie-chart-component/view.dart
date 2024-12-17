import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:front_end/components/pie-chart-component/view-model.dart';

class PieChartComponent extends StatefulWidget {
  const PieChartComponent({super.key});

  @override
  State<PieChartComponent> createState() => _PieChartComponentState();
}

class _PieChartComponentState extends State<PieChartComponent> {
  final PieChartViewModel viewModel = PieChartViewModel();

  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive sizing
    final double screenWidth = MediaQuery.of(context).size.width;

    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: viewModel.showingSections(touchedIndex),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                color: Colors.blue,
                text: 'First',
                isSquare: false, // Circle indicator
                size: screenWidth * 0.05, // Responsive size (5% of screen width)
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Colors.yellow,
                text: 'Second',
                isSquare: false, // Circle indicator
                size: screenWidth * 0.05, // Responsive size (5% of screen width)
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Colors.purple,
                text: 'Third',
                isSquare: false, // Circle indicator
                size: screenWidth * 0.05, // Responsive size (5% of screen width)
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Colors.green,
                text: 'Fourth',
                isSquare: false, // Circle indicator
                size: screenWidth * 0.05, // Responsive size (5% of screen width)
              ),
              const SizedBox(
                height: 18,
              ),
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size; // Added size parameter for responsive design

  const Indicator({
    required this.color,
    required this.text,
    required this.isSquare,
    required this.size, // Accept size in constructor
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(isSquare ? 0 : 50), // Circle or rectangle
          child: Container(
            color: color,
            width: size, // Set width based on the passed size
            height: size, // Set height based on the passed size
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
