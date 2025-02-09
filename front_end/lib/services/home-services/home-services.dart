import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/constant/api-path.dart';
import 'package:front_end/model/home-model/model.dart';
import 'package:intl/intl.dart';

class IncomeExpenseService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<IncomeExpenseModel> getIncomeExpenseData({required DateTime date}) async {
    try {
      // Retrieve the token from secure storage
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
        incomeExpenseEndPoint,
        queryParameters: {
          'startDate': formattedStartDate,
          'endDate': formattedEndDate,
        },
      );

      return IncomeExpenseModel(
        income: response.data['income'] as int,
        expense: response.data['expense'] as int,
      );
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? 'Unknown error';
      throw Exception('Error: $message');
    }
  }
}
