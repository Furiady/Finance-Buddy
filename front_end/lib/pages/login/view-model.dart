import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front_end/constant/api-path.dart';
import 'package:front_end/model/login-model/model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/services/login-services/login-services.dart';
import 'package:front_end/views/profile.dart';

class LoginViewModel {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final LoginService loginService = LoginService();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> login(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;

    LoginModel loginModel = LoginModel(username: username, password: password);

    String? token = await loginService.login(loginModel, context);

    if (token != null) {
      await secureStorage.write(key: 'token', value: token);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ProfilePage()));
    }
  }

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
  }
}
