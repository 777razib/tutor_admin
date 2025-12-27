import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/icons_path.dart';
import '../controller/home_controller.dart';

class CustomNavBar extends StatelessWidget {
  final HomeController controller = Get.find();

  CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => BottomNavigationBar(
        currentIndex: controller.currentIndex.value, // use observable
        onTap: (index) => controller.currentIndex(index), // update index
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              controller.currentIndex.value == 0
                  ? IconsPath.home // selected icon
                  : IconsPath.home_border, // unselected icon
              scale: 4.2,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              controller.currentIndex.value == 1
                  ? IconsPath.user
                  : IconsPath.user_border,
              scale: 4,
            ),
            label: "User",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              controller.currentIndex.value == 2
                  ? IconsPath.license
                  : IconsPath.license_border,
              scale: 4.3,
            ),
            label: "Request",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              controller.currentIndex.value == 3
                  ? IconsPath.credit_card
                  : IconsPath.credit_card_border,
              scale: 4.3,
            ),
            label: "Payment",
          ),
        ],
      ),
    );

  }
}
