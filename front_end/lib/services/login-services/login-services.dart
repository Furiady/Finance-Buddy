import 'package:dio/dio.dart';
import 'package:front_end/constant/api-path.dart';
import 'package:front_end/model/login-model/model.dart';
import 'package:flutter/material.dart';

class LoginService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<String?> login(LoginModel model, BuildContext context) async {
    try {
      final response = await _dio.post(loginEndPoint, data: model.toJson());

      String token = response.data['token'];
      return token;
    } on DioException catch (e) {
      String message = e.response?.data['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $message')),
      );
    }
  }
}
