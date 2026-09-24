import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swb_advance/app/core/helper/constants/image_constants.dart';
import 'package:swb_advance/app/core/helper/constants/text_strings.dart';
import 'package:swb_advance/app/features/boarding/data/models/on_page_model.dart';
import 'package:swb_advance/app/features/boarding/logic/on_boarding_cubit.dart';
import 'package:swb_advance/app/features/boarding/ui/widgets/on_boarding_dot_navigation.dart';
import 'package:swb_advance/app/features/boarding/ui/widgets/on_boarding_next_button.dart';
import 'package:swb_advance/app/features/boarding/ui/widgets/on_boarding_page.dart';
import 'package:swb_advance/app/features/boarding/ui/widgets/on_boarding_skip_button.dart';

class BoardingScreen extends StatelessWidget {
  const BoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: context.read<OnBoardingCubit>().pageController,
            onPageChanged: (index) {
              context.read<OnBoardingCubit>().updatePageIndicator(index);
            },
            children: [
              OnBoardingPage(
                onBoardingModel: OnPageModel(
                  image: TImages.onBoardingImage1,
                  title: TTexts.onBoardingTitle1,
                  subTitle: TTexts.onBoardingSubTitle1,
                ),
              ),
              OnBoardingPage(
                onBoardingModel: OnPageModel(
                  image: TImages.onBoardingImage2,
                  title: TTexts.onBoardingTitle2,
                  subTitle: TTexts.onBoardingSubTitle2,
                ),
              ),
              OnBoardingPage(
                onBoardingModel: OnPageModel(
                  image: TImages.onBoardingImage3,
                  title: TTexts.onBoardingTitle3,
                  subTitle: TTexts.onBoardingSubTitle3,
                ),
              ),
            ],
          ),
          OnBoardingSkipButton(),
          OnBoardingDotNavigation(),
          OnBoardingNextButton(),
        ],
      ),
    );
  }
}
