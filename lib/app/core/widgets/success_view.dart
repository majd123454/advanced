import 'package:flutter/material.dart';

import '../helper/spacing.dart';
import '../models/success_model.dart';

class SuccessView extends StatelessWidget {
  const SuccessView({super.key, required this.successModel});
  final SuccessModel successModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 56, left: 24, right: 24, bottom: 24),
            child: Column(
              children: [
                Image(
                  width: THelperFunctions.screenWidth(context) * .75,
                  image: AssetImage(successModel.image),
                ),
                const SizedBox(height: 24),
                Text(
                  successModel.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  successModel.subTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: successModel.onPressed,
                    child: Text(successModel.buttonText),
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
