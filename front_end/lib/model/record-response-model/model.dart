class RecordModel {
  final String type; // 'Expense' or 'Income'
  final String title;
  final String category;
  final int value;
  final DateTime date; // Parsed from createdAt
  final String? description;
  final String? deductFrom; // Only for 'expense'
  final String? url;

  RecordModel({
    required this.type,
    required this.title,
    required this.category,
    required this.value,
    required this.date,
    this.description,
    this.deductFrom,
    this.url,
  });

  // Convert to JSON for API request or local storage
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'category': category,
      'value': value,
      'date': date.toIso8601String(),
      'description': description,
      'deductFrom': deductFrom,
      'url': url,
    };
  }

  // Create a RecordModel from JSON data
  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      type: json['type'],
      title: json['title'],
      category: json['category'],
      value: json['value'],
      date: DateTime.parse(json['createdAt']), // Convert YYYYMMDD to DateTime
      description: json['description'],
      deductFrom: json['deductFrom'],
      url: json['url'],
    );
  }
}
