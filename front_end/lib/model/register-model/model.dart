// Model class for user credentials
class RegisterModel {
  final String email;
  final String username;
  final String password;

  RegisterModel({required this.email, required this.username, required this.password});

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'password': password,
    };
  }
}