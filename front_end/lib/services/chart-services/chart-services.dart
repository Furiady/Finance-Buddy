import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/constant/api-path.dart';
import 'package:front_end/model/chart-model/model.dart';
import 'package:intl/intl.dart';

class ChartService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<List<ChartModel>> getChartData({
    required String type,
    required DateTime date,
  }) async {
    try {
      String? token = await secureStorage.read(key: 'token');

      if (token == null) {
        throw Exception('Error: Token is missing or expired');
      }

      _dio.options.headers['Authorization'] = token;


      final DateTime startDate = DateTime(date.year, date.month, 1);
      final DateTime endDate = DateTime(date.year, date.month + 1, 0);

      String formattedStartDate = DateFormat('yyyyMMdd').format(startDate);
      String formattedEndDate = DateFormat('yyyyMMdd').format(endDate);

      final response = await _dio.get(
        chartEndPoint,
        queryParameters: {
          'type': type,
          'startDate': formattedStartDate,
          'endDate': formattedEndDate,
        },
      );

      List<dynamic> data = response.data as List<dynamic>;

      return data.map((item) => ChartModel.fromJson(item)).toList();
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? 'Unknown error';
      throw Exception('Error: $message');
    }
  }
}
