
import 'dart:convert';
import 'dart:math';

import 'package:admin_tutor_app/core/network_caller/endpoints.dart';
import 'package:admin_tutor_app/core/services_class/local_service/shared_preferences_helper.dart';
import 'package:admin_tutor_app/feature/home/model/warming_tutor_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WarmingController extends GetxController{

  var isLoading = false.obs;
  var tutors = <WarmingTutorData>[].obs;
  var errorMessage = "".obs;

  final TextEditingController warningController = TextEditingController(
    text:
    'Your account creation is successful. You can now experience a good learning platform.',
  );

  @override
  void dispose() {
    warningController.dispose();
    super.dispose();
  }

  @override
  void onInit(){
    super.onInit();
    fetchWarmingTutors();
  }

  Future<void>fetchWarmingTutors() async{
    try{
      isLoading.value = true;
      errorMessage.value = "";

      final token = await SharedPreferencesHelper.getAccessToken();
      if(token == null){
        errorMessage.value = "No access token found. Please log in again";
        return;
      }

      final response = await http.get(
        Uri.parse("${Urls.baseUrl}/admins/warning-tutors"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        }
      );

      print(response.statusCode);
      print(response.request?.url);
      print(response.body);

      if(response.statusCode == 200){
        final parsed = WarmingTutorsModel.fromJson(json.decode(response.body));

        if(parsed.success == true && parsed.data != null){
          tutors.assignAll(parsed.data!);
        }else{
          errorMessage.value = parsed.message ?? "No tutors found";
        }
      } else{
        errorMessage.value = "Failed to fetch tutors: ${response.statusCode}";
      }
    }catch(v){
      errorMessage.value = "Error: $e";
    } finally{
      isLoading.value = false;
    }
  }

  // Get tutors by ID
  WarmingTutorData? getTutorById(String id){
    try{
      return tutors.firstWhereOrNull((tutors)=> tutors.id ==id);
    }catch(v){
      return null;
    }
  }

  // Search tutors by name
  List<WarmingTutorData> searchTutors(String query) {
    if (query.isEmpty) return tutors;
    return tutors
        .where((tutor) =>
        (tutor.fullName ?? '').toLowerCase().contains(query.toLowerCase()))
        .toList();
  }




  Future<void> warningTutors(String tutorId) async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: "Loading...");

      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        errorMessage.value = "No access token found. Please log in again";
        return;
      }

      var headers = {
        'Authorization': token,
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        Uri.parse('https://raalaaan.onrender.com/api/v1/admins/warning-send'),
        headers: headers,
        body: json.encode({
          "userId": tutorId,
          "message": warningController.text,
        }),
      );

      if (response.statusCode == 200) {
        EasyLoading.showSuccess("Warning sent");
      } else {
        print("Error ${response.statusCode}: ${response.body}");
        errorMessage.value = "Failed to send warning: ${response.body}";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  Future<void> suspendTutors(String tutorId) async {
    try {

      isLoading.value = true;
      EasyLoading.show(status: "Loading...");

      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null) {
        errorMessage.value = "No access token found. Please log in again";
        return;
      }

      var headers = {
        'Authorization': token,
      };
      var request = http.Request('PATCH', Uri.parse('${Urls.baseUrl}/admins/suspend-tutor/$tutorId'));
      request.body = '''''';
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        EasyLoading.show(status: "Suspended");

        tutors.removeWhere((tutor) => tutor.id == tutorId);

      }
      else {
        print(response.reasonPhrase);
      }

    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }



}