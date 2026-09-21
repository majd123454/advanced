import 'package:swb_advance/app/core/widgets/success_view.dart';
import 'package:flutter/material.dart';

import '../helper/constants/image_constants.dart';
import '../helper/constants/text_strings.dart';
import '../helper/extensions.dart';
import '../models/success_model.dart';
import '../routing/routes.dart';

class EmailVerifiedSuccessfully extends StatelessWidget {
  const EmailVerifiedSuccessfully({super.key});

  @override
  Widget build(BuildContext context) {
    return SuccessView(
      successModel: SuccessModel(
        image: TImages.staticSuccessIllustration,
        title: TTexts.yourAccountCreatedTitle,
        subTitle: TTexts.yourAccountCreatedSubTitle,
        buttonText: TTexts.tContinue,
        onPressed: () {
          // context.pushReplacementNamed(Routes.login);
        },
      ),
    );
  }
}
