// import 'package:swb_advance/app/core/helper/constants/image_constants.dart';
// import 'package:swb_advance/app/core/helper/constants/sizes.dart';
// import 'package:swb_advance/app/core/helper/constants/text_strings.dart';
// import 'package:swb_advance/app/core/models/app_bar_view_model.dart';
// import 'package:swb_advance/app/core/theming/app_colors.dart';
// import 'package:swb_advance/app/core/widgets/app_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';

// class SettingsViewHeaderSection extends StatelessWidget {
//   const SettingsViewHeaderSection({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CustomAppBar(
//           appBarModel: AppBarModel(
//             title: Text(
//               TTexts.account,
//               style: Theme.of(
//                 context,
//               ).textTheme.headlineMedium!.apply(color: AppColors.white),
//             ),
//           ),
//         ),
//         const SizedBox(height: TSizes.spaceBtwSections),
//         UserProfileTile(
//           userProfileTileModel: UserProfileTileModel(
//             title: "Mahmoud Hamdy",
//             subtitle: "hmdy7486@gmail.com",
//             onTap: () {
//               //THelperFunctions.navigateToScreen(context, const ProfileView()),
//             },
//             trailing: Iconsax.edit,
//             leading: TImages.user,
//           ),
//         ),
//         const SizedBox(height: TSizes.spaceBtwSections * 1.2),
//       ],
//     );
//   }
// }
