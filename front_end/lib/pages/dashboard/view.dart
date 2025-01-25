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
    return PopScope(
      canPop: !(viewModel.items[viewModel.selectedTab].navKey.currentState
              ?.canPop() ??
          true),
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;

        if (viewModel.items[viewModel.selectedTab].navKey.currentState
                ?.canPop() ??
            false) {
          viewModel.items[viewModel.selectedTab].navKey.currentState?.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: viewModel.selectedTab,
          children: viewModel.items
              .map((page) => Navigator(
                    key: page.navKey,
                    onGenerateInitialRoutes: (navigator, initialRoute) {
                      return [
                        MaterialPageRoute(builder: (context) => page.page),
                      ];
                    },
                  ))
              .toList(),
        ),
        bottomNavigationBar: NavigationBarComponent(
          pageIndex: viewModel.selectedTab,
          onTap: (index) {
            if (index == viewModel.selectedTab) {
              viewModel.items[index].navKey.currentState
                  ?.popUntil((route) => route.isFirst);
            } else {
              setState(() {
                viewModel.selectedTab = index;
              });
            }
          },
        ),
      ),
    );
  }
}
