import 'package:swb_advance/app/core/theming/app_colors.dart';
import 'package:swb_advance/app/core/widgets/circular_container.dart';
import 'package:swb_advance/app/core/widgets/circular_container_view_model.dart';
import 'package:swb_advance/app/core/widgets/curved_widget.dart';
import 'package:flutter/material.dart';

class PrimaryHeaderContainer extends StatelessWidget {
  const PrimaryHeaderContainer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return CurvedWidget(
      child: Container(
        color: AppColors.primary,
        padding: EdgeInsets.zero,
        child: SizedBox(
          child: Stack(
            children: [
              Positioned(
                top: -150,
                right: -250,
                child: CircularContainer(
                  circularContainerModel: CircularContainerModel(
                    height: 400,
                    width: 400,
                    borderRadius: 400,
                    color: AppColors.textWhite.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Positioned(
                right: -300,
                top: 100,
                child: CircularContainer(
                  circularContainerModel: CircularContainerModel(
                    height: 400,
                    width: 400,
                    borderRadius: 400,
                    color: AppColors.textWhite.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
