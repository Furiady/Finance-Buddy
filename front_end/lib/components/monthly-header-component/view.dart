import 'package:flutter/material.dart';
import 'package:front_end/components/monthly-header-component/view-model.dart';

class MonthlyHeaderComponent extends StatefulWidget {
  const MonthlyHeaderComponent({super.key});

  @override
  State<MonthlyHeaderComponent> createState() => _MonthlyHeaderComponentState();
}

class _MonthlyHeaderComponentState extends State<MonthlyHeaderComponent> {
  final MonthlyHeaderComponentViewModel viewModel = MonthlyHeaderComponentViewModel();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
            onPressed: viewModel.decrementMonth,
          ),
        ),
        const SizedBox(width: 8), // Memberi jarak antara panah dan bulan
        Container(
          width: 250,
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Perbesar padding
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              viewModel.formattedDate,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 40,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_forward, color: Color.fromARGB(255, 0, 0, 0)),
            onPressed: viewModel.incrementMonth,
          ),
        ),
      ],
    );
  }
}
