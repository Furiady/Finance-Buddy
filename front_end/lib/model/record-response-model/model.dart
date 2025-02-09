class RecordModel {
  final String type;
  final String id;
  final String title;
  final String category;
  final int value;
  final DateTime date;
  final String? description;
  final String? deductFrom;
  final String? url;

  RecordModel({
    required this.type,
    required this.title,
    required this.category,
    required this.value,
    required this.date,
    this.description,
    required this.id,
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
      'id': id,
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
      id: json['id'],
      date: DateTime.parse(json['createdAt']),
      description: json['description'],
      deductFrom: json['deductFrom'],
      url: json['url'],
    );
  }
}
