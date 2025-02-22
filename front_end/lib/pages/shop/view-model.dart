import 'package:front_end/model/profile-model/model.dart';
import 'package:front_end/model/shop-model/model.dart';
import 'package:front_end/services/profile-services/profile-services.dart';
import 'package:front_end/services/shop-services/shop-services.dart';

class ShopViewModel {
  final ProfileService profileService = ProfileService();
  final ShopService shopService = ShopService();
  List<ShopModel> shopItems = [];
  UserModel? profileData;
  bool isLoading = false;
  bool isBuying = false;
  bool isChanging = false;
  String? errorMessage;
  String popUpMessageBuyItem = "Are you sure you want to buy this item?";
  String popUpMessageChangeItem = "Are you sure want to use this item?";
  Map<String, String> gamificationData = {
    "pet": "",
    "accessory": "",
    "theme": ""
  };


  /// Function to split gamification data
  void parseGamification() {
    if (profileData?.gamification == null ||
        profileData!.gamification.isEmpty) {
      gamificationData = {"pet": "", "accessory": "", "theme": ""};
      return;
    }

    List<String> parts = profileData!.gamification.split('-');
    gamificationData = {
      "pet": parts.isNotEmpty ? 'assets/images/pets/${parts[0]}.gif' : "",
      "accessory": parts.length > 1 ? 'assets/images/accessories/${parts[1]}.gif' : "",
      "theme": parts.length > 2 ? 'assets/images/themes/${parts[2]}.gif' : "",
    };
  }
}
