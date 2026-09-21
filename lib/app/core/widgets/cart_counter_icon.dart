import 'package:swb_advance/app/core/models/cart_counter_icon_view_model.dart';
import 'package:swb_advance/app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CartCounterIcon extends StatelessWidget {
  const CartCounterIcon({super.key, required this.cartCounterIconModel});
  final CartCounterIconModel cartCounterIconModel;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: cartCounterIconModel.onPressed,
          icon: Icon(Iconsax.shopping_bag, color: cartCounterIconModel.color),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: AppColors.black,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                cartCounterIconModel.count.toString(),
                style: Theme.of(context).textTheme.labelLarge!.apply(
                  color: AppColors.white,
                  fontSizeFactor: .8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
