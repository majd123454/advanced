import 'package:swb_advance/app/core/helper/constants/sizes.dart';
import 'package:swb_advance/app/features/home/data/models/grid_layout_view_model.dart';
import 'package:flutter/material.dart';

class GridLayout extends StatelessWidget {
  const GridLayout({super.key, required this.gridLayoutModel});
  final GridLayoutModel gridLayoutModel;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: gridLayoutModel.itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: TSizes.gridViewSpacing,
        crossAxisSpacing: TSizes.gridViewSpacing,
        mainAxisExtent: gridLayoutModel.mainAxisExtent,
        crossAxisCount: 2,
      ),
      itemBuilder: gridLayoutModel.itemBuilder,
    );
  }
}
