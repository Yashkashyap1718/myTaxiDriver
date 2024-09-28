import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreenPage extends StatelessWidget {
  final String title;
  final String body;
  final String image;

  const IntroScreenPage({super.key, required this.title, required this.body, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            image,
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 22, color: AppThemData.black, fontWeight: FontWeight.w700),
          ),
           const SizedBox(height: 7),
          Text(
            body,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 14, color: AppThemData.black, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
