import 'package:flutter/material.dart';
import 'package:swb_advance/app/core/helper/constants/sizes.dart';
import 'package:swb_advance/app/core/theming/app_colors.dart';

class CircularContainerModel {
  final double? width;
  final double? height;
  final Color? color;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final bool showBorder;
  final Color borderColor;
  final EdgeInsetsGeometry? margin;

  CircularContainerModel({
    this.width,
    this.borderColor = AppColors.borderPrimary,
    this.showBorder = false,
    this.margin,
    this.child,
    this.height,
    this.color = AppColors.white,
    this.borderRadius = TSizes.cardRadiusLg,
    this.padding = EdgeInsets.zero,
  });
}
