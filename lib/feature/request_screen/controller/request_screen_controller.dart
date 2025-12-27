import 'dart:convert';
import 'package:admin_tutor_app/core/network_caller/endpoints.dart';
import 'package:admin_tutor_app/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/request_screen_model.dart';

class TutorRequestController extends GetxController {
  var isLoading = false.obs;
  var tutorRequests = <TutorReqData>[].obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTutorRequests();
  }

  // ===============================
  // Show Confirmation Dialog
  // ===============================
  void showConfirmDialog({
    required String tutorId,
    required bool isAccept,
  }) {
    Get.defaultDialog(
      title: isAccept ? "Accept Request" : "Decline Request",
      middleText: isAccept
          ? "Are you sure you want to accept this tutor request?"
          : "Are you sure you want to decline this tutor request?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      buttonColor: isAccept ? Colors.green : Colors.red,
      onConfirm: () {
        Get.back(); // dialog close
        if (isAccept) {
          acceptTutorRequest(tutorId: tutorId);
        } else {
          denyTutorRequest(tutorId: tutorId);
        }
      },
      onCancel: () => Get.back(),
    );
  }

  // ===============================
  // Fetch tutor requests from API
  // ===============================
  Future<void> fetchTutorRequests() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        isError.value = true;
        errorMessage.value = "No access token found. Please log in again.";
        return;
      }

      final response = await http.get(
        Uri.parse("${Urls.baseUrl}/admins/tutor-request"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      if (response.statusCode == 200) {
        TutorRequest tutorRequest = TutorRequest.fromRawJson(response.body);
        tutorRequests.value = tutorRequest.data ?? [];
      } else {
        errorMessage.value =
        'Error: ${response.statusCode} ${response.reasonPhrase}';
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // ===============================
  // Accept Tutor Request
  // ===============================
  Future<void> acceptTutorRequest({String? tutorId}) async {
    EasyLoading.show(status: "Loading...");
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        isError.value = true;
        errorMessage.value = "No access token found. Please log in again.";
        return;
      }

      var headers = {
        'Authorization': token,
        'Content-Type': 'application/json',
      };

      var response = await http.patch(
        Uri.parse('${Urls.baseUrl}/admins/tutor-request-update'),
        headers: headers,
        body: json.encode({
          "tutorId": tutorId,
          "status": "ACCEPTED",
        }),
      );

      if (response.statusCode == 200) {
        tutorRequests.removeWhere((t) => t.id == tutorId);
        Get.snackbar(
          "Success",
          "Tutor request accepted",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        EasyLoading.showError("Failed to accept request");
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = "Error: $e";
      EasyLoading.showError("Something went wrong");
    } finally {
      EasyLoading.dismiss();
    }
  }

  // ===============================
  // Decline Tutor Request
  // ===============================
  Future<void> denyTutorRequest({String? tutorId}) async {
    EasyLoading.show(status: "Loading...");
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        isError.value = true;
        errorMessage.value = "No access token found. Please log in again.";
        return;
      }

      var headers = {
        'Authorization': token,
        'Content-Type': 'application/json',
      };

      var response = await http.patch(
        Uri.parse('${Urls.baseUrl}/admins/tutor-request-update'),
        headers: headers,
        body: json.encode({
          "tutorId": tutorId,
          "status": "CANCELLED",
        }),
      );

      if (response.statusCode == 200) {
        tutorRequests.removeWhere((t) => t.id == tutorId);
        Get.snackbar(
          "Declined",
          "Tutor request declined",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        EasyLoading.showError("Failed to decline request");
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = "Error: $e";
      EasyLoading.showError("Something went wrong");
    } finally {
      EasyLoading.dismiss();
    }
  }
}
