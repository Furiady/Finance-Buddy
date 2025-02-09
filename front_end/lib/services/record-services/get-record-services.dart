import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/constant/api-path.dart';
import 'package:front_end/model/record-response-model/model.dart';
import 'package:intl/intl.dart';

class RecordService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<List<RecordModel>> getRecords({
    required DateTime date,
    String? type,
    String? category,
    String? deductFrom,
    int? page,
    int? limit,
  }) async {
    try {
      String? token = await secureStorage.read(key: 'token');

      if (token == null) {
        throw Exception('Error: Token is missing or expired');
      }

      _dio.options.headers['Authorization'] = token;

      final DateTime startDate = DateTime(date.year, date.month, 1);
      final DateTime endDate = DateTime(date.year, date.month + 1, 0)
          .subtract(const Duration(days: 1));

      String formattedStartDate = DateFormat('yyyyMMdd').format(startDate);
      String formattedEndDate = DateFormat('yyyyMMdd').format(endDate);

      final response = await _dio.get(
        getRecordsEndPoint,
        queryParameters: {
          'startDate': formattedStartDate,
          'endDate': formattedEndDate,
          if (type != null) 'type': type,
          if (category != null) 'category': category,
          if (deductFrom != null) 'deductFrom': deductFrom,
          if (page != null) 'page': page,
          if (limit != null) 'limit': limit
        },
      );

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((item) => RecordModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? 'Unknown error';
      throw Exception('Error: $message');
    }
  }
}
