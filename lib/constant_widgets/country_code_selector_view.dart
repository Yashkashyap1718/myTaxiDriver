import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CountryCodeSelectorView extends StatelessWidget {
  final ValueChanged<CountryCode>? onChanged;
  final TextEditingController countryCodeController;
  final bool isEnable;
  final bool isCountryNameShow;
  const CountryCodeSelectorView({super.key, required this.onChanged, required this.countryCodeController, required this.isEnable, required this.isCountryNameShow});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return CountryCodePicker(
      onChanged: onChanged,
      enabled: isEnable,
      dialogTextStyle: GoogleFonts.inter(color: AppThemData.grey08, fontWeight: FontWeight.w500),
      dialogBackgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
      initialSelection: countryCodeController.text,
      comparator: (a, b) => b.name!.compareTo(a.name.toString()),
      flagDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      showFlag: true,
      showCountryOnly: true,
      backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
      builder: (p0) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.only(right: 8.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              child: Image.asset(
                p0!.flagUri ?? '',
                package: 'country_code_picker',
                width: 26,
                height: 26,
              ),
            ),
            Text(
              isCountryNameShow ? p0.name ?? '' : p0.dialCode ?? '',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded)
          ],
        );
      },
      textStyle: GoogleFonts.inter(color: themeChange.isDarkTheme() ? AppThemData.white :AppThemData.grey08, fontWeight: FontWeight.w500),
      searchDecoration:  InputDecoration(iconColor:themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey08),
      searchStyle: GoogleFonts.inter(color: themeChange.isDarkTheme() ? AppThemData.white :AppThemData.grey08, fontWeight: FontWeight.w500),
    );
  }
}
