// import 'package:swb_advance/app/core/helper/constants/sizes.dart';
// import 'package:swb_advance/app/core/helper/extensions.dart';
// import 'package:swb_advance/app/core/helper/spacing.dart';
// import 'package:swb_advance/app/core/models/circular_icon_view_model.dart';
// import 'package:swb_advance/app/core/routing/routes.dart';
// import 'package:swb_advance/app/core/theming/app_colors.dart';
// import 'package:swb_advance/app/core/widgets/brand_title_with_verification.dart';
// import 'package:swb_advance/app/core/widgets/circular_icon.dart';
// import 'package:swb_advance/app/core/widgets/product_price_text.dart';
// import 'package:swb_advance/app/core/widgets/product_title_text.dart';
// import 'package:swb_advance/app/core/widgets/sale_tag.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';

// class VerticalProductCard extends StatelessWidget {
//   const VerticalProductCard({super.key, required this.product});
//   final ProductEntity product;
//   @override
//   Widget build(BuildContext context) {
//     final dark = THelperFunctions.isDarkMode(context);
//     return GestureDetector(
//       onTap: () {
//         context.pushNamed(Routes.productDetails);
//       },
//       child: Container(
//         width: 180,
//         padding: const EdgeInsets.all(1),
//         decoration: BoxDecoration(
//           // boxShadow: [TShadowStyle.verticalProductCardShadow],
//           borderRadius: const BorderRadius.all(
//             Radius.circular(TSizes.productImageRadius),
//           ),
//           color: dark ? AppColors.darkerGrey : AppColors.white,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             CircularContainer(
//               circularContainerModel: CircularContainerModel(
//                 padding: const EdgeInsets.all(TSizes.sm),
//                 height: 180,
//                 color: dark ? AppColors.dark : AppColors.light,
//                 child: Stack(
//                   children: [
//                     RoundedImage(
//                       roundedImageModel: RoundedImageModel(
//                         isNetworkImage: true,
//                         backgroundColor: dark
//                             ? AppColors.dark
//                             : AppColors.light,
//                         image: product.images.first,
//                         onTap: () {},
//                         applyImageRadius: true,
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         SaleTag(
//                           discountPercentage: double.parse(
//                             product.discountPercentage.toStringAsFixed(1),
//                           ),
//                         ),
//                         CircularIcon(
//                           circularIconModel: CircularIconModel(
//                             height: TSizes.iconLg * 1.2,
//                             width: TSizes.iconLg * 1.2,
//                             iconSize: TSizes.iconMd,
//                             icon: Iconsax.heart5,
//                             color: Colors.red,
//                             backgroundColor: dark
//                                 ? AppColors.darkerGrey
//                                 : AppColors.white,
//                             onPressed: () {},
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: TSizes.sm),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ProductTitleText(
//                     productTitleTextModel: ProductTitleTextModel(
//                       title: product.name,
//                     ),
//                   ),
//                   const SizedBox(height: TSizes.spaceBtwItems / 2),
//                   BrandTitleWithVerification(
//                     brandTitleWithVerificationModel:
//                         BrandTitleWithVerificationModel(
//                           brandName: product.brandName ?? '',
//                         ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: ProductPriceText(
//                           productPriceTextModel: ProductPriceTextModel(
//                             currencySymbol: "\$",
//                             price: product.price.toString(),
//                             maxLines: 1,
//                             smallSize: true,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         decoration: const BoxDecoration(
//                           color: AppColors.dark,
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(TSizes.cardRadiusMd),
//                             bottomRight: Radius.circular(
//                               TSizes.productImageRadius,
//                             ),
//                           ),
//                         ),
//                         child: SizedBox(
//                           width: TSizes.iconLg * 1.2,
//                           height: TSizes.iconLg * 1.2,
//                           child: Center(
//                             child: IconButton(
//                               onPressed: () {},
//                               icon: const Icon(Iconsax.add),
//                               color: AppColors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
