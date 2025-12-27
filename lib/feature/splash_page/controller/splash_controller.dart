import 'package:admin_tutor_app/feature/auth/screen/login_screen.dart';
import 'package:admin_tutor_app/feature/home/screen/home_screen.dart';
import 'package:admin_tutor_app/feature/splash_page/screen/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/services_class/local_service/shared_preferences_helper.dart';

class SplashScreenController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    _checkIsLogin();
  }

  Future<void> _checkIsLogin() async {
    // Small delay to show splash screen
    await Future.delayed(const Duration(seconds: 3));

    try {
      String? token = await SharedPreferencesHelper.getAccessToken();
      bool isFirstLaunch = await SharedPreferencesHelper.isFirstLaunch();
      String? role = await SharedPreferencesHelper.getString("ADMIN");

      if (kDebugMode) {
        print("Access Token: $token");
        print("Is First Launch: $isFirstLaunch");
        print("User Role: $role");
      }

      if (isFirstLaunch) {
        // Show onboarding screen and mark as completed
        await SharedPreferencesHelper.setFirstLaunch();
        Get.offAll(() => SplashScreen());
        return;
      }

      if (token == null || token.isEmpty) {
        // Navigate to onboarding/login
        Get.offAll(() => SignInScreen());
        return;
      }

      Get.offAll(() => HomeScreen());
    } catch (e) {
      if (kDebugMode) print("Error in SplashScreenController: $e");
      // fallback to onboarding screen on error
      Get.offAll(() => SplashScreen());
    }
  }
}
