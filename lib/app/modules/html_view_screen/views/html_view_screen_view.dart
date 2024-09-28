import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/html_view_screen_controller.dart';

class HtmlViewScreenView extends GetView<HtmlViewScreenController> {
  final String title;
  final String htmlData;

  const HtmlViewScreenView({
    super.key,
    required this.title,
    required this.htmlData,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white,
      // appBar: AppBarWithBorder(title: title.toString().tr, bgColor: themeChange.isDarkTheme() ? AppThemData.black : AppThemData.white),
      body: SingleChildScrollView(
        child: Center(
          child: HtmlWidget(
            htmlData.toString(),
            textStyle: DefaultTextStyle.of(context).style,
            key: const Key('uniqueKey'),
          ),
        ),
      ),
    );
  }
}
