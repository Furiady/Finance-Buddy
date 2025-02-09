

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/model/profile-model/model.dart';
import 'package:front_end/pages/login/view.dart';
import 'package:front_end/services/profile-services/profile-services.dart';
import 'package:front_end/utils/pop-up-error/pop-up-error.dart';

class ProfileViewModel {
  final ProfileService profileService = ProfileService();
  String? errorMessage;
  bool isLoading = false;
  bool isPinEnabled = false;
  bool isSmartLoginEnabled = false;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  UserModel? profileData;
  Future<void> logout(BuildContext context) async {
    try {
      await secureStorage.deleteAll();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (error) {
      showErrorDialog(context, "Error during logout: $error");
    }
  }
}