class ChartModel {
  final String key;
  final int value;

  ChartModel({
    required this.key,
    required this.value,
  });

  // Convert to JSON for API request or local storage
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }

  // Create a ChartModel from JSON data
  factory ChartModel.fromJson(Map<String, dynamic> json) {
    return ChartModel(
      key: json['category'],
      value: json['value'],
    );
  }
}