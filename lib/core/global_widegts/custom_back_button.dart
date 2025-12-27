import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/icons_path.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
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
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(IconsPath.back),
        ),
      ),
    );
  }
}
