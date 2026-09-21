import 'package:flutter/material.dart';

class ProductPriceText extends StatelessWidget {
  const ProductPriceText({super.key, required this.productPriceTextModel});
  final ProductPriceTextModel productPriceTextModel;
  @override
  Widget build(BuildContext context) {
    return Text(
      productPriceTextModel.currencySymbol + productPriceTextModel.price,
      maxLines: productPriceTextModel.maxLines,
      overflow: TextOverflow.ellipsis,
      style: productPriceTextModel.smallSize
          ? Theme.of(context).textTheme.bodyLarge!.apply(
              decoration: productPriceTextModel.lineThrough
                  ? TextDecoration.lineThrough
                  : null,
            )
          : Theme.of(context).textTheme.headlineMedium!.apply(
              decoration: productPriceTextModel.lineThrough
                  ? TextDecoration.lineThrough
                  : null,
            ),
    );
  }
}

class ProductPriceTextModel {
  final String price;
  final bool lineThrough;
  final bool smallSize;
  final String currencySymbol;
  final int maxLines;

  ProductPriceTextModel({
    required this.price,
    this.lineThrough = false,
    this.smallSize = false,
    this.currencySymbol = "\$",
    this.maxLines = 1,
  });
}

