import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class NoRidesView extends StatelessWidget {
  const NoRidesView({
    super.key,
    required this.themeChange,
  });

  final DarkThemeProvider themeChange;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive.height(75, context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/icon/ic_no_rides.svg"),
          const SizedBox(
            height: 24,
          ),
          Text(
            'No Rides Found',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 24),
            child: Text(
              'Your ride history is currently empty. Start your journey with MyTaxi by riding your first ride now!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
