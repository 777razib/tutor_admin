import 'package:flutter/material.dart';
import '../style/global_text_style.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isObscure;
  final bool? enabled; // Optional enabled parameter (nullable)

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isObscure = false,
    this.enabled, // Optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF979797), width: 1.0),
      ),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        enabled: enabled ?? true, // Default to true if enabled is null
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14.0,
            horizontal: 10,
          ),
          hintText: hintText,
          hintStyle: globalTextStyle(
            color: Color(0xFF3A404A),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon:
              prefixIcon != null
                  ? Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: prefixIcon,
                  )
                  : null,
          suffixIcon:
              suffixIcon != null
                  ? Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10),
                    child: suffixIcon,
                  )
                  : null,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
