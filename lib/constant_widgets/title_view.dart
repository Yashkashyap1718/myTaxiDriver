import 'package:flutter/material.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TitleView extends StatelessWidget {
  final String titleText;
  final EdgeInsetsGeometry padding;

  const TitleView({
    super.key,
    required this.titleText,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: padding,
      child: Text(
        titleText,
        style: GoogleFonts.inter(
          color: themeChange.isDarkTheme() ? AppThemData.grey25 :AppThemData.grey950,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
