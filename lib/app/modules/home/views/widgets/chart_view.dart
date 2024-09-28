import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:driver/app/modules/home/controllers/home_controller.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';

class ChartView extends StatelessWidget {
  const ChartView({
    super.key,
    required this.themeChange,
  });

  final DarkThemeProvider themeChange;

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: HomeController(),
        builder: (controller) {
          return Row(
            children: [
              PieChart(
                dataMap: controller.dataMap,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 3.2,
                colorList: controller.colorList,
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: 15,
                centerWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total Rides'.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      controller.totalRides.value.toString(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                legendOptions: LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.right,
                  showLegends: false,
                  legendShape: BoxShape.circle,
                  legendTextStyle: GoogleFonts.inter(
                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: false,
                  showChartValues: false,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
              ),
              const SizedBox(width: 36),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: controller.dataMap.entries
                    .map((key) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: key.key == "New"
                                      ? controller.colorList[0]
                                      : key.key == "Ongoing"
                                          ? controller.colorList[1]
                                          : key.key == "Completed"
                                              ? controller.colorList[2]
                                              : key.key == "Rejected"
                                                  ? controller.colorList[3]
                                                  : controller.colorList[4],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  key.key.tr,
                                  style: GoogleFonts.inter(
                                    color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Text(
                                key.value.toInt().toString(),
                                textAlign: TextAlign.right,
                                style: GoogleFonts.inter(
                                  color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ],
          );
        });
  }
}
