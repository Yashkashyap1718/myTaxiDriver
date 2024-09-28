import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PriceRowView extends StatelessWidget {
  final String price;
  final String title;
  final Color priceColor;
  final Color titleColor;

  const PriceRowView({
    super.key,
    required this.price,
    required this.title,
    required this.priceColor,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: titleColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            child: Text(
              price,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                color: priceColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
