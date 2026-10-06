import 'package:swb_advance/app/core/di/service_locator.dart';
import 'package:swb_advance/app/features/home/logic/cubit/product_cubit.dart';
import 'package:swb_advance/app/features/home/ui/home_screen.dart';
import 'package:swb_advance/app/features/navigation_bar/logic/cubit/navigation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationInitialState());

  late final List<Widget> screens;

  void initializeScreensList() {
    screens = [
      BlocProvider(
        create: (BuildContext context) => sl<ProductCubit>()..getProducts(),
        child: const HomeView(),
      ),
      // BlocProvider(
      //   create: (_) => ChatCubit(repository: sl())
      //     ..startListening()
      //     ..getMessages(currentUserId),
      //   child: const ChatScreen(),
      // ),
      // const WishlistView(),
      // const SettingsView(),
    ];
  }

  int selectedIndex = 0;

  void updateSelectedIndex(int index) {
    selectedIndex = index;
    emit(ChangeSelectedIndex(selectedIndex));
  }

  Widget getScreen(int index) {
    return screens[index];
  }
}
