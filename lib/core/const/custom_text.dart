// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_sizes.dart';


class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final maxLines;
  final TextOverflow? textOverflow;
  final TextAlign? textAlign;
  const CustomText({
    super.key,
    required this.text,
    this.maxLines,
    this.textOverflow,
    this.fontSize,
    this.color,
    this.textAlign,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.manrope(
        fontSize: fontSize ?? getWidth(16),
        color: color ?? AppColors.textBlack,
        fontWeight: fontWeight ?? FontWeight.w700,
      ),
      overflow: textOverflow,
      maxLines: maxLines,
    );
  }
}
