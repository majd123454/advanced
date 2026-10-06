import 'package:swb_advance/app/core/helper/logger.dart';
import 'package:swb_advance/app/core/helper/spacing.dart';
import 'package:swb_advance/app/core/services/notifications/firebase_cloud_messaging.dart';
import 'package:swb_advance/app/core/theming/app_colors.dart';
import 'package:swb_advance/app/features/navigation_bar/logic/cubit/navigation_cubit.dart';
import 'package:swb_advance/app/features/navigation_bar/logic/cubit/navigation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NavigationButton extends StatefulWidget {
  const NavigationButton({super.key});

  @override
  State<NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton> {
  @override
  void initState() {
    super.initState();
    saveFcmToken();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: NavigationBar(
            elevation: 0,
            backgroundColor: dark ? AppColors.black : AppColors.white,
            height: 80,
            indicatorColor: dark
                ? AppColors.black.withOpacity(.5)
                : AppColors.grey,
            selectedIndex: state is ChangeSelectedIndex
                ? state.selectedIndex
                : 0,
            onDestinationSelected: (int index) {
              context.read<NavigationCubit>().updateSelectedIndex(index);
            },
            destinations: [
              NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
              NavigationDestination(
                icon: Icon(Iconsax.message_search),
                label: 'Chat',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.favorite_chart),
                label: 'Favorites',
              ),
              NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
            ],
          ),
          body: context.read<NavigationCubit>().getScreen(
            state is ChangeSelectedIndex ? state.selectedIndex : 0,
          ),
        );
      },
    );
  }
}

Future<void> saveFcmToken() async {
  await NotificationService.instance.requestPermission();

  final token = await NotificationService.instance.getFcmToken();

  logger("-------------------------------");
  logger("fcm : $token");
  logger("-------------------------------");

  final userId = Supabase.instance.client.auth.currentUser?.id;

  if (userId != null && token != null) {
    await Supabase.instance.client
        .from('profiles')
        .update({'fcm_token': token})
        .eq('id', userId);
  }
}
