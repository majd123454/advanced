import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swb_advance/app/core/helper/constants/image_constants.dart';
import 'package:swb_advance/app/core/helper/constants/text_strings.dart';
import 'package:swb_advance/app/core/helper/extensions.dart';
import 'package:swb_advance/app/core/helper/spacing.dart';
import 'package:swb_advance/app/core/routing/routes.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              context.pushReplacementNamed(Routes.login);
            },
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Image(
                  width: THelperFunctions.screenWidth(context) * .6,
                  image: const AssetImage(TImages.deliveredEmailIllustration),
                ),
                const SizedBox(height: 32),
                Text(
                  TTexts.confirmEmailTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  TTexts.confirmEmail,
                  style: Theme.of(context).textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  TTexts.confirmEmailSubTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      //
                    },
                    child: const Text(TTexts.tContinue),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(TTexts.resendEmail),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
