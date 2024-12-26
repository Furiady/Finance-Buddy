// Model class for record data
class RecordModel {
  final String type; // 'expense' or 'income'
  final String title;
  final String category;
  final double amount;
  final String date; // String representation in YYYYMMDD format
  final String? description;
  final String? deductFrom; // Only for 'expense'

  RecordModel({
    required this.type, // 'expense' or 'income'
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    this.description,
    this.deductFrom,
  });

  // Convert to JSON for API request or local storage
  Map<String, dynamic> toJson() {
    return {
      'type': type, // 'expense' or 'income'
      'title': title,
      'category': category,
      'amount': amount,
      'description': description,
      'date': date, // Already in YYYYMMDD format
      'deductFrom': deductFrom,
    };
  }

  // Create a RecordModel from JSON data
  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      type: json['type'], // 'expense' or 'income'
      title: json['title'],
      category: json['category'],
      amount: json['amount'].toDouble(),
      date: json['date'],
      description: json['description'],
      deductFrom: json['deductFrom'],
    );
  }
}