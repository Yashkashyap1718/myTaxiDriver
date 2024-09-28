import 'package:flutter/material.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class AppBarWithBorder extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color bgColor;
  final bool? isUnderlineShow;

  const AppBarWithBorder({
    super.key,
    required this.title,
    required this.bgColor,
    this.isUnderlineShow,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return AppBar(
      backgroundColor: bgColor,
        automaticallyImplyLeading: true,
      shape: (isUnderlineShow ?? true) ?  Border(bottom: BorderSide(color: themeChange.isDarkTheme()? AppThemData.grey800 : AppThemData.grey100, width: 1)) : null,
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: themeChange.isDarkTheme()? AppThemData.white : AppThemData.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
