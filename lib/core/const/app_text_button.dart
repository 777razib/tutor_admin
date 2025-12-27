
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextButton extends StatefulWidget {
  const AppTextButton({
    super.key,
    required this.text,
    required this.onTap,
    this.textColor,
    this.textSize,
    this.fontWeight,
  });

  final String text;
  final Color? textColor;
  final double? textSize;
  final Function onTap;
  final FontWeight? fontWeight;

  @override
  State<AppTextButton> createState() => _AppTextButtonState();
}

class _AppTextButtonState extends State<AppTextButton> {
  late Color color;
  late double size;

  @override
  void initState() {
    super.initState();
    color = widget.textColor ?? Colors.black;
    size = widget.textSize ?? 14.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: Text(
        widget.text,
        style: GoogleFonts.manrope(
          color: color,
          fontWeight: widget.fontWeight ?? FontWeight.w600,
          fontSize: size,
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      color = color.withValues(alpha: 0.6);
    });
  }

  void _onTapUp(TapUpDetails details) {
    Future.delayed(const Duration(milliseconds: 150)).then((value) {
      setState(() {
        color = widget.textColor ?? Colors.black;
        size = widget.textSize ?? 14.0;
      });
    });
  }
}
