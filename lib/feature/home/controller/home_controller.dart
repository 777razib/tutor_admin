import 'dart:convert';
import 'package:admin_tutor_app/core/network_caller/endpoints.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/services_class/local_service/shared_preferences_helper.dart';
import '../../request_screen/models/request_screen_model.dart';
import '../model/home_model.dart';

class HomeController extends GetxController {

  var isOnline = true.obs;
  RxInt currentIndex = 0.obs;
  var selectedReportType = 'Weekly'.obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isError = false.obs;
  var homeModel = Rxn<HomeModel>();
  var tutorRequests = <TutorReqData>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
    fetchTutorRequests();
  }


  Future<void> fetchHomeData() async {
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
        Uri.parse("${Urls.baseUrl}/admins/stats"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );

      if (response.statusCode == 200) {
        final data = HomeModel.fromJson(json.decode(response.body));
        homeModel.value = data;
      } else {
        errorMessage.value = "Failed to load data: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper getters for UI
  int get totalUsers => homeModel.value?.data?.totalUser ?? 0;
  int get totalTutors => homeModel.value?.data?.totalTutors ?? 0;
  int get totalStudents => homeModel.value?.data?.totalStudents ?? 0;
  int get newUser7 => homeModel.value?.data?.newUser7 ?? 0;
  int get newUser30 => homeModel.value?.data?.newUser30 ?? 0;

  List<LastDay> get last7Days => homeModel.value?.data?.last7Days ?? [];
  List<LastDay> get last30Days => homeModel.value?.data?.last30Days ?? [];



  /// REQUEST
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

      print(response.statusCode);
      print(response.body);

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


  // Approve a tutor request
  void approveTutor(TutorReqData tutor) {
    int index = tutorRequests.indexWhere((t) => t.id == tutor.id);
    if (index != -1) {
      tutorRequests[index].isTutorApproved = true;
      tutorRequests[index].tutorRequestStatus = TutorRequestStatus.PENDING; // update status if needed
      tutorRequests.removeAt(index);
      tutorRequests.refresh(); // notify listeners
    }
  }

  // Reject a tutor request
  void rejectTutor(TutorReqData tutor) {
    int index = tutorRequests.indexWhere((t) => t.id == tutor.id);
    if (index != -1) {
      tutorRequests[index].isTutorApproved = false;
      tutorRequests[index].tutorRequestStatus = TutorRequestStatus.PENDING; // update status if needed
      tutorRequests.removeAt(index);
      tutorRequests.refresh();
    }
  }

  void removeTutorRequest(String tutorId) {
    tutorRequests.removeWhere((t) => t.id == tutorId);
  }


  Future<void> acceptTutorRequest(String tutorId) async {
    EasyLoading.show(status: "Accepting...");
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        EasyLoading.showError("No token found!");
        return;
      }

      final response = await http.patch(
        Uri.parse('${Urls.baseUrl}/admins/tutor-request-update'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: json.encode({"tutorId": tutorId, "status": "ACCEPTED"}),
      );

      if (response.statusCode == 200) {
        tutorRequests.removeWhere((t) => t.id == tutorId);
        EasyLoading.showSuccess("Tutor request accepted");
      } else {
        EasyLoading.showError("Failed to accept request");
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> denyTutorRequest(String tutorId) async {
    EasyLoading.show(status: "Declining...");
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        EasyLoading.showError("No token found!");
        return;
      }

      final response = await http.patch(
        Uri.parse('${Urls.baseUrl}/admins/tutor-request-update'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: json.encode({"tutorId": tutorId, "status": "CANCELLED"}),
      );

      if (response.statusCode == 200) {
        tutorRequests.removeWhere((t) => t.id == tutorId);
        EasyLoading.showSuccess("Tutor request declined");
      } else {
        EasyLoading.showError("Failed to decline request");
      }
    } catch (e) {
      EasyLoading.showError("Error: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }



}
