import 'package:flutter/material.dart';
import 'package:front_end/model/chart-model/model.dart';
import 'package:front_end/model/record-model/model.dart';
import 'package:front_end/services/chart-services/chart-services.dart';
import 'package:front_end/services/record-services/get-record-services.dart';

class ChartViewModel extends ChangeNotifier {
  final ChartService chartService;
  final RecordService recordService;
  List<ChartModel> _chartData = [];
  List<RecordModel> _recordsData = [];
  String? _errorMessage;

  ChartViewModel(this.chartService, this.recordService);

  List<ChartModel> get chartData => _chartData;
  List<RecordModel> get recordsData => _recordsData;
  String? get errorMessage => _errorMessage;

  Future<void> fetchChartData({
    required int month,
    required int year,
  }) async {
    try {
      _errorMessage = null;
      _chartData = await chartService.getChartData(type: "Income", month: month, year: year);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
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
      _recordsData = await recordService.getRecords(
        year: year,
        month: month,
        type: type,
        category: category,
        deductFrom: deductFrom,
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}