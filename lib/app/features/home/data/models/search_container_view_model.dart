import 'package:swb_advance/app/core/helper/constants/sizes.dart';
import 'package:swb_advance/app/core/helper/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchContainerModel {
  final IconData? icon;
  final String title;
  final bool showBackground, showBorder;
  final void Function()? onPressed;
  final EdgeInsetsGeometry padding;
  SearchContainerModel({
    this.padding = const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
    this.onPressed,
    this.icon = Iconsax.search_normal,
    this.title = TTexts.searchContainer,
    this.showBackground = true,
    this.showBorder = true,
  });
}
