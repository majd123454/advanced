// ignore_for_file: depend_on_referenced_packages

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swb_advance/app/core/helper/extensions.dart';
import 'package:swb_advance/app/core/routing/routes.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitial());
  final PageController pageController = PageController();
  int currentIndex = 0;

  void onDotClicked(int index) {
    currentIndex = index;
    pageController.jumpToPage(currentIndex);
    emit(OnBoardingUpdateIndicator());
  }

  void goToNextPage(BuildContext context) {
    if (currentIndex != 2) {
      currentIndex++;

      pageController.jumpToPage(currentIndex);
      emit(OnBoardingUpdateIndicator());
    } else {
      context.pushNamed(Routes.login);
    }
  }

  void updatePageIndicator(int index) {
    currentIndex = index;
    emit(OnBoardingUpdateIndicator());
  }

  void skipPage() {
    currentIndex = 2;
    pageController.jumpToPage(currentIndex);
    emit(OnBoardingUpdateIndicator());
  }
}
