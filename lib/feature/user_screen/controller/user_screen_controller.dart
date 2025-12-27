import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/network_caller/endpoints.dart';
import '../../../core/services_class/local_service/shared_preferences_helper.dart';
import '../model/user_screen_model.dart';

class UserController extends GetxController {
  // Observables
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  var users = <UserModelData>[].obs;
  var searchQuery = ''.obs;

  // Filter selections
  var selectedRoles = <String>[].obs;
  var selectedSubjects = <String>[].obs;

  // Pagination
  var currentPage = 1.obs;
  var totalPage = 1.obs;
  var isMoreLoading = false.obs;

  // Filtered users based on search & filter
  List<UserModelData> get filteredUsers {
    return users.where((u) {
      final searchMatch = (searchQuery.value.isEmpty) ||
          (u.fullName?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false) ||
          (u.email?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false);

      final roleMatch = selectedRoles.isEmpty ||
          selectedRoles.contains(u.role == Role.TUTOR ? "Teacher" : "Student");

      final subjectMatch = selectedSubjects.isEmpty ||
          (u.subject != null && u.subject!.any((s) => selectedSubjects.contains(s)));

      return searchMatch && roleMatch && subjectMatch;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchUsers(isRefresh: true);

    // Optional: search debounce
    debounce(searchQuery, (_) => update());
  }

  /// Fetch Users from API
  Future<void> fetchUsers({bool isRefresh = false, int page = 1, int limit = 10}) async {
    try {
      if (isRefresh) {
        currentPage.value = 1;
        users.clear();
      }

      if (currentPage.value > totalPage.value) return;

      if (isRefresh) {
        isLoading.value = true;
      } else {
        isMoreLoading.value = true;
      }

      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) {
        Get.snackbar("Error", "Token not found!");
        return;
      }

      final response = await http.get(
          Uri.parse("${Urls.baseUrl}/admins/all-users"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": token,
          }
      );

      if (response.statusCode == 201) {
        final data = UserScreenModel.fromJson(json.decode(response.body));
        totalPage.value = data.data?.meta?.totalPage ?? 1;

        if (isRefresh) {
          users.value = data.data?.data ?? [];
        } else {
          users.addAll(data.data?.data ?? []);
        }
        currentPage.value++;
      } else {
        isError.value = true;
        errorMessage.value = "Error ${response.statusCode}: ${response.reasonPhrase}";
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  /// Pull-to-refresh
  Future<void> refreshUsers() async {
    await fetchUsers(isRefresh: true);
  }

  /// Apply selected filters from FilterScreen
  void applyFilters({List<String>? roles, List<String>? subjects}) {
    selectedRoles.value = roles ?? [];
    selectedSubjects.value = subjects ?? [];
    update(); // triggers UI refresh
  }
}





