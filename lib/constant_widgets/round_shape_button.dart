import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundShapeButton extends StatelessWidget {
  final String title;
  final Color buttonColor;
  final Color buttonTextColor;
  final VoidCallback onTap;
  final Size size;
  final double? textSize;
  final Widget? titleWidget;

  const RoundShapeButton({
    super.key,
    required this.title,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.onTap,
    required this.size,
    this.textSize,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all<Size>(size),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(200),
            side: BorderSide(color: buttonColor),
          ),
        ),
      ),
      onPressed: onTap,
      child: titleWidget ??
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: textSize ?? 14,
              fontWeight: FontWeight.w500,
              color: buttonTextColor,
            ),
          ),
    );
  }
}
