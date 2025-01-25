import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/constant/api-path.dart';

class DeleteRecordService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<String> deleteRecord({required String id}) async {
    try {
      String? token = await secureStorage.read(key: 'token');

      if (token == null) {
        throw Exception('Error: Token is missing or expired');
      }

      _dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await _dio.delete('$deleteRecordEndPoint$id');

      if (response.statusCode == 200) {
        return 'Record deleted successfully';
      } else {
        throw Exception('Unexpected response: ${response.data}');
      }
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? 'Unknown error occurred';
      log('Error: $message');
      throw Exception('Error: $message');
    } catch (e) {
      log('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
