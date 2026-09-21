import 'package:flutter/material.dart';
import 'package:swb_advance/app/core/theming/app_colors.dart';

class CartCounterIconModel {
  final VoidCallback? onPressed;
  final Color? color;
  final int? count;
  CartCounterIconModel({
    this.count = 0,
    this.onPressed,
    this.color = AppColors.white,
  });
}
