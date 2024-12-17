import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/pages/dashboard/view.dart';
import 'package:front_end/pages/login/view.dart';

class SplashScreenViewModel {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  void navigateToNextPage(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      String? token = await secureStorage.read(key: 'token');
      if (token != null && token.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    });
  }
}
