import 'package:front_end/model/home-model/model.dart';
import 'package:front_end/model/profile-model/model.dart';
import 'package:front_end/model/quest-model/model.dart';
import 'package:front_end/model/record-response-model/model.dart';
import 'package:front_end/services/home-services/home-services.dart';
import 'package:front_end/services/profile-services/profile-services.dart';
import 'package:front_end/services/quest-services/quest-services.dart';
import 'package:front_end/services/record-services/get-record-services.dart';

class HomeViewModel {
  final ProfileService profileService = ProfileService();
  final RecordService recordService = RecordService();
  final QuestServices questServices = QuestServices();
  final IncomeExpenseService incomeExpenseService = IncomeExpenseService();
  IncomeExpenseModel incomeExpenseValue = IncomeExpenseModel(income: 0, expense: 0);
  List<RecordModel> recordsData = [];
  List<QuestModel> quests = [];
  UserModel? profileData;
  String? errorMessage;
  bool isLoading = false;
  bool isLoadingQuest = false;
  bool isLoadingClaim = false;
}
