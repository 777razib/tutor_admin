import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/network_caller/endpoints.dart';
import '../../../core/services_class/local_service/shared_preferences_helper.dart';
import '../model/notification_model.dart';


class NotificationController extends GetxController {
  // Observable list of notifications
  var notifications = <NotificationData>[].obs;

  // Loading state
  var isLoading = false.obs;

  // Error message
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  /// Fetch notifications from API
  Future<void> fetchNotifications() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "Token not found!";
        return;
      }

      final uri = Uri.parse('${Urls.baseUrl}/notifications/get');
      final response = await http.get(uri, headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final notificationResponse = NotificationResponse.fromJson(decoded);
        notifications.assignAll(notificationResponse.data);
      } else {
        errorMessage.value = "Failed to fetch notifications. Status: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }

  /// Mark a notification as read locally
  Future<void> markAllAsRead() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      final uri = Uri.parse('${Urls.baseUrl}/notifications/read');
      final response = await http.put(uri, headers: {
        'Authorization': token ?? '',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        // Update local list
        notifications.assignAll(
          notifications.map((n) => n.copyWith(read: true)).toList(),
        );
      } else {
        print("Failed to mark all as read: ${response.body}");
      }
    } catch (e) {
      print("Error markAllAsRead: $e");
    }
  }


}
