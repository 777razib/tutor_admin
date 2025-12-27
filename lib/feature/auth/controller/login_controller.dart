import 'package:admin_tutor_app/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../core/const/app_texts.dart';
import '../../../../core/network_caller/endpoints.dart';
import '../../../../core/services_class/local_service/shared_preferences_helper.dart';

class LoginController extends GetxController {
  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> logInGlobalKey = GlobalKey<FormState>();

  var isClicked = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisible() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (isClicked.value) return;
    isClicked.value = true;
    isLoading.value = true;

    String email = emailController.text.trim();
    String password = passwordController.text;

    RegExp emailRegex =
    RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');

    if (email.isEmpty) {
      EasyLoading.showError(AppTexts.emailhint);
      resetLoading();
      return;
    } else if (!emailRegex.hasMatch(email)) {
      EasyLoading.showError("Invalid email format");
      resetLoading();
      return;
    } else if (password.isEmpty) {
      EasyLoading.showError(AppTexts.passwordhint);
      resetLoading();
      return;
    }

    try {
      EasyLoading.show(status: 'Logging in...');

      var url = Uri.parse('${Urls.baseUrl}/auth/login');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,
          "password": password,
          "role": "ADMIN",
        }),
      );

      print('Status: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {

        var data = jsonDecode(response.body);
        String token = data['data']['token'];
        await SharedPreferencesHelper.saveAccessToken(token);

        Get.to(() => HomeScreen());
        EasyLoading.showSuccess("Login successfully");
      } else {
        var error = jsonDecode(response.body);
        EasyLoading.showError(error['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('Error: $e');
      EasyLoading.showError('Unable to connect to the server.');
    } finally {
      EasyLoading.dismiss();
      resetLoading();
    }
  }


  void resetLoading() {
    isClicked.value = false;
    isLoading.value = false;
  }
}

