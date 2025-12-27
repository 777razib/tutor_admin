import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/app_colors.dart';

void successToast({
  required String message,
  Color backgroundColor = Colors.green,
  Color textColor = Colors.white,
  SnackPosition snackPosition = SnackPosition.TOP,
  Duration duration = const Duration(seconds: 3),
}) {
  Get.snackbar(
    "Success",
    message,
    backgroundColor: backgroundColor,
    colorText: textColor,
    snackPosition: snackPosition,
    duration: duration,
    margin: const EdgeInsets.all(10),
    borderRadius: 8,
    icon: Icon(
      Icons.check_circle,
      color: textColor,
    ),
  );
}

void errorToast({
  String? title,
  required String message,
  Color backgroundColor = AppColors.primaryColor,
  Color textColor = Colors.white,
  SnackPosition snackPosition = SnackPosition.TOP,
  Duration duration = const Duration(seconds: 3),
}) {
  Get.snackbar(
    title ?? "Error",
    message,
    backgroundColor: backgroundColor,
    colorText: textColor,
    snackPosition: snackPosition,
    duration: duration,
    margin: const EdgeInsets.all(10),
    borderRadius: 8,
    icon: Icon(
      Icons.check_circle,
      color: textColor,
    ),
  );
}
