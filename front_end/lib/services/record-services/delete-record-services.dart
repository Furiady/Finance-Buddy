import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/constant/api-path.dart';
import 'package:front_end/pages/dashboard/view.dart';
import 'package:front_end/pages/home/view.dart';
import 'package:front_end/utils/pop-up-error/pop-up-error.dart';
import 'package:front_end/utils/pop-up-success/pop-up-success.dart';

class DeleteRecordService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> deleteRecord(
      {required BuildContext context, required String id}) async {
    try {
      String? token = await secureStorage.read(key: 'token');

      if (token == null) {
        throw Exception('Error: Token is missing or expired');
      }

      _dio.options.headers['Authorization'] = token;

      final response = await _dio.delete('$deleteRecordEndPoint$id');

      if (response.statusCode == 200) {
        showSuccessDialog(
          context: context,
          message: "Successfully deleted",
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Dashboard()),
                  (Route<dynamic> route) => false,
            );
          },
        );
      } else {
        throw Exception('Unexpected response: ${response.data}');
      }
    } on DioException catch (dioError) {
      showErrorDialog(context, dioError.message ?? "Unknown network error");
    } catch (error) {
      showErrorDialog(context, "Unexpected error: $error");
    }
  }
}
