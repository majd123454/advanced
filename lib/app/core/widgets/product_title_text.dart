import 'package:flutter/material.dart';

class ProductTitleText extends StatelessWidget {
  const ProductTitleText({super.key, required this.productTitleTextModel});
  //ProductTitleText >> product_title_text.dart
  final ProductTitleTextModel productTitleTextModel;
  @override
  Widget build(BuildContext context) {
    return Text(
      productTitleTextModel.title,
      maxLines: productTitleTextModel.maxLines,
      textAlign: productTitleTextModel.textAlign,
      overflow: TextOverflow.ellipsis,
      style: productTitleTextModel.smallSize
          ? Theme.of(context).textTheme.labelLarge
          : Theme.of(context).textTheme.bodyLarge,
    );
  }
}

class ProductTitleTextModel {
  //ProductTitleTextModel >> product_title_text_model.dart
  final String title;
  final bool smallSize;
  final int maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  ProductTitleTextModel({
    required this.title,
    this.smallSize = false,
    this.maxLines = 2,
    this.textAlign = TextAlign.left,
    this.overflow,
  });
}

