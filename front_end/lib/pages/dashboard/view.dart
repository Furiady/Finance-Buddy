import 'package:flutter/material.dart';
import 'package:front_end/components/navigation-bar-component/view.dart';
import 'package:front_end/pages/dashboard/view-model.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DashboardViewModel viewModel = DashboardViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  viewModel.screen[viewModel.selectedTab],
      bottomNavigationBar: NavigationBarComponent(
        pageIndex: viewModel.selectedTab,
        onTap: (index) {
          setState(() {
            viewModel.selectedTab = index;
          });
        },
      ),
    );
  }
}
