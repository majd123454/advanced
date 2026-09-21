// import 'package:swb_advance/app/core/helper/constants/device_utility.dart';
// import 'package:swb_advance/app/core/helper/constants/sizes.dart';
// import 'package:swb_advance/app/core/helper/spacing.dart';
// import 'package:swb_advance/app/core/theming/app_colors.dart';
// import 'package:flutter/material.dart';

// class SearchContainer extends StatelessWidget {
//   const SearchContainer({super.key, required this.searchContainerModel});
//   final SearchContainerModel searchContainerModel;
//   @override
//   Widget build(BuildContext context) {
//     final dark = THelperFunctions.isDarkMode(context);
//     return Padding(
//       padding: searchContainerModel.padding,
//       child: GestureDetector(
//         onTap: searchContainerModel.onPressed,
//         child: Container(
//           width: TDeviceUtils.getScreenWidth(context),
//           padding: const EdgeInsets.all(TSizes.md),
//           decoration: BoxDecoration(
//             color: searchContainerModel.showBackground
//                 ? dark
//                       ? AppColors.dark
//                       : AppColors.light
//                 : Colors.transparent,
//             borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
//             border: searchContainerModel.showBorder
//                 ? Border.all(color: AppColors.grey)
//                 : null,
//           ),
//           child: Row(
//             children: [
//               Icon(searchContainerModel.icon, color: AppColors.darkGrey),
//               const SizedBox(width: TSizes.spaceBtwItems),
//               Text(
//                 searchContainerModel.title,
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// //search container model
