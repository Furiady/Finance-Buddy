// Model class for record data
import 'dart:io';

class RecordModel {
  final String type; // 'expense' or 'income'
  final String title;
  final String category;
  final int value;
  final String date; // String representation in YYYYMMDD format
  final String? description;
  final String? deductFrom; // Only for 'expense'
  final File? image;

  RecordModel({
    required this.type, // 'expense' or 'income'
    required this.title,
    required this.category,
    required this.value,
    required this.date,
    this.image,
    this.description,
    this.deductFrom,
  });

  // Convert to JSON for API request or local storage
  Map<String, dynamic> toJson() {
    return {
      'type': type, // 'expense' or 'income'
      'title': title,
      'category': category,
      'value': value,
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
      value: json['value'].toDouble(),
      date: json['date'],
      description: json['description'],
      deductFrom: json['deductFrom'],
    );
  }
}