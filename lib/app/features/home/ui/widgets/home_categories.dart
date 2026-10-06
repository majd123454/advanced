import 'package:swb_advance/app/core/helper/constants/image_constants.dart';
import 'package:swb_advance/app/core/helper/constants/text_strings.dart';
import 'package:swb_advance/app/core/widgets/horizontal_small_list_view.dart';
import 'package:swb_advance/app/features/home/data/models/horizontal_small_list_view_item_view_model.dart';
import 'package:flutter/material.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    const List<String> categoriesTitles = TTexts.categories;
    const List<String> categoriesImages = TImages.categoryIcons;

    final List<HorizontalSmallListViewItemModel> items = List.generate(
      categoriesImages.length,
      (index) => HorizontalSmallListViewItemModel(
        title: categoriesTitles[index],
        image: categoriesImages[index],
      ),
    );

    return SizedBox(height: 100, child: HorizontalSmallListView(items: items));
  }
}
