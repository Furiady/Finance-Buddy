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
      color: Colors.blue,
      buttonBackgroundColor: Colors.blue,
      backgroundColor: Colors.white,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      items: const [
        CurvedNavigationBarItem(
            child: Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            label: 'Home',
            labelStyle: TextStyle(color: Colors.white)),
        CurvedNavigationBarItem(
            child: Icon(
              Icons.book_rounded,
              color: Colors.white,
            ),
            label: 'Bills',
            labelStyle: TextStyle(color: Colors.white)),
        CurvedNavigationBarItem(
            child: Icon(
              Icons.add_circle_outline_rounded,
              color: Colors.white,
            ),
            label: 'Create',
            labelStyle: TextStyle(color: Colors.white)),
        CurvedNavigationBarItem(
            child: Icon(
              Icons.attach_money_rounded,
              color: Colors.white,
            ),
            label: 'Assets',
            labelStyle: TextStyle(color: Colors.white)),
        CurvedNavigationBarItem(
            child: Icon(
              Icons.person_outline_rounded,
              color: Colors.white,
            ),
            label: 'Profile',
            labelStyle: TextStyle(color: Colors.white)),
      ],
      onTap: onTap,
    );
  }
}
