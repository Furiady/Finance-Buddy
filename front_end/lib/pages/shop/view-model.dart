import 'package:front_end/model/shop-model/model.dart';
import 'package:front_end/services/shop-services/shop-services.dart';

class ShopViewModel {
  final ShopService shopService = ShopService();
  List<ShopModel> shopItems = [];
  bool isLoading = false;
  bool isBuying = false;
  String? errorMessage;
}