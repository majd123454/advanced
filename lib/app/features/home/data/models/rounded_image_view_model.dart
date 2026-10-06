import 'package:swb_advance/app/core/helper/constants/sizes.dart';
import 'package:swb_advance/app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class RoundedImageModel {
  final String image;
  final double? height, width;
  final bool applyImageRadius;
  final Color? backgroundColor;
  final BoxBorder? border;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final void Function()? onTap;
  final double borderRadius;
  final Color? overlayColor;

  RoundedImageModel({
    this.overlayColor,
    required this.image,
    this.height,
    this.width,
    this.applyImageRadius = false,
    this.backgroundColor = AppColors.light,
    this.border,
    this.fit = BoxFit.contain,
    this.padding,
    this.isNetworkImage = false,
    this.onTap,
    this.borderRadius = TSizes.md,
  });
}
