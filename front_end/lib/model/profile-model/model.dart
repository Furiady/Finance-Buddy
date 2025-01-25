// Model class for income and expense
class UserModel {
  final String username;
  final String email;
  final int coin;
  final int id;
  final String pin;

  UserModel(
      {required this.username,
      required this.email,
      required this.coin,
      required this.id,
      required this.pin});

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'id': id,
      'coin': coin,
      'pin': pin,
      'email': email
    };
  }
}
