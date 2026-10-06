import 'package:cached_network_image/cached_network_image.dart';
import 'package:swb_advance/app/core/helper/spacing.dart';
import 'package:swb_advance/app/core/theming/app_colors.dart';
import 'package:swb_advance/app/features/home/data/models/rounded_image_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class RoundedImage extends StatelessWidget {
  RoundedImage({super.key, required this.roundedImageModel, this.banner});
  final RoundedImageModel roundedImageModel;
  bool? banner = false;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: roundedImageModel.onTap,
      child: Container(
        width: roundedImageModel.width,
        height: roundedImageModel.height,
        decoration: BoxDecoration(
          border: roundedImageModel.border,
          borderRadius: BorderRadius.circular(roundedImageModel.borderRadius),
          color: roundedImageModel.backgroundColor,
        ),
        child: ClipRRect(
          borderRadius: roundedImageModel.applyImageRadius
              ? BorderRadius.circular(roundedImageModel.borderRadius)
              : BorderRadius.zero,
          child: roundedImageModel.isNetworkImage
              ? CachedNetworkImage(
                  imageUrl: roundedImageModel.image,
                  placeholderFadeInDuration: Duration.zero,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: dark ? Colors.grey[850]! : Colors.grey[300]!,
                    highlightColor: dark
                        ? Colors.grey[700]!
                        : Colors.grey[100]!,
                    child: Container(
                      width: roundedImageModel.width,
                      height: roundedImageModel.height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: roundedImageModel.applyImageRadius
                            ? BorderRadius.circular(
                                roundedImageModel.borderRadius,
                              )
                            : null,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: roundedImageModel.width,
                    height: roundedImageModel.height,
                    decoration: BoxDecoration(
                      color: dark ? AppColors.darkerGrey : AppColors.light,
                      borderRadius: roundedImageModel.applyImageRadius
                          ? BorderRadius.circular(
                              roundedImageModel.borderRadius,
                            )
                          : null,
                    ),
                    child: Icon(
                      Icons.error,
                      color: dark ? AppColors.light : AppColors.dark,
                    ),
                  ),
                  color: roundedImageModel.overlayColor,
                  fit: roundedImageModel.fit,
                )
              : Image(
                  image: banner ?? false
                      ? NetworkImage(roundedImageModel.image)
                      : AssetImage(roundedImageModel.image),
                  color: roundedImageModel.overlayColor,
                  fit: roundedImageModel.fit,
                ),
        ),
      ),
    );
  }
}
