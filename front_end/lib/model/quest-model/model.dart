import 'package:flutter/material.dart';

class QuestModel {
  String title;
  int count;
  int limit;
  bool status;
  int reward;
  String id;

  QuestModel({
    required this.title,
    required this.count,
    required this.limit,
    required this.status,
    required this.reward,
    required this.id,
  });

  // Convert to JSON for API request or local storage
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'count': count,
      'limit': limit,
      'status': status,
      'reward': reward,
      'id': id,
    };
  }

  // Create a RecordModel from JSON data
  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      title: json['title'],
      count: json['count'],
      limit: json['limit'],
      status: json['status'],
      reward: json['reward'],
      id: json['id'],
    );
  }
}
