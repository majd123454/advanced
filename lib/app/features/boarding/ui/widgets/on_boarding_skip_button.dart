import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swb_advance/app/core/helper/constants/text_strings.dart';
import 'package:swb_advance/app/features/boarding/logic/on_boarding_cubit.dart';

class OnBoardingSkipButton extends StatelessWidget {
  const OnBoardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 56.0,
      right: 24,
      child: TextButton(
        onPressed: () {
          context.read<OnBoardingCubit>().skipPage();
        },
        child: Text(TTexts.skip),
      ),
    );
  }
}
