import 'package:swb_advance/app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class HorizontalSmallListViewItemModel {
  final String title;
  final String image;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  HorizontalSmallListViewItemModel({
    required this.title,
    required this.image,
    this.textColor = AppColors.white,
    this.backgroundColor,
    this.onTap,
  });
}
