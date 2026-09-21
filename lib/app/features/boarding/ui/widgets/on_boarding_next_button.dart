import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:swb_advance/app/features/boarding/logic/on_boarding_cubit.dart';

import '../../../../core/helper/spacing.dart';
import '../../../../core/theming/app_colors.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});
  @override
  Widget build(BuildContext context) {
    print("object");

    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      bottom: 56 + 25,
      right: 24,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: dark ? AppColors.primary : Colors.black,
        ),
        onPressed: (() {
          context.read<OnBoardingCubit>().goToNextPage(context);
        }),
        child: const Icon(Iconsax.arrow_right_3),
      ),
    );
  }
}
