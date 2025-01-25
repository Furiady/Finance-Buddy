import 'package:front_end/model/home-model/model.dart';
import 'package:front_end/model/record-response-model/model.dart';
import 'package:front_end/services/home-services/home-services.dart';
import 'package:front_end/services/record-services/get-record-services.dart';

class ProfileViewModel {
  final RecordService recordService = RecordService();
  final IncomeExpenseService incomeExpenseService = IncomeExpenseService();
  IncomeExpenseModel incomeExpenseValue = IncomeExpenseModel(income: 0,expense: 0);
  List<RecordModel> recordsData = [];
  String? errorMessage;
  bool isLoading = false;
}