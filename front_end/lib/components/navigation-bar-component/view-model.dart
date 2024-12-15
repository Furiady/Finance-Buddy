import 'package:flutter/material.dart';

class ModelNavigationBar {
  final Widget page;
  final GlobalKey<NavigatorState> navKey;

  ModelNavigationBar({required this.page, required this.navKey});
}