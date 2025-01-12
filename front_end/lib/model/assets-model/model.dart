// Model class for user credentials
class AssetsChart {
  final String key;
  final String value;

  AssetsChart({required this.key, required this.value});

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }
}