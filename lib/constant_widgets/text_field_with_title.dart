import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TextFieldWithTitle extends StatelessWidget {
  final String title;
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final bool? isEnable;
  final validator;

  const TextFieldWithTitle({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.isEnable,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950, fontWeight: FontWeight.w500),
        ),
        Container(
          transform: Matrix4.translationValues(0.0, -05.0, 0.0),
          child: TextFormField(
            cursorColor: Colors.black,
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            enabled: isEnable,
            validator: validator,
            style: GoogleFonts.inter(fontSize: 14, color: themeChange.isDarkTheme() ? AppThemData.white : AppThemData.grey950, fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
              border: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
              errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
              disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppThemData.grey500, width: 1)),
              prefixIcon: prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: prefixIcon,
                    )
                  : null,
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: suffixIcon,
                    )
                  : null,
              hintText: hintText,
              hintStyle: GoogleFonts.inter(fontSize: 14, color: AppThemData.grey500, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
}
