import 'package:flutter/material.dart';

class QuestModel {
  String title; int completed; int total; IconData icon; bool canClaim;

  QuestModel({
    required this.title,
    required this.completed,
    required this.total,
    required this.icon,
    required this.canClaim,
  });

  // Convert to JSON for API request or local storage
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'completed': completed,
      'total': total,
      'icon': icon,
      'canClaim': canClaim,
    };
  }

  // Create a RecordModel from JSON data
  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
        title: json['title'],
        completed: json['completed'],
        total: json['total'],
        icon: json['icon'],
        canClaim: json['canClaim'],
    );
  }
}
