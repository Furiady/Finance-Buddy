import 'package:flutter/material.dart';
import 'package:front_end/model/chart-model/model.dart';
import 'package:front_end/model/record-model/model.dart';
import 'package:front_end/services/chart-services/chart-services.dart';
import 'package:front_end/services/record-services/get-record-services.dart';

class BillsViewModel {
  final ChartService chartService = ChartService();
  final RecordService recordService = RecordService();
  List<ChartModel> chartData = [];
  List<RecordModel> recordsData = [];
  String? _errorMessage;
  DateTime currentDate = DateTime.now();
  String? get errorMessage => _errorMessage;

  Future<void> fetchChartData({
    required int month,
    required int year,
  }) async {
    try {
      _errorMessage = null;
      chartData = await chartService.getChartData(type: "Income", month: month, year: year);

    } catch (e) {
      _errorMessage = e.toString();

    }
  }

  Future<void> fetchRecordsData({
    required int month,
    required int year,
    String? type,
    String? category,
    String? deductFrom,
  }) async {
    try {
      _errorMessage = null;
      recordsData = await recordService.getRecords(
        year: year,
        month: month,
        type: type,
        category: category,
        deductFrom: deductFrom,
      );
    } catch (e) {
      _errorMessage = e.toString();
    }
  }
}


