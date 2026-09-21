//brand_title_with_verification.dart
import 'package:swb_advance/app/core/helper/constants/sizes.dart';
import 'package:swb_advance/app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BrandTitleWithVerification extends StatelessWidget {
  const BrandTitleWithVerification({
    super.key,
    required this.brandTitleWithVerificationModel,
  });
  final BrandTitleWithVerificationModel brandTitleWithVerificationModel;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            brandTitleWithVerificationModel.brandName,
            style: Theme.of(context).textTheme.labelLarge,
            maxLines: brandTitleWithVerificationModel.maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: TSizes.xs),
        Icon(
          Iconsax.verify5,
          color: brandTitleWithVerificationModel.iconColor,
          size: TSizes.iconXs,
        ),
      ],
    );
  }
}

class BrandTitleWithVerificationModel {
  final String brandName;
  final Color iconColor;
  final int maxLines;
  final TextAlign textAlign;
  const BrandTitleWithVerificationModel({
    required this.brandName,
    this.iconColor = AppColors.primary,
    this.maxLines = 1,
    this.textAlign = TextAlign.center,
  });
}
