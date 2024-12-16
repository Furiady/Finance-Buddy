// Model class for user credentials
class LoginModel {
  final String username;
  final String password;

  LoginModel({required this.username, required this.password});

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}