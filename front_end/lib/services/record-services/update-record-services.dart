import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/constant/api-path.dart';
import 'package:flutter/material.dart';
import 'package:front_end/model/record-response-model/model.dart';
import 'package:front_end/utils/pop-up-error/pop-up-error.dart';
import 'package:front_end/utils/pop-up-success/pop-up-success.dart';
import 'package:intl/intl.dart';

class UpdateRecordService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> updateRecord(RecordModel record, BuildContext context) async {
    try {
      String? token = await secureStorage.read(key: 'token');

      if (token == null) {
        showErrorDialog(context, 'Error: Token is missing or expired');
        return;
      }

      _dio.options.headers['Authorization'] = token;

      FormData formData = FormData.fromMap({
        'type': record.type,
        'title': record.title,
        'category': record.category,
        'value': record.value,
        'createdAt': DateFormat('yyyyMMdd').format(record.date),
        'description': record.description ?? '',
        'deductFrom': record.deductFrom ?? '',
      });

      await _dio.put(updateRecordEndPoint + record.id, data: formData);

      showSuccessDialog(
        context: context,
        message: 'Record created successfully!',
        onPressed: () {
          Navigator.of(context).pop(); // Close dialog
        },
      );
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? 'Unknown error';
      showErrorDialog(context, 'Error: $message');
    }
  }
}
