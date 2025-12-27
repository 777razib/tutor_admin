import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/icons_path.dart';

class CustomBackButtonWithout extends StatelessWidget {
  const CustomBackButtonWithout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
          child: Image.asset(
            IconsPath.back,
          ),
        ),
      ),
    );
  }
}
