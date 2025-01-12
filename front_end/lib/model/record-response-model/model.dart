class RecordModel {
  final String type; // 'Expense' or 'Income'
  final String title;
  final String category;
  final int value;
  final String date; // String representation in YYYYMMDD format (derived from createdAt)
  final String? description;
  final String? deductFrom; // Only for 'expense'
  final String? url;

  RecordModel({
    required this.type,
    required this.title,
    required this.category,
    required this.value,
    required String createdAt, // Use this to create date
    this.description,
    this.deductFrom,
    this.url,
  }) : date = _parseDateFromCreatedAt(createdAt);

  static String _parseDateFromCreatedAt(String createdAt) {
    // Handle potential parsing errors (e.g., invalid format)
    try {
      return createdAt.substring(0, 8); // Extract YYYYMMDD from createdAt
    } catch (e) {
      print('Error parsing date from createdAt: $e');
      return ''; // Return empty string on error
    }
  }

  // Convert to JSON for API request or local storage
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'category': category,
      'value': value,
      'date': date,
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
      value: json['value'].toDouble(),
      createdAt: json['createdAt'], // Use createdAt to create date
      description: json['description'],
      deductFrom: json['deductFrom'],
      url: json['url'],
    );
  }
}