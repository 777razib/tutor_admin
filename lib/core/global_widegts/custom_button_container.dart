import 'package:flutter/material.dart';

class CustomButtonContainer extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color buttonColor;
  final Color textColor;
  final Color borderColor;

  const CustomButtonContainer({
    super.key,
    required this.text,
    required this.onTap,
    this.buttonColor = Colors.white,
    this.textColor = Colors.black,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}