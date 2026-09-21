import 'package:swb_advance/app/core/helper/constants/sizes.dart';
import 'package:swb_advance/app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:swb_advance/app/core/widgets/circular_container.dart';
import 'package:swb_advance/app/core/widgets/circular_container_view_model.dart';

class SaleTag extends StatelessWidget {
  const SaleTag({super.key, required this.discountPercentage});
  final double discountPercentage;
  @override
  Widget build(BuildContext context) {
    return CircularContainer(
      circularContainerModel: CircularContainerModel(
        padding: const EdgeInsets.symmetric(
          horizontal: TSizes.sm,
          vertical: TSizes.xs,
        ),
        borderRadius: TSizes.sm,
        color: AppColors.secondary.withValues(alpha: .8),
        child: Text(
          '$discountPercentage%',
          style: Theme.of(
            context,
          ).textTheme.labelLarge!.apply(color: AppColors.black),
        ),
      ),
    );
  }
}
