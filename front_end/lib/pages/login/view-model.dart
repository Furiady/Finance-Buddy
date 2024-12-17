import 'package:flutter/material.dart';
import 'package:front_end/model/login-model/model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/pages/dashboard/view.dart';
import 'package:front_end/services/login-services/login-services.dart';

class LoginViewModel {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final LoginService loginService = LoginService();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> login(BuildContext context) async {
    final loginModel = LoginModel(
        username: usernameController.text,
        password: passwordController.text,
    );

    String? token = await loginService.login(loginModel, context);

    if (token != null) {
      await secureStorage.write(key: 'token', value: token);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Dashboard()));
    }
  }

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }
}
