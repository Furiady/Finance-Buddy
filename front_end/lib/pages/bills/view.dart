import 'package:flutter/material.dart';
import 'package:front_end/components/pie-chart-component/view.dart';

class Bills extends StatefulWidget {
  const Bills({super.key});

  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: PieChartComponent(),
    );
  }
}
