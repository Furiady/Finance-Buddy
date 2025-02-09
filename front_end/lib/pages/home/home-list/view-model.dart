
import 'package:front_end/model/record-response-model/model.dart';
import 'package:front_end/services/record-services/get-record-services.dart';

class HomeListViewModel {
  final RecordService recordService = RecordService();
  List<RecordModel> recordsData = [];
  String? errorMessage;
  bool isLoading = false;
  List<RecordModel> filterRecordsByMonth(List<RecordModel> records, DateTime currentDate) {
    return records.where((record) {
      final recordDate = record.date;
      return recordDate.year == currentDate.year &&
          recordDate.month == currentDate.month;
    }).toList();
  }
}