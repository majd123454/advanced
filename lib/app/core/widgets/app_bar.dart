import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:swb_advance/app/core/helper/constants/device_utility.dart';
import 'package:swb_advance/app/core/helper/spacing.dart';
import 'package:swb_advance/app/core/models/app_bar_view_model.dart';
import 'package:swb_advance/app/core/theming/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.appBarModel});
  final AppBarModel appBarModel;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: appBarModel.padding,
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: appBarModel.hasArrowBack!
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Iconsax.arrow_left,
                  color: dark ? AppColors.white : AppColors.black,
                ),
              )
            : appBarModel.leadingIcon != null
            ? IconButton(
                onPressed: () {
                  appBarModel.leadingOnPressed!();
                },
                icon: Icon(appBarModel.leadingIcon),
              )
            : null,
        title: appBarModel.title,
        actions: appBarModel.actions,
        centerTitle: appBarModel.centerTitle,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
