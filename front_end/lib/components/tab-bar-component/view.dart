import 'package:flutter/material.dart';

class TabBarComponent extends StatefulWidget {
  final List<String> tabTitles;

  const TabBarComponent({super.key, required this.tabTitles});

  @override
  State<TabBarComponent> createState() => _TabBarComponentState();
}

class _TabBarComponentState extends State<TabBarComponent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          child: Container(
            color: Colors.blue,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.white,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: widget.tabTitles.map((title) => Tab(text: title)).toList(),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabTitles
                .map((title) => Center(child: Text(title)))
                .toList(),
          ),
        ),
      ],
    );
  }
}
