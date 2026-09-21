import 'package:swb_advance/app/core/helper/spacing.dart';
import 'package:swb_advance/app/core/models/circular_icon_view_model.dart';
import 'package:swb_advance/app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class CircularIcon extends StatelessWidget {
  const CircularIcon({super.key, required this.circularIconModel});
  final CircularIconModel circularIconModel;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      height: circularIconModel.height,
      width: circularIconModel.width,
      decoration: BoxDecoration(
        color:
            circularIconModel.backgroundColor ??
            (dark
                ? AppColors.black.withValues(alpha: .9)
                : AppColors.white.withValues(alpha: .9)),
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      child: IconButton(
        onPressed: circularIconModel.onPressed,
        icon: Icon(
          circularIconModel.icon,
          size: circularIconModel.iconSize,
          color: circularIconModel.color,
        ),
      ),
    );
  }
}

//circular icon model
