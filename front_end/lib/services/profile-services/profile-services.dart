import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/constant/api-path.dart';
import 'package:front_end/model/profile-model/model.dart';
import 'package:front_end/utils/pop-up-error/pop-up-error.dart';

class ProfileService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<UserModel?> getUser({required BuildContext context}) async {
    try {
      String? token = await secureStorage.read(key: 'token');

      if (token == null) {
        throw Exception('Error: Token is missing or expired');
      }

      _dio.options.headers['Authorization'] = token;

      final response = await _dio.get(profileEndPoint);
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch user data');
      }
    } on DioException catch (dioError) {
      showErrorDialog(context, dioError.message ?? "Unknown network error");
    } catch (error) {
      showErrorDialog(context, "Unexpected error: $error");
    }
    return null;
  }
}
