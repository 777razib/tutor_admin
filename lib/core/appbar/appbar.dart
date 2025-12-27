import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? image; // Asset path for user image
  final String? suffixAsset; // Asset image path for suffix icon
  final VoidCallback? onSuffixTap;
  final IconData? icon;
  final VoidCallback? rightRefreshCallBack;
  final VoidCallback? onBack; 

  


  const CustomAppBar({
    super.key,
    this.title,
    this.image,
    this.suffixAsset,
    this.onSuffixTap,
    this.icon,
    this.rightRefreshCallBack,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: title != null
          ? Text(
        title!,
        style: TextStyle(fontSize: 24, color: Colors.black),
      )
          : null,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFF8ad88e),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),
      ),
      actions: [
        if (suffixAsset != null)
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 15),
            child: GestureDetector(
              onTap: onSuffixTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF293038),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  suffixAsset!,
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        if (image != null)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(image!),
              backgroundColor: Colors.transparent,
            ),
          ),
        if (icon != null && rightRefreshCallBack != null)
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 15),
            child: GestureDetector(
              onTap: rightRefreshCallBack,
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color(0xFF293038),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}