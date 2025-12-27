import 'package:flutter/material.dart';

class CustomButton2 extends StatelessWidget {
  const CustomButton2({
    super.key,
    required this.title,
    this.backgroundColor = Colors.white, // Default color
    this.borderColor = Colors.transparent,
    required this.onPress,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ), // Default text style
  });

  final String title;
  final Color backgroundColor;
  final Color? borderColor;
  final TextStyle textStyle; // Default text style is set to white color
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        splashColor: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(100),
        onTap: onPress,
        child: Center(
          child: Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border:
                  borderColor != null ? Border.all(color: borderColor!) : null,
            ),
            child: Center(child: Text(title, style: textStyle)),
          ),
        ),
      ),
    );
  }
}
