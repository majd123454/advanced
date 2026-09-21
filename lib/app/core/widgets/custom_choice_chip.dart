// import 'package:swb_advance/app/core/helper/spacing.dart';
// import 'package:swb_advance/app/core/models/choice_chip_view_model.dart';
// import 'package:swb_advance/app/core/theming/app_colors.dart';
// import 'package:swb_advance/app/features/home/data/models/circular_container_view_model.dart';
// import 'package:swb_advance/app/features/home/ui/widgets/circular_container.dart';
// import 'package:flutter/material.dart';

// class CustomChoiceChip extends StatelessWidget {
//   //CustomChoiceChip >>
//   const CustomChoiceChip({super.key, required this.choiceChipModel});
//   final ChoiceChipModel choiceChipModel;
//   @override
//   Widget build(BuildContext context) {
//     final isColor = THelperFunctions.getColor(choiceChipModel.label) != null;
//     return Theme(
//       data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
//       child: ChoiceChip(
//         avatar: isColor
//             ? CircularContainer(
//                 circularContainerModel: CircularContainerModel(
//                   width: 50,
//                   height: 50,
//                   color: THelperFunctions.getColor(choiceChipModel.label),
//                 ),
//               )
//             : null,
//         labelPadding: isColor ? const EdgeInsets.all(0) : null,
//         padding: isColor ? const EdgeInsets.all(0) : null,
//         shape: isColor ? const CircleBorder() : null,
//         label: isColor ? const SizedBox() : Text(choiceChipModel.label),
//         selected: choiceChipModel.selected,
//         onSelected: choiceChipModel.onSelected,
//         backgroundColor: isColor
//             ? THelperFunctions.getColor(choiceChipModel.label)
//             : null,
//         labelStyle: TextStyle(
//           color: choiceChipModel.selected ? AppColors.white : null,
//         ),
//       ),
//     );
//   }
// }
