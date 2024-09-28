import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/theme/app_them_data.dart';
import 'package:driver/theme/responsive.dart';

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final Widget? errorWidget;
  final BoxFit? fit;
  final double? borderRadius;
  final Color? color;

  const NetworkImageWidget({
    super.key,
    this.height,
    this.width,
    this.fit,
    required this.imageUrl,
    this.borderRadius,
    this.errorWidget,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: CachedNetworkImage(
        fit: fit ?? BoxFit.cover,
        height: height ?? Responsive.height(8, context),
        width: width ?? Responsive.width(15, context),
        imageUrl: imageUrl,
        color: color,
        progressIndicatorBuilder: (context, url, downloadProgress) => Constant.loader(),
        errorWidget: (context, url, error) => Container(
          height: height ?? Responsive.height(8, context),
          width: width ?? Responsive.width(15, context),
          color: AppThemData.grey500,
          child: errorWidget ??
              Image.asset(
                Constant.placeHolder,
                height: height ?? Responsive.height(8, context),
                width: width ?? Responsive.width(15, context),
              ),
        ),
      ),
    );
  }
}
