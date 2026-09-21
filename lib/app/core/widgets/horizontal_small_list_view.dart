import 'package:swb_advance/app/core/helper/constants/sizes.dart';
import 'package:swb_advance/app/core/helper/spacing.dart';
import 'package:swb_advance/app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class HorizontalSmallListView extends StatelessWidget {
  const HorizontalSmallListView({super.key, required this.items});
  // final List<HorizontalSmallListViewItemModel> items;
  final List<dynamic> items;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final dark = THelperFunctions.isDarkMode(context);
        return GestureDetector(
          // onTap: () =>
          // THelperFunctions.navigateToScreen(context, const SubCategoryView()),
          child: Padding(
            padding: const EdgeInsets.only(right: TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 56,
                  width: 56,
                  padding: const EdgeInsets.all(TSizes.sm),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    color:
                        items[index].backgroundColor ??
                        (dark ? AppColors.white : AppColors.black),
                  ),
                  child: Center(
                    child: Image(
                      image: AssetImage(items[index].image),
                      fit: BoxFit.cover,
                      color: dark ? AppColors.black : AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                Text(
                  items[index].title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium!.apply(color: items[index].textColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
