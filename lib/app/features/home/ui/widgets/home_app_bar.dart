import 'package:swb_advance/app/core/helper/constants/text_strings.dart';
import 'package:swb_advance/app/core/models/app_bar_view_model.dart';
import 'package:swb_advance/app/core/models/cart_counter_icon_view_model.dart';
import 'package:swb_advance/app/core/theming/app_colors.dart';
import 'package:swb_advance/app/core/widgets/app_bar.dart';
import 'package:swb_advance/app/core/widgets/cart_counter_icon.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      appBarModel: AppBarModel(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              TTexts.homeAppbarTitle,
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.apply(color: AppColors.grey),
            ),
            Text(
              TTexts.homeAppbarSubTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall!.apply(color: AppColors.white),
            ),
          ],
        ),
        actions: [
          CartCounterIcon(
            cartCounterIconModel: CartCounterIconModel(
              color: AppColors.white,
              onPressed: () {
                // THelperFunctions.navigateToScreen(context, const CartView());
              },
            ),
          ),
        ],
      ),
    );
  }
}
