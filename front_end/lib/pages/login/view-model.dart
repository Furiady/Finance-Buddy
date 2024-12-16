import 'package:dio/dio.dart';
import 'package:front_end/constant/api-path.dart';
import 'package:front_end/model/login-model/model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginViewModel {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<bool> login(LoginModel model) async {
    try {
      final response = await _dio.post(loginEndpoint, data: model.toJson());

      if (response.statusCode == 200) {
        final token = response.data['token'];

        if (token != null) {
          await _secureStorage.write(key: 'token', value: token);
          _dio.options.headers['Authorization'] = 'Bearer $token';

          print("Login successful: Token saved and set as bearer");
          return true;
        } else {
          print("Login failed: Token not found in response");
          return false;
        }
      } else {
        print("Login failed: \${response.data}");
        return false;
      }
    } catch (e) {
      print("Error during login: \$e");
      return false;
    }
  }
}
