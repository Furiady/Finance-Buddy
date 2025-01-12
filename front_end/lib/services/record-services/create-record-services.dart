import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/constant/api-path.dart';
import 'package:front_end/model/record-model/model.dart';
import 'package:flutter/material.dart';

class CreateRecordService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> createRecord(RecordModel record, BuildContext context) async {
    try {
      String? token = await secureStorage.read(key: 'token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Token is missing or expired')),
        );
        return;
      }

      _dio.options.headers['Authorization'] = token;

      FormData formData = FormData.fromMap({
        'type': record.type,
        'title': record.title,
        'category': record.category,
        'value': record.value,
        'createdAt': record.date,
        'description': record.description ?? '',
        'deductFrom': record.deductFrom ?? '',
        if (record.image != null)
          'image': await MultipartFile.fromFile(record.image!.path),
      });

      await _dio.post(createRecordEndpoint, data: formData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record created successfully!')),
      );
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? 'Unknown error';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $message')),
      );
    }
  }
}
