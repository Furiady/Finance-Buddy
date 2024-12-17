import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:front_end/model/register-model/model.dart';
import 'package:front_end/pages/login/view.dart';
import 'package:front_end/services/register-services/register-services.dart';

class RegisterViewModel {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RegisterService _registerService = RegisterService();

  Future<void> register(BuildContext context) async {
    final registerModel = RegisterModel(
      email: emailController.text,
      username: usernameController.text,
      password: passwordController.text,
    );

    bool? success = await _registerService.register(registerModel, context);

    if (success == true) {
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }
}
