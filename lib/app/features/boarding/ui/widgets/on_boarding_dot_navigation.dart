import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:swb_advance/app/features/boarding/logic/on_boarding_cubit.dart';

import '../../../../core/helper/spacing.dart';
import '../../../../core/theming/app_colors.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({super.key});
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Positioned(
      bottom: 56.0 + 25,
      left: 24.0,
      child: SmoothPageIndicator(
        controller: context.read<OnBoardingCubit>().pageController,
        count: 3,
        axisDirection: Axis.horizontal,
        onDotClicked: (index) {
          context.read<OnBoardingCubit>().onDotClicked(index);
        },
        effect: ExpandingDotsEffect(
          dotHeight: 6,
          activeDotColor: dark ? AppColors.light : AppColors.dark,
        ),
      ),
    );
  }
}
