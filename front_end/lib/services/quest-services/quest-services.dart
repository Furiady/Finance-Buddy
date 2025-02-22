import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/constant/api-path.dart';
import 'package:front_end/model/quest-model/model.dart';

class QuestServices {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<List<QuestModel>> getQuest({required BuildContext context}) async {
    try {
      String? token = await secureStorage.read(key: 'token');

      if (token == null) {
        throw Exception('Token is missing or expired');
      }

      _dio.options.headers['Authorization'] = token;

      final response = await _dio.get(questEndPoint);
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((item) => QuestModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to fetch quest data');
      }
    } on DioException catch (dioError) {
      throw Exception(dioError.message ?? "Unknown network error");
    } catch (error) {
      throw Exception("Unexpected error: $error");
    }
  }

  Future<void> claimQuest({required BuildContext context, required String questId}) async {
    try {
      String? token = await secureStorage.read(key: 'token');

      if (token == null) {
        throw Exception('Token is missing or expired');
      }

      _dio.options.headers['Authorization'] = token;

      final response = await _dio.post('$claimQuestEndPoint/$questId/claim');

      if (response.statusCode != 200) {
        throw Exception('Failed to claim quest');
      }
    } on DioException catch (dioError) {
      throw Exception(dioError.message ?? "Unknown network error");
    } catch (error) {
      throw Exception("Unexpected error: $error");
    }
  }
}
