import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/constant/api-path.dart';
import 'package:front_end/model/record-model/model.dart';
import 'package:intl/intl.dart';

class RecordService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<List<RecordModel>> getRecords({
    required int year,
    required int month,
    String? type,
    String? category,
    String? deductFrom,
  }) async {
    try {
      String? token = await secureStorage.read(key: 'token');

      if (token == null) {
        throw Exception('Error: Token is missing or expired');
      }

      _dio.options.headers['Authorization'] = token;

      final DateTime startDate = DateTime(year, month, 1);
      final DateTime endDate = DateTime(year, month + 1, 0).subtract(Duration(days: 1));

      String formattedStartDate = DateFormat('yyyyMMdd').format(startDate);
      String formattedEndDate = DateFormat('yyyyMMdd').format(endDate);

      final response = await _dio.get(
        getRecordsEndpoint,
        queryParameters: {
          'startDate': startDate,
          'endDate': endDate,
          if (type != null) 'type': type,
          if (category != null) 'category': category,
          if (deductFrom != null) 'deductFrom': deductFrom,
        },
      );

      List<dynamic> data = response.data as List<dynamic>;

      return data.map((item) => RecordModel.fromJson(item)).toList();
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? 'Unknown error';
      throw Exception('Error: $message');
    }
  }
}