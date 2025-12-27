// ignore_for_file: must_be_immutable, sort_child_properties_last


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const/app_colors.dart';

class CustomTextfield2 extends StatelessWidget {
  final TextEditingController controller;
  final String hintext;
  final double? height;
  final Widget? suffixIcon;
  final String? prefixIconPath;
  final ValueChanged<String>? onChanged;
  final bool obsecureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  final int? maxLines;
  final double? radius;
  final Color? borderColor;
  final double? padding;
  final int? maxLength;

  const CustomTextfield2(
      {super.key,
      this.height,
      this.padding,
      required this.controller,
      required this.hintext,
      this.suffixIcon,
      this.prefixIconPath,
      this.onChanged,
      this.obsecureText = false,
      this.keyboardType,
      this.inputFormatters,
      this.radius,
      this.borderColor,
      this.maxLines,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderColor ?? AppColors.borderColor,
        ),
        borderRadius: BorderRadius.circular(radius ?? 8),
      ),
      child: TextField(
        controller: controller,
        obscureText: obsecureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines ?? 1,
        maxLength: maxLength ?? 50,
        style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlack),
        decoration: InputDecoration(
          prefixIcon: prefixIconPath != null
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // SizedBox(width: getWidth(14)),
                      Image.asset(
                        prefixIconPath!,
                        height: 24,
                        width: 24,
                      ),
                    ],
                  ),
                )
              : null,
          suffixIcon: suffixIcon != null
              ? SizedBox(
                  child: suffixIcon!,
                  height: 16,
                  width: 16,
                )
              : null,
          hintText: hintext,
          hintStyle: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textGrey),

          /// border
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding: padding != null
              ? EdgeInsets.zero
              : EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          counterText: "",
        ),
      ),
    );
  }
}
