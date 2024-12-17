import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:front_end/constant/api-path.dart';
import 'package:front_end/model/register-model/model.dart';

class RegisterService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<bool?> register(RegisterModel model, BuildContext context) async {
    try {
      final response = await _dio.post(registerEndpoint, data: model.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account created successfully')),
      );
      return true;
    } on DioException catch (e) {
      String message = e.response?.data['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $message')),
      );
    }
  }
}
