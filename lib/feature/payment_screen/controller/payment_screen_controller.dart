import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/network_caller/endpoints.dart';
import '../../../core/services_class/local_service/shared_preferences_helper.dart';
import '../models/payment_screen_model.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;

  var paymentModel = Rxn<PaymentModel>();

  @override
  void onInit() {
    super.onInit();
    fetchPaymentData();
  }

  /// Fetch payment data from API
  Future<void> fetchPaymentData() async {
    try {

      isLoading.value = true;
      isError.value = false;
      errorMessage.value = '';

      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        isError.value = true;
        errorMessage.value = "No access token found. Please log in again.";
        return;
      }

    final response = await http.get(
      Uri.parse("${Urls.baseUrl}/admins/my-wallet"), // replace with your endpoint
      headers: {
        "Content-Type": "application/json",
        "Authorization": token,
      },
    );

    print(response.statusCode);
    print(response.body);
    print(response.request?.url);

    if (response.statusCode == 200) {
      paymentModel.value = PaymentModel.fromRawJson(response.body);
    } else {
      isError.value = true;
      errorMessage.value = "Failed to load data: ${response.statusCode}";
    }

    } catch (e) {
      isError.value = true;
      errorMessage.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper getters for UI
  double get totalPayments => paymentModel.value?.data?.total ?? 0;
  double get lastWeekPayments => paymentModel.value?.data?.lastWeek ?? 0;
  int get thisWeekCount => paymentModel.value?.data?.thisWeek ?? 0;
  String get percentageChange => paymentModel.value?.data?.percentageChange ?? "0%";
  List<User> get users => paymentModel.value?.data?.user ?? [];
}
