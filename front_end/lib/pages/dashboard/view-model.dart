import 'package:flutter/material.dart';
import 'package:front_end/pages/assets/view.dart';
import 'package:front_end/pages/bills/view.dart';
import 'package:front_end/pages/create/view.dart';
import 'package:front_end/pages/home/view.dart';
import 'package:front_end/pages/profile/view.dart';

class DashboardViewModel {
  int selectedTab = 0;
  List<Widget> screen = [const Home(), const Bills(), const Create(), const Assets(), const Profile()];
}
