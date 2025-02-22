class UserModel {
  final String username;
  final String email;
  final int coin;
  final String id;
  final String pin;
  final int balance;
  final String gamification;

  UserModel({
    required this.username,
    required this.email,
    required this.coin,
    required this.id,
    required this.balance,
    required this.pin,
    required this.gamification,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      coin: json['coin'] ?? 0,
      id: json['id'] ?? 0,
      pin: json['pin'] ?? '',
      balance: json['balance'] ?? 0,
      gamification: json['gamification'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'id': id,
      'coin': coin,
      'pin': pin,
      'email': email,
      'balance': balance,
      'gamification' : gamification
    };
  }
}
