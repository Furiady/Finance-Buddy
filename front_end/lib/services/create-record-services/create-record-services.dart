import 'package:dio/dio.dart';
import 'package:front_end/constant/api-path.dart';
import 'package:front_end/model/record-model/model.dart';
import 'package:flutter/material.dart';

class CreateRecordService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<void> createRecord(RecordModel record, BuildContext context) async {
    try {
      final response =
          await _dio.post(createRecordEndpoint, data: record.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record created successfully!')),
      );
    } on DioException catch (e) {
      String message = e.response?.data['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $message')),
      );
    }
  }
}
