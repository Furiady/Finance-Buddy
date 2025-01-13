import 'package:flutter/material.dart';

class ReportsHeaderComponent extends StatefulWidget {
  const ReportsHeaderComponent({super.key});

  @override
  State<ReportsHeaderComponent> createState() => _ReportsHeaderComponentState();
}

class _ReportsHeaderComponentState extends State<ReportsHeaderComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 110,
          color: Colors.blue,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
