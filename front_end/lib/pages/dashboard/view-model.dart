import 'package:flutter/material.dart';
import 'package:front_end/components/navigation-bar-component/view-model.dart';
import 'package:front_end/pages/assets/view.dart';
import 'package:front_end/pages/bills/view.dart';
import 'package:front_end/pages/create/view.dart';
import 'package:front_end/pages/home/view.dart';
import 'package:front_end/pages/profile/view.dart';

class DashboardViewModel {
  static final GlobalKey<NavigatorState> homeNavKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> searchNavKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> notificationNavKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> profileNavKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> gameNavKey = GlobalKey<NavigatorState>();

  int selectedTab = 0;

  final List<Map<String, dynamic>> _transactions = [];



  List<ModelNavigationBar> get items => [
    ModelNavigationBar(
      page: const Home(),
      navKey: homeNavKey,
    ),
    ModelNavigationBar(
    page: const Bills(),
      navKey: searchNavKey,
    ),
    ModelNavigationBar(
      page: const Create(),
      navKey: profileNavKey,
    ),
    ModelNavigationBar(
     page: Assets(),
      navKey: notificationNavKey,
    ),
    ModelNavigationBar(
      page: const Profile(),
      navKey: gameNavKey,
    ),
  ];
}
