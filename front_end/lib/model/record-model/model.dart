import 'dart:io';

class RecordModel {
  final String type;
  final String title;
  final String category;
  final int value;
  final String date;
  final String? description;
  final String? deductFrom;
  final File? image;

  RecordModel({
    required this.type,
    required this.title,
    required this.category,
    required this.value,
    required this.date,
    this.image,
    this.description,
    this.deductFrom,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'category': category,
      'value': value,
      'description': description,
      'date': date,
      'deductFrom': deductFrom,
    };
  }

  // Create a RecordModel from JSON data
  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      type: json['type'],
      title: json['title'],
      category: json['category'],
      value: json['value'].toDouble(),
      date: json['date'],
      description: json['description'],
      deductFrom: json['deductFrom'],
    );
  }
}
