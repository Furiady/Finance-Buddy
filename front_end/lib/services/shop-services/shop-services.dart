import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/constant/api-path.dart';
import 'package:flutter/material.dart';
import 'package:front_end/model/shop-model/model.dart';
import 'package:front_end/utils/pop-up-error/pop-up-error.dart';
import 'package:front_end/utils/pop-up-success/pop-up-success.dart';

class ShopService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<List<ShopModel>> getShopItemsByType(
      {required String type, required BuildContext context}) async {
    try {
      String? token = await secureStorage.read(key: 'token');

      if (token == null) {
        showErrorDialog(context, 'Error: Token is missing or expired');
        return [];
      }

      _dio.options.headers['Authorization'] = token;

      final response = await _dio.get(type);
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((item) => ShopModel.fromJson(item))
            .toList();
      } else {
        showErrorDialog(context, 'Unexpected response format');
        return [];
      }
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? 'Unknown error';
      showErrorDialog(context, 'Error: $message');
      return [];
    }
  }

  Future<void> buyShopItemByType(
      {required String type,
      required String itemId,
      required BuildContext context}) async {
    try {
      String? token = await secureStorage.read(key: 'token');

      if (token == null) {
        throw ('Error: Token is missing or expired');
      }

      _dio.options.headers['Authorization'] = token;

      final response = await _dio.post(type,
          data: {"petId": itemId, "themeId": itemId, "accessoryId": itemId});

      if (response.statusCode == 200) {
        throw ("Item purchased successfully");
      } else {
        throw ("Failed to purchase item");
      }
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? 'Unknown error';
      throw message;
    }
  }
}
