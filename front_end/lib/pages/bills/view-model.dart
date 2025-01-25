
import 'package:front_end/model/chart-model/model.dart';
import 'package:front_end/model/record-response-model/model.dart';
import 'package:front_end/services/chart-services/chart-services.dart';
import 'package:front_end/services/record-services/get-record-services.dart';

class BillsViewModel {
  final ChartService chartService = ChartService();
  final RecordService recordService = RecordService();

  List<ChartModel> chartData = [];
  List<RecordModel> recordsData = [];
  String? errorMessage;
  bool isLoading = false;
}
