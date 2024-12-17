import 'package:flutter/material.dart';
import 'package:front_end/components/pie-chart-component/view.dart';

class Assets extends StatefulWidget {
  const Assets({super.key});

  @override
  State<Assets> createState() => _AssetsState();
}

class _AssetsState extends State<Assets> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PieChartComponent(),
    );
  }
}
