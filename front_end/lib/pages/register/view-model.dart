import 'package:dio/dio.dart';
import 'package:front_end/constant/api-path.dart';
import 'package:front_end/model/register-model/model.dart';

class RegisterViewModel {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<bool> register(RegisterModel model) async {
    try {
      final response = await _dio.post(registerEndpoint, data: model.toJson());

      if (response.statusCode == 204) {
        // Handle successful registration based on your API response
        print("Registration successful");
        return true;
      } else {
        print("Registration failed: \${response.data}");
        return false;
      }
    } catch (e) {
      print("Error during registration: \$e");
      return false;
    }
  }
}