import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class PickDropPointView extends StatelessWidget {
  final String pickUpAddress;
  final String dropAddress;
  const PickDropPointView({
    super.key, required this.pickUpAddress, required this.dropAddress,
  });

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      width: Responsive.width(100, context),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: themeChange.isDarkTheme() ? AppThemData.primary950 : AppThemData.primary50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Timeline.tileBuilder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        theme: TimelineThemeData(
          nodePosition: 0,
          indicatorPosition: 0,
        ),
        builder: TimelineTileBuilder.connected(
          contentsAlign: ContentsAlign.basic,
          indicatorBuilder: (context, index) {
            return index == 0 ? SvgPicture.asset("assets/icon/ic_pick_up.svg") : SvgPicture.asset("assets/icon/ic_drop_in.svg");
          },
          connectorBuilder: (context, index, connectorType) {
            return DashedLineConnector(
              color: themeChange.isDarkTheme() ? AppThemData.grey600 : AppThemData.grey300,
            );
          },
          contentsBuilder: (context, index) => index == 0
              ? Container(
                  width: Responsive.width(100, context),
                  // padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pickup Point',
                        style: GoogleFonts.inter(
                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        pickUpAddress,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                )
              : Container(
                  width: Responsive.width(100, context),
                  // padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dropout Point',
                        style: GoogleFonts.inter(
                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        dropAddress,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: themeChange.isDarkTheme() ? AppThemData.grey25 : AppThemData.grey950,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
          itemCount: 2,
        ),
      ),
    );
  }
}
