import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

class NavigationBarComponent extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavigationBarComponent({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: pageIndex,
      color: Colors.white,
      buttonBackgroundColor: Colors.white,
      backgroundColor: Colors.blueAccent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      items: [
        const CurvedNavigationBarItem(
          child: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        const CurvedNavigationBarItem(
          child: Icon(Icons.book_rounded),
          label: 'Bills',
        ),
        const CurvedNavigationBarItem(
          child: Icon(Icons.add_circle_outline_rounded),
          label: 'Create',
        ),
        const CurvedNavigationBarItem(
          child: Icon(Icons.attach_money_rounded),
          label: 'Assets',
        ),

        const CurvedNavigationBarItem(
          child: Icon(Icons.pets),
          label: 'Pets',
        ),
      ],
      onTap: onTap,
    );
  }
}
